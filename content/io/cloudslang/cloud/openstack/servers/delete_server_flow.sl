#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Authenticates and deletes an OpenStack server.
#! @input host: OpenStack machine host
#! @input identity_port: optional - port used for OpenStack authentication - Default: '5000'
#! @input compute_port: optional - port used for OpenStack computations - Default: '8774'
#! @input username: username used for URL authentication; for NTLM authentication - Format: 'domain\user'
#! @input password: password used for URL authentication
#! @input tenant_name: name of OpenStack project that contains server (instance) to be deleted
#! @input server_name: name of server to delete
#! @input proxy_host: optional - proxy server used to access OpenStack services
#! @input proxy_port: optional - proxy server port used to access OpenStack services
#! @output return_result: response of operation in case of success, error message otherwise
#! @output error_message: return_result if status code is not '202'
#! @result SUCCESS: OpenStack server (instance) was successfully deleted
#! @result GET_AUTHENTICATION_TOKEN_FAILURE: authentication token cannot be obtained from authentication call response
#! @result GET_TENANT_ID_FAILURE: tenant_id corresponding to tenant_name cannot be obtained from authentication call response
#! @result GET_AUTHENTICATION_FAILURE: authentication call failed
#! @result GET_SERVERS_FAILURE: call for list OpenStack servers (instances) fails
#! @result GET_SERVER_ID_FAILURE: server ID cannot be obtained
#! @result DELETE_SERVER_FAILURE: OpenStack server (instance) could not be deleted
#!!#
####################################################

namespace: io.cloudslang.cloud.openstack.servers

imports:
 openstack: io.cloudslang.cloud.openstack
 utils: io.cloudslang.cloud.openstack.utils
 servers: io.cloudslang.cloud.openstack.servers

flow:
  name: delete_server_flow
  inputs:
    - host
    - identity_port: '5000'
    - compute_port: '8774'
    - username
    - password:
        sensitive: true
    - tenant_name
    - server_name
    - proxy_host:
        required: false
    - proxy_port:
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
        publish:
          - token
          - tenant_id
          - return_result
          - error_message
        navigate:
          - SUCCESS: get_servers
          - GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          - GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          - GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE

    - get_servers:
        do:
          servers.get_servers:
            - host
            - compute_port
            - token
            - tenant_id
            - proxy_host
            - proxy_port
        publish:
          - server_list: ${return_result}
          - return_result
          - error_message
        navigate:
          - SUCCESS: get_server_id
          - FAILURE: GET_SERVERS_FAILURE

    - get_server_id:
        do:
          utils.get_server_id:
            - server_body: ${server_list}
            - server_name: ${server_name}
        publish:
          - server_id
          - return_result
          - error_message
        navigate:
          - SUCCESS: delete_server
          - FAILURE: GET_SERVER_ID_FAILURE

    - delete_server:
        do:
          servers.delete_server:
            - host
            - compute_port
            - token
            - tenant_id
            - server_id
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: DELETE_SERVER_FAILURE

  outputs:
    - return_result
    - error_message

  results:
    - SUCCESS
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - GET_AUTHENTICATION_FAILURE
    - GET_SERVERS_FAILURE
    - GET_SERVER_ID_FAILURE
    - DELETE_SERVER_FAILURE
