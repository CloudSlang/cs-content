#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Authenticates and deletes OpenStack volume.
#
# Inputs:
#   - host - OpenStack machine host
#   - identity_port - optional - port used for OpenStack authentication - Default: 5000
#   - blockstorage_port - optional - port used for creating volumes on OpenStack - Default: 8776
#   - username - OpenStack username
#   - password - OpenStack password
#   - tenant_name - name of the project on OpenStack
#   - volume_name - name of server to delete
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - response of the last operation that was executed
#   - error_message - error message of the operation that failed
# Results:
#   - SUCCESS - the specified OpenStack volume was successfully deleted
#   - GET_AUTHENTICATION_TOKEN_FAILURE - the authentication token cannot be obtained from authentication call response
#   - GET_TENANT_ID_FAILURE - the tenant_id corresponding to tenant_name cannot be obtained from authentication call response
#   - GET_AUTHENTICATION_FAILURE - the authentication call fails
#   - GET_VOLUMES_FAILURE - the list with OpenStack volumes cannot be retrieved
#   - GET_VOLUME_ID_FAILURE - the specified volume id could not be retrieved
#   - DELETE_VOLUME_FAILURE - the specified OpenStack volume could not be deleted
####################################################

namespace: io.cloudslang.openstack.blockstorage

imports:
 openstack_content: io.cloudslang.openstack
 openstack_utils: io.cloudslang.openstack.utils

flow:
  name: delete_openstack_volume_flow
  inputs:
    - host
    - identity_port: "'5000'"
    - blockstorage_port: "'8776'"
    - username
    - password
    - tenant_name
    - volume_name
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
          SUCCESS: get_volumes
          GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE

    - get_volumes:
        do:
          get_openstack_volumes:
            - host
            - blockstorage_port
            - token
            - tenant_id
            - proxy_host
            - proxy_port
        publish:
          - volume_list: return_result
          - return_result
          - error_message
        navigate:
          SUCCESS: get_volume_id
          FAILURE: GET_VOLUMES_FAILURE

    - get_volume_id:
        do:
          openstack_utils.get_volume_id:
            - volume_body: volume_list
            - volume_name: volume_name
        publish:
          - volume_id
          - return_result
          - error_message
        navigate:
          SUCCESS: delete_volume
          FAILURE: GET_VOLUME_ID_FAILURE

    - delete_volume:
        do:
          delete_openstack_volume:
            - host
            - blockstorage_port
            - token
            - tenant_id
            - volume_id
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - error_message
        navigate:
          SUCCESS: SUCCESS
          FAILURE: DELETE_VOLUME_FAILURE

  outputs:
    - return_result
    - error_message

  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - GET_VOLUMES_FAILURE
    - GET_VOLUME_ID_FAILURE
    - DELETE_VOLUME_FAILURE