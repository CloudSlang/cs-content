#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Authenticates and creates an OpenStack server.
#! @input host: OpenStack machine host
#! @input identity_port: optional - port used for OpenStack authentication - Default: '5000'
#! @input compute_port: optional - port used for OpenStack computations - Default: '8774'
#! @input network_id: optional - ID of network to connect to
#! @input img_ref: image reference for server to be created
#! @input username: username used for URL authentication; for NTLM authentication - Format: 'domain\user'
#! @input password: password used for URL authentication
#! @input tenant_name: name of OpenStack project that will contain server (instance)
#! @input server_name: name of server to create
#! @input proxy_host: optional - proxy server used to access OpenStack services
#! @input proxy_port: optional - proxy server port used to access OpenStack services - Default: '8080'
#! @input proxy_username: optional - user name used when connecting to proxy
#! @input proxy_password: optional - proxy server password associated with <proxy_username> input value
#! @output return_result: response of operation in case of success, error message otherwise
#! @output error_message: return_result if statusCode is not '202'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by operation
#! @result SUCCESS: OpenStack server (instance) was successfully created
#! @result GET_AUTHENTICATION_TOKEN_FAILURE: authentication token cannot be obtained from authentication call response
#! @result GET_TENANT_ID_FAILURE: tenant_id corresponding to tenant_name cannot be obtained from authentication call response
#! @result GET_AUTHENTICATION_FAILURE: authentication call fails
#! @result CREATE_SERVER_FAILURE: OpenStack server (instance) could not be created
#!!#
####################################################

namespace: io.cloudslang.cloud.openstack.servers

imports:
  openstack: io.cloudslang.cloud.openstack

flow:
  name: create_server_flow
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
          openstack.get_authentication_flow:
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
          create_server:
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
