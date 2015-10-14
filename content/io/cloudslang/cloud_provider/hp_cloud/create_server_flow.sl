#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Main flow to create a server instance with floating IP in HP Cloud
#
# Inputs:
#   - username - HP Cloud account username 
#   - password - HP Cloud account password 
#   - tenant_name - name of HP Cloud tenant e.g. 'bob.smith@hp.com-tenant1'
#   - server_name - name for the new server
#   - img_ref - image id to use for the new server (operating system)
#   - flavor_ref - flavor id to set the new server size
#   - keypair - keypair used to access the new server
#   - assign_floating - allocate and assign a floating IP to server? (True/False)
#   - network_id - optional - id of private network to add server to, can be omitted
#   - region - HP Cloud region; 'a' or 'b'  (US West or US East) 
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - ip_address - IP address (if allocated)
#   - server_id - Id of new server
# Results:
#   - SUCCESS - flow succeeded, server and/or IP created
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud

imports:
  net: io.cloudslang.cloud_provider.hp_cloud.net
  print: io.cloudslang.base.print
  base_utils: io.cloudslang.base.utils
  json: io.cloudslang.base.json

flow:
  name: create_server_flow
  inputs:
    - username
    - password
    - tenant_name
    - server_name
    - img_ref
    - flavor_ref
    - keypair
    - region
    - assign_floating:
        default: True    
    - network_id:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - authentication:
        do:
          get_authentication_flow:
            - username
            - password
            - tenant_name
            - region
            - proxy_host
            - proxy_port
        publish:
          - token
          - tenant: tenant_id
          - return_result
          - error_message    

    - create_server:
        do:
          create_server:
            - server_name
            - img_ref
            - flavor_ref
            - keypair
            - token
            - tenant
            - region
            - proxy_host
            - proxy_port         
        publish:
          - server_json: return_result

    - get_server_id:
        do:
          json.get_value_from_json:
            - json_input: server_json
            - key_list: ["'server'", "'id'"]
        publish:
          - server_id: value

    - print_new_server_id:
        do:
          print.print_text:
            - text: "'### New server created: '+server_id"

    - poll_server_until_active:
        loop:
          for: loop_counter in range(0,20)
          do:
            get_server_state_flow:
              - server_id  
              - delay: 10
              - token
              - tenant
              - region
              - proxy_host
              - proxy_port
          break:
            - ACTIVE
            - FAILURE
        navigate:
          ACTIVE: check_assign_floating
          NOTACTIVE: FAILURE
          FAILURE: FAILURE

    - check_assign_floating:
        do:
          base_utils.is_true:
            - bool_value: assign_floating
        navigate:
          SUCCESS: allocate_new_ip
          FAILURE: done

    - allocate_new_ip:
        do:
          net.create_floating_ip_flow:
            - token
            - region
            - proxy_host
            - proxy_port           
        publish:
          - return_result
          - ip_address

    - print_new_ip:
        do:
          print.print_text:
            - text: "'### Got a floating IP: ' + ip_address"

    - assign_ip:
        do:
          net.add_ip_to_server:
            - server_id
            - ip_address
            - tenant
            - token
            - region
            - proxy_host
            - proxy_port         
        publish:
          - return_result

    - done:
        do:
          print.print_text:
            - text: "'### New server (' + server_name + ') is ready'"

    - on_failure:
      - FLOW_ERROR:
          do:
            print.print_text:
              - text: "'! Create Server Flow Error: ' + error_message" 
  outputs:
    - ip_address
    - server_id
