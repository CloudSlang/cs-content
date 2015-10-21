#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Authenticates and retrieves details about a specified Helion Development Platform / Stackato application (filtered by application_name)
#
# Inputs:
#   - host - Helion Development Platform / Stackato host
#   - username - Helion Development Platform / Stackato username
#   - password - Helion Development Platform / Stackato password
#   - application_name - Name of the application to get details about
#   - proxy_host - optional - the proxy server used to access the Helion Development Platform / Stackato services
#   - proxy_port - optional - the proxy server port used to access the Helion Development Platform / Stackato services - Default: "'8080'"
#   - proxy_username - optional - user name used when connecting to the proxy
#   - proxy_password - optional - proxy server password associated with the <proxyUsername> input value
# Outputs:
#   - return_result - response of the last operation that was executed
#   - error_message - error message of the operation that failed
#   - resource_guid - the GUID of the specified application
#   - resource_url - the URL of the specified application
#   - resource_created_at - date when the specified application was created
#   - resource_updated_at - the last time when the specified application was updated
# Results:
#   - SUCCESS - the details of the specified application on Helion Development Platform / Stackato host was successfully retrieved
#   - GET_AUTHENTICATION_FAILURE - the authentication call fail
#   - GET_AUTHENTICATION_TOKEN_FAILURE - the authentication token cannot be obtained from authentication call response
#   - GET_APPLICATIONS_FAILURE - the get applications call fail
#   - GET_APPLICATIONS_LIST_FAILURE - the list with applications deployed on Helion Development Platform / Stackato could not be retrieved
#   - GET_APPLICATION_DETAILS_FAILURE - the details about a specified Helion Development Platform / Stackato application (filtered by application_name) could not be retrieved
####################################################
namespace: io.cloudslang.paas.stackato.applications

imports:
  stackato_utils: io.cloudslang.paas.stackato.utils

flow:
  name: get_application_details
  inputs:
    - host
    - username
    - password
    - application_name
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
    - get_applications_step:
        do:
          get_applications:
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
          SUCCESS: get_application_details
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_APPLICATIONS_FAILURE: GET_APPLICATIONS_FAILURE
          GET_APPLICATIONS_LIST_FAILURE: GET_APPLICATIONS_LIST_FAILURE

    - get_application_details:
        do:
          stackato_utils.get_resource_details:
            - json_input: return_result
            - key_name: application_name
        publish:
          - error_message
          - return_code
          - resource_guid
          - resource_url
          - resource_created_at
          - resource_updated_at
        navigate:
          SUCCESS: SUCCESS
          FAILURE: GET_APPLICATION_DETAILS_FAILURE

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
    - GET_APPLICATIONS_FAILURE
    - GET_APPLICATIONS_LIST_FAILURE
    - GET_APPLICATION_DETAILS_FAILURE