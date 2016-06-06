#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Create a floating IP bound to the external (public) network.
#! @input ext_network_id: ID of the external network to get an an IP for
#! @input token: auth token obtained by get_authenication_flow
#! @input region: HP Cloud region; 'a' or 'b'  (US West or US East)
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port
#! @output return_result: JSON response with new IP details
#! @output error_message: message returned when HTTP call fails
#! @output status_code: normal status code is 201
#! @result SUCCESS: operation succeeded
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.cloud.hp_cloud.net

imports:
  rest: io.cloudslang.base.http

flow:
  name: create_floating_ip
  inputs:
    - ext_network_id
    - token:
        sensitive: true
    - region
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - rest_create_floating_ip:
        do:
          rest.http_client_post:
            - url: ${'https://region-' + region + '.geo-1.network.hpcloudsvc.com/v2.0/floatingips'}
            - headers: ${'X-AUTH-TOKEN:' + token}
            - body: >
                ${'{"floatingip": { "floating_network_id": "' + ext_network_id + '" }}'}
            - content_type: 'application/json'
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
