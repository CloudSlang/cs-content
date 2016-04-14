#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.cloud.openstack.servers

imports:
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings

flow:
  name: test_get_server_details
  inputs:
    - host
    - compute_port: '8774'
    - tenant_name
    - tenant_id
    - server_id
    - username:
        required: false
    - password:
        required: false
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
    - get_server_details:
        do:
          get_server_details:
            - host
            - compute_port
            - tenant_name
            - tenant_id
            - server_id
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
          - SUCCESS: check_get_server_details_result
          - GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          - GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          - GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          - GET_SERVER_DETAILS_FAILURE: GET_SERVER_DETAILS_FAILURE

    - check_get_server_details_result:
        do:
          lists.compare_lists:
            - list_1: ${[str(error_message), int(return_code), int(status_code)]}
            - list_2: ['', 0, 200]
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_GET_SERVER_DETAILS_RESPONSES_FAILURE

  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - GET_SERVER_DETAILS_FAILURE
    - CHECK_GET_SERVER_DETAILS_RESPONSES_FAILURE
