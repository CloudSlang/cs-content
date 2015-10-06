#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Authenticates and retrieves all Apps deployed to a Helion Development Platform / Stackato instance
#
# Inputs:
#   - host - Helion Development Platform / Stackato instance
#   - username - HDP/Stackato username
#   - password - HDP/Stackato password
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - response of the last operation that was executed
#   - error_message - error message of the operation that failed
####################################################

namespace: io.cloudslang.stackato

imports:
 stackato_utils: io.cloudslang.stackato.utils

flow:
  name: get_apps_flow
  inputs:
    - host
    - username
    - password
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
            - proxy_host:
                required: false
            - proxy_port:
                required: false
        publish:
          - token
          - return_result
          - error_message
    - listapps:
        do:
          get_apps:
            - host
            - token
        publish:
          - return_result
          - error_message
  outputs:
    - return_result
    - error_message