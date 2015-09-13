#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Authenticates and creates a OpenShift / OpenShift application
#
# Inputs:
#   - host - OpenShift / OpenShift host
#   - username - HDP / OpenShift Username
#   - password - HDP / OpenShift Password
#   - name - Name of the application to create
#   - space_name - Name of the space to deploy to
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - guid - GUID of the newly created Application
#   - return_result - response of the last operation that was executed
#   - error_message - error message of the operation that failed
####################################################

namespace: io.cloudslang.openshift


flow:
  name: create_new_app_flow
  inputs:
    - host
    - username
    - password
    - name
    - space_name
    - proxy_host:
        required: false
    - proxy_port:
        required: false
  workflow:
    - createapp:
        do:
          create_new_app:
            - host
            - username
            - password
            - cartbridgeName
        publish:
          - return_result
          - error_message
          - response_body: return_result
  outputs:
    - return_result
    - error_message
  results:
    - SUCCESS
    - FAILURE

