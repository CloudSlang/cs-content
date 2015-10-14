#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Main flow to call to release a floating IP 
#
# Inputs:
#   - token - auth token obtained by get_authenication_flow
#   - region - HP Cloud region; 'a' or 'b'  (US West or US East) 
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - JSON listing all floating IP and details
#   - status_code - normal status code is 200
#   - error_message - returnResult if statusCode != 200
# Results:
#   - SUCCESS - operation succeeded
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud.net

imports:
  rest: io.cloudslang.base.network.rest

flow:
  name: list_all_floatingips
  inputs:
    - token
    - region
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - rest_list_all_floatingips:
        do:
          rest.http_client_get:
            - url: "'https://region-' + region + '.geo-1.network.hpcloudsvc.com/v2.0/floatingips'"
            - headers: "'X-AUTH-TOKEN:' + token"
            - content_type: "'application/json'"
        publish:
          - return_result
          - error_message
          - status_code
          
  outputs:
    - return_result
    - error_message
    - status_code
  results:
    - SUCCESS: "'status_code' in locals() and status_code == '200'"
    - FAILURE