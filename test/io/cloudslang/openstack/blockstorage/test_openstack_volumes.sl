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
  openstack_blockstorage: io.cloudslang.openstack.blockstorage
  openstack_content: io.cloudslang.openstack
flow:
  name: test_openstack_volumes
  inputs:
    - host
    - username
    - password
    - size
    - tenant_name
    - volume_name
    - identity_port:
        default: "'5000'"
    - blockstorage_port:
        default: "'8776'"

  workflow:
    - authenticate:
        do:
          openstack_content.get_authentication_flow:
            - host
            - username
            - password
            - identity_port
            - tenant_name
        publish:
          - token
          - tenant
          - return_result
          - error_message
        navigate:
          SUCCESS: create_volume
          FAILURE: AUTHENTICATION_FAILURE

    - create_volume:
        do:
          openstack_blockstorage.create_openstack_volume:
            - host
            - token
            - tenant
            - blockstorage_port
            - size
            - volume_name
        navigate:
          SUCCESS: list_volumes
          FAILURE: CREATE_FAILURE

    - list_volumes:
        do:
          openstack_blockstorage.list_openstack_volumes:
            - host
            - username
            - password
            - tenant_name
            - identity_port
            - blockstorage_port
        publish:
          - volume_list
        navigate:
          SUCCESS: delete_volume
          FAILURE: GET_FAILURE
    - delete_volume:
        do:
          openstack_blockstorage.delete_openstack_volume_flow:
            - host
            - username
            - password
            - tenant_name
            - identity_port
            - blockstorage_port
            - volume_name
        navigate:
          SUCCESS: SUCCESS
          FAILURE: DELETE_FAILURE
  outputs:
    - volume_list
  results:
    - SUCCESS
    - AUTHENTICATION_FAILURE
    - CREATE_FAILURE
    - GET_FAILURE
    - DELETE_FAILURE