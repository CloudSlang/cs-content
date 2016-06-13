#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Call to HP Cloud API to get auth token
#! @input username: HP Cloud account username
#! @input password: HP Cloud account password
#! @input tenant_name: name of HP Cloud tenant - Example: 'bob.smith@hp.com-tenant1'
#! @input region: HP Cloud region; 'a' or 'b'  (US West or US East)
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port
#! @output return_result: JSON response
#! @output error_message: message returned when HTTP call fails
#! @output status_code: normal status code is 200
#! @result SUCCESS: operation succeeded, token returned
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.cloud.hp_cloud

imports:
  rest: io.cloudslang.base.http

flow:
  name: get_authentication
  inputs:
    - username
    - password:
        sensitive: true
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
            - url: ${'https://region-'+region+'.geo-1.identity.hpcloudsvc.com:35357/v2.0/tokens'}
            - content_type: 'application/json'
            - body: >
                ${
                '{"auth": {"tenantName": "' + tenant_name +
                '","passwordCredentials": {"username": "' + username +
                '", "password": "' + password + '"}}}'
                }
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - error_message
          - status_code

  outputs:
    - return_result:
        value: ${return_result}
        sensitive: true
    - error_message
    - status_code
