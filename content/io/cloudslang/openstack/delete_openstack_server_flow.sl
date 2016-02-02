#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Authenticates and deletes an OpenStack server.
#
# Inputs:
#   - host - OpenStack machine host
#   - identity_port - optional - port used for OpenStack authentication - Default: '5000'
#   - compute_port - optional - port used for OpenStack computations - Default: '8774'
#   - username - username used for URL authentication; for NTLM authentication - Format: 'domain\user'
#   - password - password used for URL authentication
#   - tenant_name - name of OpenStack project that contains server (instance) to be deleted
#   - server_name - name of server to delete
#   - proxy_host - optional - proxy server used to access OpenStack services
#   - proxy_port - optional - proxy server port used to access OpenStack services
# Outputs:
#   - return_result - response of operation in case of success, error message otherwise
#   - error_message: return_result if status code is not '202'
# Results:
#   - SUCCESS - OpenStack server (instance) was successfully deleted
#   - GET_AUTHENTICATION_TOKEN_FAILURE - authentication token cannot be obtained from authentication call response
#   - GET_TENANT_ID_FAILURE - tenant_id corresponding to tenant_name cannot be obtained from authentication call response
#   - GET_AUTHENTICATION_FAILURE - authentication call failed
#   - GET_SERVERS_FAILURE - call for list OpenStack servers (instances) fails
#   - GET_SERVER_ID_FAILURE - server ID cannot be obtained
#   - DELETE_SERVER_FAILURE - OpenStack server (instance) could not be deleted
####################################################

namespace: io.cloudslang.openstack

imports:
 openstack_utils: io.cloudslang.openstack.utils
flow:
  name: delete_openstack_server_flow
  inputs:
    - host
    - identity_port: '5000'
    - compute_port: '8774'
    - username
    - password
    - tenant_name
    - server_name
    - proxy_host:
        required: false
    - proxy_port:
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
        publish:
          - token
          - tenant_id
          - return_result
          - error_message
        navigate:
          SUCCESS: get_servers
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE

    - get_servers:
        do:
          get_openstack_servers:
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
          SUCCESS: get_server_id
          FAILURE: GET_SERVERS_FAILURE

    - get_server_id:
        do:
          openstack_utils.get_server_id:
            - server_body: ${server_list}
            - server_name: ${server_name}
        publish:
          - server_id
          - return_result
          - error_message
        navigate:
          SUCCESS: delete_server
          FAILURE: GET_SERVER_ID_FAILURE

    - delete_server:
        do:
          delete_openstack_server:
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
          SUCCESS: SUCCESS
          FAILURE: DELETE_SERVER_FAILURE

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
