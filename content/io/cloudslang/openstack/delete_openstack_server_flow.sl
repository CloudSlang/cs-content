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
#   - identity_port - optional - port used for OpenStack authentication - Default: 5000
#   - compute_port - optional - port used for OpenStack computations - Default: 8774
#   - username - OpenStack username
#   - password - OpenStack password
#   - server_name - name of server to delete
#   - tenant_name - name of the project on OpenStack
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - response of the last operation that was executed
#   - error_message - error message of the operation that failed
# Results:
#   - SUCCESS - the OpenStack server (instance) was successfully deleted
#   - GET_AUTHENTICATION_FAILURE - the authentication call fails
#   - GET_AUTHENTICATION_TOKEN_FAILURE - the authentication token cannot be obtained from authentication call response
#   - GET_TENANT_ID_FAILURE - the tenant_id corresponding to tenant_name cannot be obtained from authentication call response
#   - DELETE_SERVER_FAILURE - the OpenStack server (instance) could not be deleted
####################################################

namespace: io.cloudslang.openstack

imports:
 openstack_utils: io.cloudslang.openstack.utils
flow:
  name: delete_openstack_server_flow
  inputs:
    - host
    - identity_port: "'5000'"
    - compute_port: "'8774'"
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
          - server_list: return_result
          - return_result
          - error_message
        navigate:
          SUCCESS: get_server_id
          FAILURE: GET_SERVERS_FAILURE

    - get_server_id:
        do:
          openstack_utils.get_server_id:
            - server_body: server_list
            - server_name: server_name
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