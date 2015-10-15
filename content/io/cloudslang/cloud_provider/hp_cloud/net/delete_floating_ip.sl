#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Delete and release a floating IP
#
# Inputs:
#   - ip_id - id of floating IP
#   - token - auth token obtained by get_authenication_flow
#   - region - HP Cloud region; 'a' or 'b'  (US West or US East) 
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - JSON response of delete operation (should be empty if no error)
#   - status_code - normal status code is 204
#   - error_message - Message returned when HTTP call fails
# Results:
#   - SUCCESS - operation succeeded
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud.net

imports:
  rest: io.cloudslang.base.network.rest

flow:
  name: delete_floating_ip
  inputs:
    - ip_id
    - token
    - region
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - rest_delete_floating_ip:
        do:
          rest.http_client_delete:
            - url: "'https://region-' + region + '.geo-1.network.hpcloudsvc.com/v2.0/floatingips/' + ip_id"
            - headers: "'X-AUTH-TOKEN:' + token"
            - content_type: "'application/json'"
            - proxy_host
            - proxy_port
        publish:
          - status_code

  outputs:
    - return_result
    - error_message
    - status_code