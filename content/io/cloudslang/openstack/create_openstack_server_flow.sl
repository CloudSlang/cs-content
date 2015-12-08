#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Authenticates and creates an OpenStack server.
#
# Inputs:
#   - host - OpenStack machine host
#   - identity_port - optional - port used for OpenStack authentication - Default: '5000'
#   - compute_port - optional - port used for OpenStack computations - Default: '8774'
#   - network_id - optional - the id of the network to connect to
#   - img_ref - image reference for server to be created
#   - username - optional - username used for URL authentication; for NTLM authentication, the required format is
#                           'domain\user'
#   - password - optional - password used for URL authentication
#   - tenant_name - name of the OpenStack project that will contain the server (instance)
#   - server_name - name of server to create
#   - proxy_host - optional - the proxy server used to access the OpenStack services
#   - proxy_port - optional - the proxy server port used to access the the OpenStack services - Default: '8080'
#   - proxy_username - optional - user name used when connecting to the proxy
#   - proxy_password - optional - proxy server password associated with the <proxyUsername> input value
# Outputs:
#   - return_result - the response of the operation in case of success, the error message otherwise
#   - error_message: return_result if statusCode is not '202'
#   - return_code - '0' if success, '-1' otherwise
#   - status_code - the code returned by the operation
# Results:
#   - SUCCESS - the OpenStack server (instance) was successfully created
#   - GET_AUTHENTICATION_FAILURE - the authentication call fails
#   - GET_AUTHENTICATION_TOKEN_FAILURE - the authentication token cannot be obtained from authentication call response
#   - GET_TENANT_ID_FAILURE - the tenant_id corresponding to tenant_name cannot be obtained from authentication call response
#   - CREATE_SERVER_FAILURE - the OpenStack server (instance) could not be created
####################################################

namespace: io.cloudslang.openstack

flow:
  name: create_openstack_server_flow
  inputs:
    - host
    - identity_port: '5000'
    - compute_port: '8774'
    - network_id:
        required: false
    - img_ref
    - username
    - password
    - tenant_name
    - server_name
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
    - authentication:
        do:
          get_authentication_flow:
            - host
            - identity_port
            - username
            - password
            - tenant_name
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - token
          - tenant_id
          - return_result
          - error_message
        navigate:
          SUCCESS: create_server
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE

    - create_server:
        do:
          create_openstack_server:
            - host
            - compute_port
            - token
            - tenant_id
            - img_ref
            - network_id
            - server_name
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - return_result
          - error_message
        navigate:
          SUCCESS: SUCCESS
          FAILURE: CREATE_SERVER_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - GET_AUTHENTICATION_FAILURE
    - CREATE_SERVER_FAILURE