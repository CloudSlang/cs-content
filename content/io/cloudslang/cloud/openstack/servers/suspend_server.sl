#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Suspends a running server (instance) and changes its status to SUSPENDED.
#!               Note:
#!               - this operation stores the VM state on disk, writes all memory to disk, and stops the VM
#!               - suspending an instance is similar to placing a device in hibernation, memory and vCPUs become available to
#!               create other instances
#! @input host: OpenStack host
#! @input identity_port: optional - port used for OpenStack authentication - Default: '5000'
#! @input compute_port: port used for OpenStack computations - Default: '8774'
#! @input tenant_name: name of OpenStack project that contains server (instance) to be suspended
#! @input tenant_id: ID corresponding to tenant_name
#! @input server_id: ID of server (instance) to be suspended
#! @input username: optional - username used for URL authentication; for NTLM authentication - Format: 'domain\user'
#! @input password: optional - password used for URL authentication
#! @input proxy_host: optional - proxy server used to access OpenStack services
#! @input proxy_port: optional - proxy server port used to access OpenStack services - Default: '8080'
#! @input proxy_username: optional - user name used when connecting to proxy
#! @input proxy_password: optional - proxy server password associated with <proxy_username> input value
#! @output return_result: response of operation in case of success, error message otherwise
#! @output error_message: return_result if statusCode is not '202'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by operation
#! @result SUCCESS: OpenStack server (instance) was successfully suspended
#! @result GET_AUTHENTICATION_FAILURE: authentication step fail
#! @result GET_AUTHENTICATION_TOKEN_FAILURE: authentication token cannot be obtained from authentication step response
#! @result GET_TENANT_ID_FAILURE: tenant_id cannot be obtained
#! @result SUSPEND_SERVER_FAILURE: OpenStack server (instance) cannot be suspended
#!!#
####################################################

namespace: io.cloudslang.cloud.openstack.servers

imports:
  rest: io.cloudslang.base.network.rest
  openstack: io.cloudslang.cloud.openstack

flow:
  name: suspend_server
  inputs:
    - host
    - identity_port: '5000'
    - compute_port: '8774'
    - tenant_name
    - server_id
    - username:
        required: false
    - password:
        required: false
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
          - return_result
          - error_message
          - token
          - tenant_id
        navigate:
          - SUCCESS: suspend_server
          - GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          - GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          - GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE

    - suspend_server:
        do:
          rest.http_client_post:
            - url: ${'http://' + host + ':' + compute_port + '/v2/' + tenant_id + '/servers/'+ server_id + '/action'}
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - headers: ${'X-AUTH-TOKEN:' + token}
            - body: '{"suspend":null}'
            - content_type: 'application/json'
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: SUSPEND_SERVER_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - SUSPEND_SERVER_FAILURE
