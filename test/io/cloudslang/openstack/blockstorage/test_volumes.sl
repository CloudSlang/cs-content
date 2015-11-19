#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.openstack.blockstorage

imports:
  openstack_content: io.cloudslang.openstack

flow:
  name: test_volumes
  inputs:
    - host
    - identity_port: '5000'
    - blockstorage_port: '8776'
    - username
    - password
    - tenant_name
    - volume_name
    - size
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
    - create_volume:
        do:
          create_volume:
            - host
            - identity_port
            - blockstorage_port
            - tenant_name
            - volume_name
            - size
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
          - volume_id
        navigate:
          SUCCESS: get_volumes
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          CREATE_VOLUME_FAILURE: CREATE_VOLUME_FAILURE
          GET_VOLUME_ID_FAILURE: GET_VOLUME_ID_FAILURE

    - get_volumes:
        do:
          get_volumes:
            - host
            - identity_port
            - blockstorage_port
            - tenant_name
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
          - volume_list
        navigate:
          SUCCESS: delete_volume
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          GET_VOLUMES_FAILURE: GET_VOLUMES_FAILURE
          EXTRACT_VOLUMES_FAILURE: EXTRACT_VOLUMES_FAILURE

    - delete_volume:
        do:
          delete_volume:
            - host
            - identity_port
            - blockstorage_port
            - tenant_name
            - volume_id
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: SUCCESS
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          DELETE_VOLUME_FAILURE: DELETE_VOLUME_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - volume_id
    - volume_list

  results:
    - SUCCESS
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - GET_AUTHENTICATION_FAILURE
    - CREATE_VOLUME_FAILURE
    - GET_VOLUME_ID_FAILURE
    - GET_VOLUMES_FAILURE
    - EXTRACT_VOLUMES_FAILURE
    - DELETE_VOLUME_FAILURE