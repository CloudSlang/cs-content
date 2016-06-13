#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Assigns a floating IP to a server instance.
#! @input ip_address: floating IP to be added to server
#! @input server_id: server instance ID
#! @input tenant: tenant ID obtained by get_authenication_flow
#! @input token: auth token obtained by get_authenication_flow
#! @input region: HP Cloud region; 'a' or 'b'  (US West or US East)
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port
#! @output return_result: JSON response of the operation
#! @output error_message: message returned when HTTP call fails
#! @output status_code: normal status code is 202
#! @result SUCCESS: operation succeeded
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.cloud.hp_cloud.net

imports:
  rest: io.cloudslang.base.http

flow:
  name: add_ip_to_server
  inputs:
    - ip_address
    - server_id
    - tenant
    - token:
        sensitive: true
    - region
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - rest_add_ip_to_server:
        do:
          rest.http_client_post:
            - url: ${'https://region-' + region + '.geo-1.compute.hpcloudsvc.com/v2/' + tenant + '/servers/' + server_id + '/action'}
            - headers: ${'X-AUTH-TOKEN:' + token}
            - content_type: 'application/json'
            - body: >
                ${'{"addFloatingIp": { "address": "'+ip_address+'" }}'}
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
