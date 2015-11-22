#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.openstack.serveractions

imports:
  openstack: io.cloudslang.openstack
  lists: io.cloudslang.base.lists
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: test_softreboot_openstack_server

  inputs:
    - host
    - identity_port: '5000'
    - compute_port: '8774'
    - tenant_name
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
    - soft_reboot_server:
        do:
          softreboot_openstack_server:
            - host
            - identity_port
            - compute_port
            - tenant_name
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
          - token
        navigate:
          SUCCESS: check_soft_reboot_server_result
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          SOFT_REBOOT_SERVER_FAILURE: SOFT_REBOOT_SERVER_FAILURE

    - check_soft_reboot_server_result:
        do:
          lists.compare_lists:
            - list_1: ${[str(error_message), int(return_code), int(status_code)]}
            - list_2: ${["''", 0, 202]}
        navigate:
          SUCCESS: get_server_details
          FAILURE: CHECK_SOFT_REBOOT_SERVER_RESPONSES_FAILURE

    - get_server_details:
        do:
          openstack.get_openstack_server_details:
            - host
            - identity_port
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
          SUCCESS: check_get_server_details_result
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          GET_SERVER_DETAILS_FAILURE: GET_SERVER_DETAILS_FAILURE

    - check_get_server_details_result:
        do:
          lists.compare_lists:
            - list_1: ${[str(error_message), int(return_code), int(status_code)]}
            - list_2: ${["''", 0, 200]}
        navigate:
          SUCCESS: get_status
          FAILURE: CHECK_GET_SERVER_DETAILS_RESPONSES_FAILURE

    - get_status:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ${["'server'", "'status'"]}
        publish:
          - status: ${value}
        navigate:
          SUCCESS: verify_status
          FAILURE: GET_STATUS_FAILURE

    - verify_status:
        do:
          strings.string_equals:
            - first_string: 'REBOOT'
            - second_string: ${str(status)}
        navigate:
          SUCCESS: SUCCESS
          FAILURE: VERIFY_STATUS_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - status

  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - SOFT_REBOOT_SERVER_FAILURE
    - CHECK_SOFT_REBOOT_SERVER_RESPONSES_FAILURE
    - GET_SERVER_DETAILS_FAILURE
    - CHECK_GET_SERVER_DETAILS_RESPONSES_FAILURE
    - GET_STATUS_FAILURE
    - VERIFY_STATUS_FAILURE