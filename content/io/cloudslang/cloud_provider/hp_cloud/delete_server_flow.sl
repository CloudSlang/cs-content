#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Main flow to terminate a server instance plus floating IP in HP Cloud.
#
# Inputs:
#   - username - HP Cloud account username
#   - password - HP Cloud account password
#   - tenant_name - name of HP Cloud tenant - Example: 'bob.smith@hp.com-tenant1'
#   - server_id - name for the new server
#   - region - HP Cloud region; 'a' or 'b'  (US West or US East)
#   - ip_address - IP address if releasing it
#   - release_ip_address - release and delete floating IP (True/False)
#   - proxy_host - optional - proxy server used to access the web site
#   - proxy_port - optional - proxy server port
# Outputs:
#   - return_result - JSON response
#   - error_message - any errors
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
            - proxy_host
            - proxy_port
        publish:
          - token
          - tenant: ${tenant_id}
          - return_result
          - error_message

    - delete_server:
        do:
          delete_server:
            - server_id
            - token
            - tenant
            - region
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - error_message

    - check_release_ip_address:
        do:
          base_utils.is_true:
            - bool_value: ${release_ip_address}
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
            - proxy_host
            - proxy_port

    - done:
        do:
          print.print_text:
            - text: ${'### Server ('+server_id+') was removed'}

  outputs:
    - return_result
    - error_message
