#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Main flow to terminate a server instance plus floating IP in HP Cloud
#
# Inputs:
#   - username - HP Cloud account username 
#   - password - HP Cloud account password 
#   - tenant_name - Name of HP Cloud tenant e.g. 'bob.smith@hp.com-tenant1'
#   - server_id - Name for the new server
#   - ip_address - IP address if releasing it
#   - release_ip_address - Release and delete floating IP (True/False)
#   - region - HP Cloud region; 'a' or 'b'  (US West or US East) 
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - JSON response
#   - error_message - Any errors
# Results:
#   - SUCCESS - flow succeeded, server and/or IP removed
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud

imports:
  print: io.cloudslang.base.print
  base_utils: io.cloudslang.base.utils
  net: io.cloudslang.cloud_provider.hp_cloud.net  

flow:
  name: delete_server_flow
  inputs:
    - username
    - password
    - tenant_name
    - server_id
    - region
    - ip_address:  
        required: false
    - release_ip_address:
        default: True    
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
            - proxy_host:
                required: false
            - proxy_port:
                required: false
        publish:
          - token
          - tenant
          - return_result
          - error_message

    - delete_server:
        do:
          delete_server:
            - server_id
            - token
            - tenant
            - region
            - proxy_host:
                required: false
            - proxy_port:
                required: false
        publish:
          - return_result
          - error_message

    - check_release_ip_address:
        do:
          base_utils.check_bool:
            - bool_value: release_ip_address
        navigate:
          SUCCESS: do_release_ip
          FAILURE: done

    - do_release_ip:
        do:
          net.delete_floating_ip_flow:
            - ip_address
            - token
            - tenant
            - region
            - proxy_host: 
                required: false
            - proxy_port: 
                required: false            

    - done:
        do:
          print.print_text:
            - text: "'### Server ('+server_id+') was removed'"

  outputs:
    - return_result
    - error_message