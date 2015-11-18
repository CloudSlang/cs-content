#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Call to HP Cloud API to create a server instance 
#
# Inputs:
#   - server_name - name for the new server
#   - img_ref - image id to use for the new server (operating system)
#   - flavor_ref - flavor id to set the new server size
#   - keypair - keypair used to access the new server
#   - tenant - tenant id obtained by get_authenication_flow
#   - token - auth token obtained by get_authenication_flow
#   - region - HP Cloud region; 'a' or 'b'  (US West or US East) 
#   - network_id - optional - id of private network to add server to, can be omitted
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - JSON response with server details, id etc
#   - status_code - normal status code is 202
#   - error_message - Message returned when HTTP call fails
# Results:
#   - SUCCESS - operation succeeded, server created
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud

imports:
  rest: io.cloudslang.base.network.rest

flow:
  name: create_server
  inputs:
    - server_name
    - img_ref
    - flavor_ref
    - keypair
    - tenant
    - token
    - region
    - network_id:
        required: false
    - network:
        default: >
          ${', "networks" : [{"uuid": "' + network_id + '"}]' if network_id else ''}
        overridable: false
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