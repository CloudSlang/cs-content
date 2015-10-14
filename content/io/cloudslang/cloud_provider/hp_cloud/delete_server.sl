#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Call to HP Cloud API to terminate a server instance 
#
# Inputs:
#   - server_id - id of server to be terminated
#   - tenant - tenant id obtained by get_authenication_flow
#   - token - auth token obtained by get_authenication_flow
#   - region - HP Cloud region; 'a' or 'b'  (US West or US East) 
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - JSON response
#   - status_code - normal status code is 204
#   - error_message - if error occurs, this contains error in JSON
# Results:
#   - SUCCESS - operation succeeded, server deleted
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud

imports:
  rest: io.cloudslang.base.network.rest

flow:
  name: delete_server
  inputs:
    - server_id
    - tenant
    - token
    - region 
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - rest_delete_server:
        do:
          rest.http_client_delete:
            - url: "'https://region-'+region+'.geo-1.compute.hpcloudsvc.com/v2/' + tenant + '/servers/' + server_id"
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
    - SUCCESS: "'status_code' in locals() and status_code == '204'"
    - FAILURE