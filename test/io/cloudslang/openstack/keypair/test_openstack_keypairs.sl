#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.openstack.keypair

imports:
  openstack_content: io.cloudslang.openstack

flow:
  name: test_openstack_keypairs
  inputs:
    - host
    - username
    - password
    - tenant_name
    - keypair_name
    - identity_port:
        default: "'5000'"
    - compute_port:
        default: "'8774'"

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
          SUCCESS: create_keypair
          FAILURE: AUTHENTICATION_FAILURE

    - create_keypair:
        do:
          create_openstack_keypair:
            - host
            - token
            - tenant
            - compute_port
            - keypair_name
        navigate:
          SUCCESS: list_keypairs
          FAILURE: CREATE_FAILURE

    - list_keypairs:
        do:
          list_openstack_keypairs:
            - host
            - username
            - password
            - tenant_name
            - identity_port
            - compute_port
        publish:
          - keypair_list
        navigate:
          SUCCESS: delete_keypair
          FAILURE: GET_FAILURE
    - delete_keypair:
        do:
          delete_openstack_keypair_flow:
            - host
            - username
            - password
            - tenant_name
            - identity_port
            - compute_port
            - keypair_name
        navigate:
          SUCCESS: SUCCESS
          FAILURE: DELETE_FAILURE
  outputs:
    - keypair_list
  results:
    - SUCCESS
    - AUTHENTICATION_FAILURE
    - CREATE_FAILURE
    - GET_FAILURE
    - DELETE_FAILURE