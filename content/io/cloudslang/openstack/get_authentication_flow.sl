#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Authenticates an OpenStack machine.
#
# Inputs:
#   - host - OpenStack host
#   - identity_port - optional - port used for OpenStack authentication - Default: "'5000'"
#   - username - OpenStack username
#   - password - OpenStack password
#   - tenant_name - name of the project on OpenStack
#   - proxy_host - optional - the proxy server used to access the OpenStack services
#   - proxy_port - optional - the proxy server port used to access the the OpenStack services - Default: "'8080'"
#   - proxy_username - optional - user name used when connecting to the proxy
#   - proxy_password - optional - proxy server password associated with the <proxyUsername> input value
# Outputs:
#   - return_result - response of the last operation that was executed
#   - error_message - error message of the operation that failed
#   - token - authentication token
#   - tenant_id - tenant ID
# Results:
#   - SUCCESS - the authentication on OpenStack host was successfully made
#   - GET_AUTHENTICATION_TOKEN_FAILURE - the authentication token cannot be obtained from authentication call response
#   - GET_TENANT_ID_FAILURE - the tenant_id corresponding to tenant_name cannot be obtained from authentication call response
#   - GET_AUTHENTICATION_FAILURE - the authentication call fails
####################################################

namespace: io.cloudslang.openstack

imports:
  openstack_utils: io.cloudslang.openstack.utils
  json: io.cloudslang.base.json

flow:
  name: get_authentication_flow
  inputs:
    - host
    - identity_port: "'5000'"
    - username
    - password
    - tenant_name
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
  workflow:
    - authentication_call:
        do:
          get_authentication:
            - host
            - identity_port
            - username
            - password
            - tenant_name
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - return_result
          - return_code
          - error_message
        navigate:
          SUCCESS: get_authentication_token
          FAILURE: GET_AUTHENTICATION_FAILURE

    - get_authentication_token:
        do:
          json.get_value:
            - json_input: return_result
            - json_path: ["'access'", "'token'", "'id'"]
        publish:
          - token: value
          - error_message
        navigate:
          SUCCESS: get_tenant_id
          FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE

    - get_tenant_id:
        do:
          json.get_value:
            - json_input: return_result
            - json_path: ["'access'", "'token'", "'tenant'", "'id'"]
        publish:
          - tenant_id: value
          - error_message
        navigate:
          SUCCESS: SUCCESS
          FAILURE: GET_TENANT_ID_FAILURE

  outputs:
    - return_result
    - error_message
    - token
    - tenant_id

  results:
    - SUCCESS
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - GET_AUTHENTICATION_FAILURE
