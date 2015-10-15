#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Call to HP Cloud API to get auth token
#
# Inputs:
#   - username - HP Cloud account username 
#   - password - HP Cloud account password 
#   - tenant_name - name of HP Cloud tenant e.g. 'bob.smith@hp.com-tenant1'
#   - token - auth token obtained by get_authenication_flow
#   - region - HP Cloud region; 'a' or 'b'  (US West or US East) 
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - JSON response
#   - status_code - normal status code is 200
#   - error_message - Message returned when HTTP call fails
# Results:
#   - SUCCESS - operation succeeded, token returned
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud

imports:
  rest: io.cloudslang.base.network.rest

flow:
  name: get_authentication
  inputs:
    - username
    - password
    - tenant_name
    - region
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - rest_get_authentication:
        do:
          rest.http_client_post:
            - url: "'https://region-'+region+'.geo-1.identity.hpcloudsvc.com:35357/v2.0/tokens'"
            - content_type: "'application/json'"
            - body: >
                '{"auth": {"tenantName": "' + tenant_name +
                '","passwordCredentials": {"username": "' + username +
                '", "password": "' + password + '"}}}'
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - error_message
          - status_code
          
  outputs:
    - return_result
    - error_message
    - status_code