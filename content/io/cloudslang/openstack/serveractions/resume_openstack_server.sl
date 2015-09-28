#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Resumes a SUSPENDED server and changes its status to ACTIVE.
#
# Inputs:
#   - host - OpenStack machine host
#   - compute_port - optional - port used for OpenStack computations - Default: 8774
#   - token - OpenStack token obtained after authentication
#   - tenant - OpenStack tenantID obtained after authentication
#   - server_id - OpenStack Server ID
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
 auth: io.cloudslang.openstack
 json: io.cloudslang.base.json

flow:
  name: resume_openstack_server
  inputs:
    - host
    - compute_port: "'8774'"
    - tenant_name
    - tenant_id
    - server_id
    - username:
        default: "''"
        required: false
    - password:
        default: "''"
        required: false
    - proxy_host:
        default: "''"
        required: false
    - proxy_port:
        default: "'8080'"
        required: false
    - proxy_username:
        default: "''"
        required: false
    - proxy_password:
        default: "''"
        required: false

  workflow:
    - get_authentication:
        do:
          auth.get_authentication:
            - host
            - tenant_name
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - auth_response: return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: get_authentication_token
          FAILURE: GET_AUTHENTICATION_FAILURE

    - get_authentication_token:
        do:
          json.get_value_from_json:
            - json_input: auth_response
            - key_list: ["'access'", "'token'", "'id'"]
        publish:
          - token: value
        navigate:
          SUCCESS: resume_server
          FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE

    - resume_server:
        do:
          rest.http_client_post:
            - url: "'http://' + host + ':' + compute_port + '/v2/' + tenant_id + '/servers/'+ server_id + '/action'"
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - headers: "'X-AUTH-TOKEN:' + token"
            - body: "'{\"resume\":null}'"
            - content_type: "'application/json'"
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: SUCCESS
          FAILURE: RESUME_SERVER_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - token

  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - RESUME_SERVER_FAILURE