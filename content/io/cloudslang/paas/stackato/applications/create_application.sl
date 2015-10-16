#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Creates and deploys an application in Helion Development Platform / Stackato
#
# Inputs:
#   - host - Helion Development Platform / Stackato host
#   - username - Helion Development Platform / Stackato username
#   - password - Helion Development Platform / Stackato password
#   - application_name - Name of the application to create
#   - space_guid - GUID of the Helion Development Platform / Stackato space to deploy to
#   - proxy_host - optional - the proxy server used to access the Helion Development Platform / Stackato services
#   - proxy_port - optional - the proxy server port used to access the Helion Development Platform / Stackato services - Default: "'8080'"
#   - proxy_username - optional - user name used when connecting to the proxy
#   - proxy_password - optional - proxy server password associated with the <proxyUsername> input value
# Outputs:
#   - return_result - the response of the operation in case of success, the error message otherwise
#   - error_message - return_result if statusCode is not "'201'"
#   - return_code - "'0'" if success, "'-1'" otherwise
#   - status_code - the code returned by the operation
#   - application_guid - the application id
# Results:
#   - SUCCESS - the application on Helion Development Platform / Stackato host was successfully created/deployed
#   - GET_AUTHENTICATION_FAILURE - the authentication call fail
#   - GET_AUTHENTICATION_TOKEN_FAILURE - the authentication token cannot be obtained from authentication call response
#   - CREATE_APPLICATION_FAILURE - the application on Helion Development Platform / Stackato host could not be created/deployed
#   - GET_APPLICATION_GUID_FAILURE - the application guid cannot be obtained from create call response
####################################################
namespace: io.cloudslang.paas.stackato.applications

imports:
  stackato: io.cloudslang.paas.stackato
  rest: io.cloudslang.base.network.rest
  json: io.cloudslang.base.json

flow:
  name: create_application
  inputs:
    - host
    - username
    - password
    - application_name
    - space_guid
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
          SUCCESS: create_app
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE

    - create_app:
        do:
          rest.http_client_post:
            - url: "'https://' + host + '/v2/apps'"
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - body: "'{\"name\":\"' + application_name + '\",\"space_guid\":\"' + space_guid + '\",\"memory\":1024,\"instances\":1}'"
            - headers: "'Authorization: bearer ' + token"
            - content_type: "'application/json'"
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: get_application_guid
          FAILURE: CREATE_APPLICATION_FAILURE

    - get_application_guid:
        do:
          json.get_value_from_json:
            - json_input: return_result
            - key_list: ["'entity'", "'guid'"]
        publish:
          - application_guid: value
        navigate:
          SUCCESS: SUCCESS
          FAILURE: GET_APPLICATION_GUID_FAILURE

  outputs:
    - return_result
    - error_message: return_result if return_code == '-1' or status_code != '201' else ''
    - return_code
    - status_code
    - application_guid

  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - CREATE_APPLICATION_FAILURE
    - GET_APPLICATION_GUID_FAILURE