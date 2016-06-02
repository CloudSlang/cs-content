#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description: Retrieves a list of all applications deployed to a Helion Development Platform / Stackato instance.
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
#! @output error_message: return_result if status_code is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by the operation
#! @output apps_list: list of all applications deployed on Helion Development Platform / Stackato instance
#! @result SUCCESS: list with applications deployed on Helion Development Platform / Stackato host was successfully
#!                  retrieved
#! @result GET_AUTHENTICATION_FAILURE: authentication call failed
#! @result GET_AUTHENTICATION_TOKEN_FAILURE: authentication token could not be obtained from authentication call response
#! @result GET_APPLICATIONS_FAILURE: get applications call failed
#! @result GET_APPLICATIONS_LIST_FAILURE: list with applications deployed on Helion Development Platform / Stackato
#!                                        instance could not be retrieved
#!!#
####################################################
namespace: io.cloudslang.cloud.stackato.applications

imports:
  stackato: io.cloudslang.cloud.stackato
  rest: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: get_applications
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
          - SUCCESS: get_apps
          - GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          - GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE

    - get_apps:
        do:
          rest.http_client_get:
            - url: ${'https://' + host + '/v2/apps'}
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
          - SUCCESS: get_apps_list
          - FAILURE: GET_APPLICATIONS_FAILURE

    - get_apps_list:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['resources']
        publish:
          - apps_list: ${value}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: GET_APPLICATIONS_LIST_FAILURE

  outputs:
    - return_result
    - error_message: ${return_result if return_code == '-1' or status_code != '200' else ''}
    - return_code
    - status_code
    - apps_list

  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_APPLICATIONS_FAILURE
    - GET_APPLICATIONS_LIST_FAILURE
