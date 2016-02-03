#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Checks if an OpenStack server exists.
#
# Inputs:
#   - host - OpenStack machine host
#   - identity_port - optional - port used for OpenStack authentication - Default: '5000'
#   - compute_port - optional - port used for OpenStack computations - Default: '8774'
#   - username - OpenStack username
#   - password - OpenStack password
#   - tenant_name - name of OpenStack project
#   - proxy_host - optional - proxy server used to access web site
#   - proxy_port - optional - proxy server port
#   - server_name - server name to check
# Outputs:
#   - return_result - response of last operation executed
#   - error_message - error message of operation that failed
# Results:
#   - SUCCESS - the OpenStack server (instance) exist
#   - GET_AUTHENTICATION_TOKEN_FAILURE - authentication token cannot be obtained from authentication call response
#   - GET_TENANT_ID_FAILURE - tenant_id corresponding to tenant_name cannot be obtained from authentication call response
#   - GET_AUTHENTICATION_FAILURE - authentication call fails
#   - GET_SERVERS_FAILURE - call for list OpenStack servers (instances) fails
#   - EXTRACT_SERVERS_FAILURE - list of OpenStack servers (instances) could not be retrieved
#   - CHECK_SERVER_FAILURE - check for specified OpenStack server (instance) fails
####################################################

namespace: io.cloudslang.openstack

imports:
  openstack_utils: io.cloudslang.openstack.utils

flow:
  name: validate_server_exists
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
    - server_name

  workflow:
    - get_server_list:
        do:
          list_servers:
            - host
            - identity_port
            - compute_port
            - username
            - password
            - tenant_name
            - proxy_host
            - proxy_port
        publish:
          - server_list
          - return_result
          - error_message
        navigate:
          SUCCESS: check_server
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          GET_SERVERS_FAILURE: GET_SERVERS_FAILURE
          EXTRACT_SERVERS_FAILURE: EXTRACT_SERVERS_FAILURE

    - check_server:
        do:
          openstack_utils.check_server:
            - server_to_find: ${server_name}
            - server_list
        publish:
          - return_result
          - error_message
        navigate:
          SUCCESS: SUCCESS
          FAILURE: CHECK_SERVER_FAILURE
  outputs:
    - return_result
    - error_message

  results:
    - SUCCESS
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - GET_AUTHENTICATION_FAILURE
    - GET_SERVERS_FAILURE
    - EXTRACT_SERVERS_FAILURE
    - CHECK_SERVER_FAILURE
