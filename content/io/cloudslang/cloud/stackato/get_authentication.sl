#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Authenticates on Helion Development Platform / Stackato machine and retrieves the authentication token.
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
#! @output return_result: response of last operation that was executed
#! @output error_message: error message of operation that failed
#! @output token: authentication token
#! @result SUCCESS: authentication on Helion Development Platform / Stackato host was successful
#! @result GET_AUTHENTICATION_FAILURE: authentication call failsed
#! @result GET_AUTHENTICATION_TOKEN_FAILURE: authentication token could not be obtained from authentication call response
#!!#
####################################################
namespace: io.cloudslang.cloud.stackato

imports:
  rest: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: get_authentication
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
    - http_client_action_post:
        do:
          rest.http_client_post:
            - url: ${'https://' + host + '/uaa/oauth/token'}
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - headers: 'Authorization: Basic Y2Y6'
            - query_params: ${'username=' + username + '&password=' + password + '&grant_type=password'}
            - content_type: 'application/json'
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: get_authentication_token
          - FAILURE: GET_AUTHENTICATION_FAILURE

    - get_authentication_token:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['access_token']
        publish:
          - token: ${value}
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE

  outputs:
    - return_result
    - error_message
    - token:
        value: ${token}
        sensitive: true

  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
