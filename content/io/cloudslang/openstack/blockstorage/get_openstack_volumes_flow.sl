#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Retrieves the list of volumes from an OpenStack machine.
#
# Inputs:
#   - host - OpenStack machine host
#   - identity_port - optional - port used for OpenStack authentication - Default: 5000
#   - blockstorage_port - optional - port used for OpenStack computations - Default: 8776
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
#   - SUCCESS - the OpenStack volume list was successfully retrieved
#   - GET_AUTHENTICATION_TOKEN_FAILURE - the authentication token cannot be obtained from authentication call response
#   - GET_TENANT_ID_FAILURE - the tenant_id corresponding to tenant_name cannot be obtained from authentication call response
#   - GET_AUTHENTICATION_FAILURE - the authentication call fails
#   - GET_VOLUMES_FAILURE - the call for list OpenStack volumes fails
#   - EXTRACT_VOLUMES_FAILURE - the list of OpenStack volumes could not be retrieved
####################################################

namespace: io.cloudslang.openstack.blockstorage

imports:
 openstack_content: io.cloudslang.openstack
 openstack_utils: io.cloudslang.openstack.utils

flow:
  name: get_openstack_volumes_flow
  inputs:
    - host
    - identity_port: "'5000'"
    - blockstorage_port: "'8776'"
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
          openstack_content.get_authentication_flow:
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
          SUCCESS: get_openstack_volumes
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE

    - get_openstack_volumes:
        do:
          get_openstack_volumes:
            - host
            - blockstorage_port
            - token
            - tenant_id
            - proxy_host
            - proxy_port
        publish:
          - response_body: return_result
          - return_result: return_result
          - error_message
        navigate:
          SUCCESS: extract_volumes
          FAILURE: GET_VOLUMES_FAILURE

    - extract_volumes:
        do:
          openstack_utils.extract_object_list_from_json_response:
            - response_body
            - object_name: "'volumes'"
        publish:
          - object_list
          - error_message
        navigate:
          SUCCESS: SUCCESS
          FAILURE: EXTRACT_VOLUMES_FAILURE

  outputs:
    - volume_list: object_list
    - return_result
    - error_message

  results:
    - SUCCESS
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - GET_AUTHENTICATION_FAILURE
    - GET_VOLUMES_FAILURE
    - EXTRACT_VOLUMES_FAILURE