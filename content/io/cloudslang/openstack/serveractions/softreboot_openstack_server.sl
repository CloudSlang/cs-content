#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# SOFT REBOOT- Signal the operating system to restart
#
# Inputs:
#   - host - OpenStack machine host
#   - compute_port - optional - port used for OpenStack computations - Default: 8774
#   - token - OpenStack token obtained after authentication
#   - tenant - OpenStack tenantID obtained after authentication
#   - server_id - server ID
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
#
# Outputs:
#   - return_result - response of the operation
#   - status_code - normal status code is 202
#   - error_message: returnResult if statusCode != '202'
# Results:
#   - SUCCESS - operation succeeded (statusCode == '202')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.openstack.serveractions

imports:
 rest: io.cloudslang.base.network.rest

flow:
  name: softreboot_openstack_server
  inputs:
    - host
    - compute_port:
        default: "'8774'"
    - token
    - tenant
    - server_id
    - proxy_host:
        required: false
    - proxy_port:
        required: false
  workflow:
    - execute_post:
        do:
          rest.http_client_post:
              - url:
                  default: "'http://' + host + ':' + compute_port + '/v2/' + tenant + '/servers/'+ server_id + '/action'"
                  overridable: false
              - proxy_host:
                  required: false
              - proxy_port:
                  required: false
              - headers:
                  default: "'X-AUTH-TOKEN:' + token"
                  overridable: false
              - body:
                  default: >
                    '{"reboot": { "type": "SOFT" } }'
                  overridable: false
              - content_type:
                  default: "'application/json'"
                  overridable: false
        publish:
          - return_result
          - error_message
          - return_code
          - status_code

  outputs:
      - return_result
      - error_message
      - return_code
      - status_code