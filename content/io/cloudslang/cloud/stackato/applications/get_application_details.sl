#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description: Authenticates and retrieves details about a specified Helion Development Platform / Stackato instance application
#!               (filtered by application_name)
#! @input host: Helion Development Platform / Stackato host
#! @input username: Helion Development Platform / Stackato username
#! @input password: Helion Development Platform / Stackato password
#! @input application_name: Name of the application to get details about
#! @input proxy_host: optional - the proxy server used to access the Helion Development Platform / Stackato services
#! @input proxy_port: optional - the proxy server port used to access the Helion Development Platform / Stackato services
#!                    Default: '8080'
#! @input proxy_username: optional - user name used when connecting to the proxy
#! @input proxy_password: optional - proxy server password associated with the <proxyUsername> input value
#! @output return_result: response of the last operation that was executed
#! @output error_message: error message of the operation that failed
#! @output resource_guid: the GUID of the specified application
#! @output resource_url: the URL of the specified application
#! @output resource_created_at: date when the specified application was created
#! @output resource_updated_at: the last time when the specified application was updated
#! @result SUCCESS: the details of the specified application on Helion Development Platform / Stackato host was
#!                  successfully retrieved
#! @result GET_AUTHENTICATION_FAILURE: the authentication call fail
#! @result GET_AUTHENTICATION_TOKEN_FAILURE: the authentication token cannot be obtained from authentication call response
#! @result GET_APPLICATIONS_FAILURE: the get applications call fail
#! @result GET_APPLICATIONS_LIST_FAILURE: the list with applications deployed on Helion Development Platform / Stackato
#!                                        could not be retrieved
#! @result GET_APPLICATION_DETAILS_FAILURE: the details about a specified Helion Development Platform / Stackato
#!                                          application (filtered by application_name) could not be retrieved
#!!#
####################################################
namespace: io.cloudslang.cloud.stackato.applications

imports:
  stackato_utils: io.cloudslang.cloud.stackato.utils

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
        default: '8080'
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
            - json_input: ${return_result}
            - key_name: ${application_name}
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