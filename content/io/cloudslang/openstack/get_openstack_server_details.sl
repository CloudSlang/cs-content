#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Performs a REST call to get details for a specified server.
#
# Inputs:
#   - host - OpenStack machine host
#   - compute_port - optional - port used for OpenStack computations - Default: 8774
#   - token - OpenStack token obtained after authentication
#   - tenant - OpenStack tenantID obtained after authentication
#   - server_id - OpenStack server ID
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - response of the operation
#   - status_code - normal statusCode is 202
#   - error_message - error message
# Results:
#   - SUCCESS - operation succeeded (statusCode == '200')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.openstack

imports:
 rest: io.cloudslang.base.network.rest

flow:
  name: get_openstack_server_details
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
    - execute_get:
        do:
          rest.http_client_get:
            - url:
                default: "'http://'+ host + ':' + compute_port + '/v2/' + tenant + '/servers/' + server_id "
                overridable: false
            - proxy_host:
                required: false
            - proxy_port:
                required: false
            - headers:
                default: "'X-AUTH-TOKEN:' + token"
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


