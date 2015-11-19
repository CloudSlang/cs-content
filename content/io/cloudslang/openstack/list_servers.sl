#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Retrieves a list of servers on an OpenStack machine.
#
# Inputs:
#   - host - OpenStack machine host
#   - identity_port - optional - port used for OpenStack authentication - Default: 5000
#   - compute_port - optional - port used for OpenStack computations - Default: 8774
#   - username - OpenStack username
#   - password - OpenStack password
#   - tenant_name - name of the project on OpenStack
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - server_list - list of server names
#   - return_result - response of the last operation executed
#   - error_message - error message of the operation that failed
# Results:
#   - SUCCESS - the list of OpenStack servers (instances) was successfully retrieved
#   - GET_AUTHENTICATION_FAILURE - the authentication call fails
#   - GET_AUTHENTICATION_TOKEN_FAILURE - the authentication token cannot be obtained from authentication call response
#   - GET_TENANT_ID_FAILURE - the tenant_id corresponding to tenant_name cannot be obtained from authentication call response
#   - GET_SERVERS_FAILURE - the call for list OpenStack servers (instances) fails
#   - EXTRACT_SERVERS_FAILURE - the list of OpenStack servers (instances) could not be retrieved
####################################################

namespace: io.cloudslang.openstack

imports:
  openstack_utils: io.cloudslang.openstack.utils

flow:
  name: list_servers
  inputs:
    - host
    - identity_port: '5000'
    - compute_port: '8774'
    - username
    - password
    - tenant_name
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
          SUCCESS: get_openstack_servers
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE

    - get_openstack_servers:
        do:
          get_openstack_servers:
            - host
            - compute_port
            - token
            - tenant_id
            - proxy_host
            - proxy_port
        publish:
          - response_body: ${return_result}
          - return_result: ${return_result}
          - error_message
        navigate:
          SUCCESS: extract_servers
          FAILURE: GET_SERVERS_FAILURE

    - extract_servers:
        do:
          openstack_utils.extract_object_list_from_json_response:
            - response_body
            - object_name: 'servers'
        publish:
          - object_list
          - error_message
        navigate:
          SUCCESS: SUCCESS
          FAILURE: EXTRACT_SERVERS_FAILURE

  outputs:
    - server_list: ${object_list}
    - return_result
    - error_message

  results:
    - SUCCESS
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - GET_AUTHENTICATION_FAILURE
    - GET_SERVERS_FAILURE
    - EXTRACT_SERVERS_FAILURE