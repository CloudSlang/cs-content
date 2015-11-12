#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
# Authenticates and retrieves a list of all Helion Development Platform / Stackato spaces
#
# Inputs:
#   - host - Helion Development Platform / Stackato host
#   - username - Helion Development Platform / Stackato username
#   - password - Helion Development Platform / Stackato password
#   - proxy_host - optional - the proxy server used to access the Helion Development Platform / Stackato services
#   - proxy_port - optional - proxy server port - the proxy server port used to access the Helion Development Platform
#                                                 / Stackato services - Default: '8080'
#   - proxy_username - optional - user name used when connecting to the proxy
#   - proxy_password - optional - proxy server password associated with the <proxyUsername> input value
# Outputs:
#   - return_result - the response of the operation in case of success, the error message otherwise
#   - error_message - return_result if status_code is not '200'
#   - return_code - '0' if success, '-1' otherwise
#   - status_code - the code returned by the operation
#   - spaces_list - list of all spaces on Helion Development Platform / Stackato instance
# Results:
#   - SUCCESS - the list with spaces on Helion Development Platform / Stackato host was successfully retrieved
#   - GET_AUTHENTICATION_FAILURE - the authentication call fail
#   - GET_AUTHENTICATION_TOKEN_FAILURE - the authentication token cannot be obtained from authentication call response
#   - GET_SPACES_FAILURE - the get spaces call fail
#   - GET_SPACES_LIST_FAILURE - the list with spaces on Helion Development Platform / Stackato could not be retrieved
####################################################
namespace: io.cloudslang.paas.stackato.spaces

imports:
  stackato: io.cloudslang.paas.stackato
  rest: io.cloudslang.base.network.rest
  json: io.cloudslang.base.json

flow:
  name: get_spaces
  inputs:
    - host
    - username
    - password
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false

  workflow:
    - authentication:
        do:
          stackato.get_authentication:
            - host
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - return_result
          - error_message
          - token
        navigate:
          SUCCESS: get_spaces
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE

    - get_spaces:
        do:
          rest.http_client_get:
            - url: "${'https://' + host + '/v2/spaces'}"
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - headers: "${'Authorization: bearer ' + token}"
            - content_type: 'application/json'
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: get_spaces_list
          FAILURE: GET_SPACES_FAILURE

    - get_spaces_list:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ["'resources'"]
        publish:
          - spaces_list: ${value}
        navigate:
          SUCCESS: SUCCESS
          FAILURE: GET_SPACES_LIST_FAILURE

  outputs:
    - return_result
    - return_code
    - status_code
    - error_message: ${return_result if return_code == '-1' or status_code != '200' else ''}
    - spaces_list

  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_SPACES_FAILURE
    - GET_SPACES_LIST_FAILURE