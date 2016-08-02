#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Checks if an OpenStack server exists.
#! @input host: OpenStack machine host
#! @input identity_port: optional - port used for OpenStack authentication - Default: '5000'
#! @input compute_port: optional - port used for OpenStack computations - Default: '8774'
#! @input username: OpenStack username
#! @input password: OpenStack password
#! @input tenant_name: name of OpenStack project
#! @input proxy_host: optional - proxy server used to access web site
#! @input proxy_port: optional - proxy server port
#! @input server_name: server name to check
#! @output return_result: response of last operation executed
#! @output error_message: error message of operation that failed
#! @result SUCCESS: the OpenStack server (instance) exist
#! @result GET_AUTHENTICATION_TOKEN_FAILURE: authentication token cannot be obtained from authentication call response
#! @result GET_TENANT_ID_FAILURE: tenant_id corresponding to tenant_name cannot be obtained from authentication call response
#! @result GET_AUTHENTICATION_FAILURE: authentication call fails
#! @result GET_SERVERS_FAILURE: call for list OpenStack servers (instances) fails
#! @result EXTRACT_SERVERS_FAILURE: list of OpenStack servers (instances) could not be retrieved
#! @result CHECK_SERVER_FAILURE: check for specified OpenStack server (instance) fails
#!!#
####################################################

namespace: io.cloudslang.cloud.openstack

imports:
  utils: io.cloudslang.cloud.openstack.utils
  servers: io.cloudslang.cloud.openstack.servers

flow:
  name: validate_server_exists
  inputs:
    - host
    - identity_port: '5000'
    - compute_port: '8774'
    - username
    - password:
        sensitive: true
    - tenant_name
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - server_name

  workflow:
    - get_server_list:
        do:
          servers.list_servers:
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
          - SUCCESS: check_server
          - GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          - GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          - GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          - GET_SERVERS_FAILURE: GET_SERVERS_FAILURE
          - EXTRACT_SERVERS_FAILURE: EXTRACT_SERVERS_FAILURE

    - check_server:
        do:
          utils.check_server:
            - server_to_find: ${server_name}
            - server_list
        publish:
          - return_result
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_SERVER_FAILURE
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
