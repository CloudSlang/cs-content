#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Authenticates and creates a Helion Development Platform / Stackato application
#
# Inputs:
#   - host - Helion Development Platform / Stackato host
#   - name - Name of the application to create
#   - username - HDP / Stackato Username
#   - password - HDP / Stackato Password
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - guid - GUID of the newly created Application
#   - return_result - response of the last operation that was executed
#   - error_message - error message of the operation that failed
####################################################

namespace: io.cloudslang.stackato

imports:
 stackato_utils: io.cloudslang.stackato.utils

flow:
  name: create_new_app_flow
  inputs:
    - host
    - username
    - password
    - name
    - proxy_host:
        required: false
    - proxy_port:
        required: false
  workflow:
    - authentication:
        do:
          get_authentication_flow:
            - host
            - username
            - password
        publish:
          - token
          - return_result
          - error_message
    - createapp:
        do:
          create_new_app:
            - host
            - token
            - name
            - space_guid:
                default: "'6be70afd-92e8-41f5-bae1-e633b665bc20'"
        publish:
          - return_result
          - error_message
          - response_body: return_result
    - parse_app:
        do:
          stackato_utils.parse_appcreation:
            - json_authentication_response: response_body
        publish:
          - guid
          - error_message
  outputs:
    - guid
    - return_result
    - error_message


