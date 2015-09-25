#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.openstack

flow:
  name: test_get_openstack_server_details
  inputs:
    - host
    - username
    - password
    - tenant_name
    - server_id

  workflow:
    - get_authentication:
        do:
          get_authentication_flow:
            - host
            - username
            - password
            - tenant_name
        publish:
          - token
          - tenant
          - return_result
          - error_message
        navigate:
          SUCCESS: get_server_details
          FAILURE: AUTHENTICATION_FAILURE
    - get_server_details:
        do:
          get_openstack_server_details:
            - host
            - token
            - tenant: tenant_name
            - server_id
        publish:
          - token
          - tenant
          - return_result
          - error_message
        navigate:
          SUCCESS: SUCCESS
          FAILURE: GET_OPENSTACK_SERVER_DETAILS_FAILURE
  results:
    - SUCCESS
    - AUTHENTICATION_FAILURE
    - GET_OPENSTACK_SERVER_DETAILS_FAILURE