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

flow:
  name: test_http_client_put

  inputs:
    - url
    - username:
        required: false
    - password:
        required: false
    - content_type: "'application/json'"
    - body: "'{\"id\":' + input_id + ',\"name\":\"' + input_name + '_updated\",\"status\":\"sold\"}'"
    - attempts: "'1'"
    - proxy_host: "'proxy.houston.hp.com'"
    - proxy_port: "'8080'"
    - auth_type: "'basic'"

  workflow:
    - put:
        do:
          http_client_action:
            - url
            - username
            - password
            - contentType: content_type
            - method:
                default: "'PUT'"
                overridable: false
            - attempts
            - proxyHost: proxy_host
            - proxyPort: proxy_port
            - authType: auth_type
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: check_result
          FAILURE: HTTP_CLIENT_PUT_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: [str(error_message), int(return_code), int(status_code)]
            - list_2: ["''", 0, 200]
        navigate:
          SUCCESS: SUCCESS
          FAILURE: CHECK_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - HTTP_CLIENT_PUT_FAILURE
    - CHECK_FAILURE