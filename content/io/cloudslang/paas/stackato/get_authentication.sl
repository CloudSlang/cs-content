#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Authenticates on Helion Development Platform / Stackato machine and retrieves the authentication token.
#
# Inputs:
#   - host - Helion Development Platform / Stackato host
#   - username - HDP/Stackato username
#   - password - HDP/Stackato password
#   - proxy_host - optional - the proxy server used to access the Helion Development Platform / Stackato services
#   - proxy_port - optional - the proxy server port used to access the Helion Development Platform / Stackato services - Default: "'8080'"
#   - proxy_username - optional - user name used when connecting to the proxy
#   - proxy_password - optional - proxy server password associated with the <proxyUsername> input value
# Outputs:
#   - return_result - response of the last operation that was executed
#   - error_message - error message of the operation that failed
#   - token - authentication token
# Results:
#   - SUCCESS - the authentication on Helion Development Platform / Stackato host was successfully made
#   - GET_AUTHENTICATION_FAILURE - the authentication call fails
#   - GET_AUTHENTICATION_TOKEN_FAILURE - the authentication token cannot be obtained from authentication call response
####################################################
namespace: io.cloudslang.paas.stackato

imports:
  rest: io.cloudslang.base.network.rest
  json: io.cloudslang.base.json

flow:
  name: get_authentication
  inputs:
    - host
    - username
    - password
    - proxy_host:
        required: false
    - proxy_port:
        default: "'8080'"
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false

  workflow:
    - http_client_action_post:
        do:
          rest.http_client_post:
            - url: "'https://' + host + '/uaa/oauth/token'"
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - headers: "'Authorization: Basic Y2Y6'"
            - query_params: "'username=' + username + '&password=' + password + '&grant_type=password'"
            - content_type: "'application/json'"
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: get_authentication_token
          FAILURE: GET_AUTHENTICATION_FAILURE

    - get_authentication_token:
        do:
          json.get_value_from_json:
            - json_input: return_result
            - key_list: ["'access_token'"]
        publish:
          - token: value
          - error_message
        navigate:
          SUCCESS: SUCCESS
          FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE

  outputs:
    - return_result
    - error_message
    - token

  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE