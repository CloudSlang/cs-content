#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Authenticates and retrieves details about a specified Helion Development Platform / Stackato space (filtered by space_name)
#
# Inputs:
#   - host - Helion Development Platform / Stackato host
#   - username - Helion Development Platform / Stackato username
#   - password - Helion Development Platform / Stackato password
#   - space_name - Name of the space to get details about
#   - proxy_host - optional - the proxy server used to access the Helion Development Platform / Stackato services
#   - proxy_port - optional - the proxy server port used to access the Helion Development Platform / Stackato services - Default: "'8080'"
#   - proxy_username - optional - user name used when connecting to the proxy
#   - proxy_password - optional - proxy server password associated with the <proxyUsername> input value
# Outputs:
#   - return_result - response of the last operation that was executed
#   - error_message - error message of the operation that failed
#   - resource_guid - the GUID of the specified space
#   - resource_url - the URL of the specified space
#   - resource_created_at - date when the specified space was created
#   - resource_updated_at - the last time when the specified space was updated
# Results:
#   - SUCCESS - the details of the specified space on Helion Development Platform / Stackato host was successfully retrieved
#   - GET_AUTHENTICATION_FAILURE - the authentication call fail
#   - GET_AUTHENTICATION_TOKEN_FAILURE - the authentication token cannot be obtained from authentication call response
#   - GET_SPACES_FAILURE - the get spaces call fail
#   - GET_SPACES_LIST_FAILURE - the list with spaces on Helion Development Platform / Stackato could not be retrieved
#   - GET_SPACE_DETAILS_FAILURE - the details about a specified Helion Development Platform / Stackato space (filtered by space_name) could not be retrieved
####################################################
namespace: io.cloudslang.paas.stackato.spaces

imports:
  stackato_utils: io.cloudslang.paas.stackato.utils

flow:
  name: get_space_details
  inputs:
    - host
    - username
    - password
    - space_name
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
    - get_spaces_step:
        do:
          get_spaces:
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
        navigate:
          SUCCESS: get_space_details
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_SPACES_FAILURE: GET_SPACES_FAILURE
          GET_SPACES_LIST_FAILURE: GET_SPACES_LIST_FAILURE

    - get_space_details:
        do:
          stackato_utils.get_resource_details:
            - json_input: return_result
            - key_name: space_name
        publish:
          - return_result
          - error_message
          - return_code
          - resource_guid
          - resource_url
          - resource_created_at
          - resource_updated_at
        navigate:
          SUCCESS: SUCCESS
          FAILURE: GET_SPACE_DETAILS_FAILURE

  outputs:
    - return_result
    - error_message
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