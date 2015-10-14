#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Assigns a floating IP to a server instance
#
# Inputs:
#   - ip_address - floating IP to be added to server
#   - server_id - server instance id
#   - tenant - tenant id obtained by get_authenication_flow
#   - token - auth token obtained by get_authenication_flow
#   - region - HP Cloud region; 'a' or 'b'  (US West or US East) 
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - JSON response of the operation
#   - status_code - normal status code is 202
#   - error_message: returnResult if statusCode != 202
# Results:
#   - SUCCESS - operation succeeded
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud.net

imports:
  rest: io.cloudslang.base.network.rest

flow:
  name: add_ip_to_server
  inputs:
    - ip_address
    - server_id
    - tenant
    - token
    - region
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - rest_add_ip_to_server:
        do:
          rest.http_client_post:
            - url: "'https://region-' + region + '.geo-1.compute.hpcloudsvc.com/v2/' + tenant + '/servers/' + server_id + '/action'"
            - headers: "'X-AUTH-TOKEN:' + token"
            - content_type: "'application/json'"
            - body: >
                '{"addFloatingIp": { "address": "'+ip_address+'" }}'
        publish:
          - return_result
          - error_message
          - status_code
          
  outputs:
    - return_result
    - error_message
    - status_code
  results:
    - SUCCESS: "'status_code' in locals() and status_code == '202'"
    - FAILURE