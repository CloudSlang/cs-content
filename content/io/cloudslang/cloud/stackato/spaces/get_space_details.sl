#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description: Authenticates and retrieves details about a specified Helion Development Platform / Stackato space
#!               (filtered by space_name).
#! @input host: Helion Development Platform / Stackato host
#! @input username: Helion Development Platform / Stackato username
#! @input password: Helion Development Platform / Stackato password
#! @input space_name: name of the space to get details about
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
#! @output error_message: error message of the operation that failed
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: normal status code is '200'
#! @output resource_guid: GUID of specified space
#! @output resource_url: URL of specified space
#! @output resource_created_at: date when specified space was created
#! @output resource_updated_at: last time when specified space was updated
#! @result SUCCESS: details of specified space on Helion Development Platform / Stackato host was successfully retrieved
#! @result GET_AUTHENTICATION_FAILURE: authentication call failed
#! @result GET_AUTHENTICATION_TOKEN_FAILURE: authentication token could not be obtained from authentication call response
#! @result GET_SPACES_FAILURE: get spaces call failed
#! @result GET_SPACES_LIST_FAILURE: list with spaces on Helion Development Platform / Stackato could not be retrieved
#! @result GET_SPACE_DETAILS_FAILURE: details about a specified Helion Development Platform / Stackato space
#!                                    (filtered by space_name) could not be retrieved
#!!#
####################################################
namespace: io.cloudslang.cloud.stackato.spaces

imports:
  spaces: io.cloudslang.cloud.stackato.spaces
  utils: io.cloudslang.cloud.stackato.utils

flow:
  name: get_space_details
  inputs:
    - host
    - username
    - password:
        sensitive: true
    - space_name
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
    - get_spaces_step:
        do:
          spaces.get_spaces:
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
          - return_code
          - status_code
        navigate:
          - SUCCESS: get_space_details
          - GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          - GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          - GET_SPACES_FAILURE: GET_SPACES_FAILURE
          - GET_SPACES_LIST_FAILURE: GET_SPACES_LIST_FAILURE

    - get_space_details:
        do:
          utils.get_resource_details:
            - json_input: ${return_result}
            - key_name: ${space_name}
        publish:
          - error_message
          - return_code
          - resource_guid
          - resource_url
          - resource_created_at
          - resource_updated_at
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: GET_SPACE_DETAILS_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - resource_guid
    - resource_url
    - resource_created_at
    - resource_updated_at

  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_SPACES_FAILURE
    - GET_SPACES_LIST_FAILURE
    - GET_SPACE_DETAILS_FAILURE
