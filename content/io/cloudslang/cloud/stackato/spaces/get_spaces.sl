#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description: Authenticates and retrieves a list of all Helion Development Platform / Stackato spaces.
#! @input host: Helion Development Platform / Stackato host
#! @input username: Helion Development Platform / Stackato username
#! @input password: Helion Development Platform / Stackato password
#! @input proxy_host: proxy server used to access Helion Development Platform / Stackato services
#!                    optional
#! @input proxy_port: proxy server port used to access Helion Development Platform / Stackato services
#!                    optional
#!                    default: '8080'
#! @input proxy_username: user name used when connecting to proxy
#!                        optional
#! @input proxy_password: proxy server password associated with <proxy_username> input value
#!                        optional
#! @output return_result: response of the operation in case of success, error message otherwise
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by the operation
#! @output error_message: return_result if status_code is not '200'
#! @output spaces_list: list of all spaces on Helion Development Platform / Stackato instance
#! @result SUCCESS: list with spaces on Helion Development Platform / Stackato host was successfully retrieved
#! @result GET_AUTHENTICATION_FAILURE: authentication call failed
#! @result GET_AUTHENTICATION_TOKEN_FAILURE: authentication token could not be obtained from authentication call response
#! @result GET_SPACES_FAILURE: get spaces call failed
#! @result GET_SPACES_LIST_FAILURE: list with spaces on Helion Development Platform / Stackato could not be retrieved
#!!#
####################################################
namespace: io.cloudslang.cloud.stackato.spaces

imports:
  stackato: io.cloudslang.cloud.stackato
  rest: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: get_spaces
  inputs:
    - host
    - username
    - password:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true

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
          - SUCCESS: get_spaces
          - GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          - GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE

    - get_spaces:
        do:
          rest.http_client_get:
            - url: ${'https://' + host + '/v2/spaces'}
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
          - SUCCESS: get_spaces_list
          - FAILURE: GET_SPACES_FAILURE

    - get_spaces_list:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['resources']
        publish:
          - spaces_list: ${value}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: GET_SPACES_LIST_FAILURE

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
