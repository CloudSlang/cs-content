#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Main flow to create a server instance with floating IP in HP Cloud.
#! @input username: HP Cloud account username
#! @input password: HP Cloud account password
#! @input tenant_name: name of HP Cloud tenant - Example: 'bob.smith@hp.com-tenant1'
#! @input server_name: name for the new server
#! @input img_ref: image id to use for the new server (operating system)
#! @input flavor_ref: flavor id to set the new server size
#! @input keypair: keypair used to access the new server
#! @input region: HP Cloud region; 'a' or 'b'  (US West or US East)
#! @input assign_floating: allocate and assign a floating IP to server? (True/False)
#! @input network_id: optional - id of private network to add server to
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port
#! @input polling_attempts: optional - number of attempts to check that the created server became ACTIVE - Default: 60
#! @input polling_wait_time: optional - time in seconds to wait between polling of the new server's state
#!                           Default: 10 seconds
#! @output ip_address: IP address (if allocated)
#! @output server_id: Id of new server
#! @output return_result: JSON response
#! @result SUCCESS: flow succeeded, server and/or IP created
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.cloud.hp_cloud

imports:
  hp_cloud: io.cloudslang.cloud.hp_cloud
  net: io.cloudslang.cloud.hp_cloud.net
  print: io.cloudslang.base.print
  base_utils: io.cloudslang.base.utils
  json: io.cloudslang.base.json

flow:
  name: create_server_flow
  inputs:
    - username
    - password:
        sensitive: true
    - tenant_name
    - server_name
    - img_ref
    - flavor_ref
    - keypair:
        sensitive: true
    - region
    - assign_floating:
        default: True
    - network_id:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - polling_attempts:
        default: 60
        required: false
    - polling_wait_time:
        default: 10
        required: false

  workflow:
    - authentication:
        do:
          hp_cloud.get_authentication_flow:
            - username
            - password
            - tenant_name
            - region
            - proxy_host
            - proxy_port
        publish:
          - token
          - tenant: ${tenant_id}
          - return_result
          - error_message

    - create_server:
        do:
          hp_cloud.create_server:
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
          - return_result

    - get_server_id:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ["server", "id"]
        publish:
          - server_id: ${value}

    - print_new_server_id:
        do:
          print.print_text:
            - text: "${'### New server created: '+server_id}"

    - poll_server_until_active:
        loop:
          for: loop_counter in range(0,polling_attempts)
          do:
            hp_cloud.get_server_state_flow:
              - server_id
              - delay: ${polling_wait_time}
              - token
              - tenant
              - region
              - proxy_host
              - proxy_port
          break:
            - ACTIVE
            - FAILURE
        navigate:
          - ACTIVE: check_assign_floating
          - NOT_ACTIVE: FAILURE
          - FAILURE: FAILURE

    - check_assign_floating:
        do:
          base_utils.is_true:
            - bool_value: ${assign_floating}
        navigate:
          - SUCCESS: allocate_new_ip
          - FAILURE: done

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
            - text: "${'### Got a floating IP: ' + ip_address}"

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
            - text: ${'### New server (' + server_name + ') is ready'}

    - on_failure:
      - create_server_error:
          do:
            print.print_text:
              - text: "${'! Create Server Flow Error: ' + return_result}"
  outputs:
    - return_result
    - ip_address
    - server_id
