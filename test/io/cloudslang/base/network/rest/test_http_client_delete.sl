#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.base.network.rest

imports:
  lists: io.cloudslang.base.lists
  json: io.cloudslang.base.json

flow:
  name: test_http_client_delete

  inputs:
    - url
    - username:
        required: false
    - password:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - content_type:
        default: "application/json"
        overridable: false

  workflow:
    - get:
        do:
          http_client_get:
            - url: ${url + '/findByStatus?status=available'}
            - username
            - password
            - proxy_host
            - proxy_port
            - content_type
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: check_get_result
          FAILURE: HTTP_CLIENT_GET_FAILURE

    - check_get_result:
        do:
          lists.compare_lists:
            - list_1: ${ [str(error_message), int(return_code), int(status_code)] }
            - list_2: ["", 0, 200]
        navigate:
          SUCCESS: get_id
          FAILURE: CHECK_GET_FAILURE

    - get_id:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: [0, 'id']
        publish:
          - id: ${value}
        navigate:
          SUCCESS: delete
          FAILURE: GET_ID_FAILURE

    - delete:
        do:
          http_client_delete:
            - url: ${url + '/' + str(id)}
            - username
            - password
            - content_type
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: check_delete_result
          FAILURE: HTTP_CLIENT_DELETE_FAILURE

    - check_delete_result:
        do:
          lists.compare_lists:
            - list_1: ${ [str(error_message), int(return_code), int(status_code)] }
            - list_2: ["", 0, 200]
        navigate:
          SUCCESS: SUCCESS
          FAILURE: CHECK_DELETE_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - id

  results:
    - SUCCESS
    - HTTP_CLIENT_GET_FAILURE
    - CHECK_GET_FAILURE
    - GET_ID_FAILURE
    - HTTP_CLIENT_DELETE_FAILURE
    - CHECK_DELETE_FAILURE