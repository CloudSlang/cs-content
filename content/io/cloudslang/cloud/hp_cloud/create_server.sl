#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Call to HP Cloud API to create a server instance.
#! @input server_name: name for the new server
#! @input img_ref: image id to use for the new server (operating system)
#! @input flavor_ref: flavor id to set the new server size
#! @input keypair: keypair used to access the new server
#! @input tenant: tenant id obtained by get_authenication_flow
#! @input token: auth token obtained by get_authenication_flow
#! @input region: HP Cloud region; 'a' or 'b'  (US West or US East)
#! @input network_id: optional - ID of private network to add server to, can be omitted
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port
#! @output return_result: JSON response with server details, id etc
#! @output error_message: message returned when HTTP call fails
#! @output status_code: normal status code is 202
#! @result SUCCESS: operation succeeded, server created
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.cloud.hp_cloud

imports:
  rest: io.cloudslang.base.http

flow:
  name: create_server
  inputs:
    - server_name
    - img_ref
    - flavor_ref
    - keypair:
        sensitive: true
    - tenant
    - token:
        sensitive: true
    - region
    - network_id:
        required: false
    - network:
        default: >
          ${', "networks" : [{"uuid": "' + network_id + '"}]' if network_id else ''}
        private: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - rest_create_server:
        do:
          rest.http_client_post:
            - url: ${'https://region-' + region + '.geo-1.compute.hpcloudsvc.com/v2/' + tenant + '/servers'}
            - headers: ${'X-AUTH-TOKEN:' + token}
            - content_type: 'application/json'
            - body: >
                ${
                '{"server": { "name": "' + server_name + '" , "imageRef": "' + img_ref +
                '", "flavorRef":"' + str(flavor_ref) + '", "key_name":"' + keypair +
                '", "max_count":1, "min_count":1, "security_groups": [ {"name": "default"} ]' + network + '}}'
                }
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
