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
  name: test_http_client_post

  inputs:
    - url
    - username:
        required: false
    - password:
        required: false
    - contentType: "'application/json'"
    - method:
        default: "'POST'"
        overridable: false
    - body: "'{\"id\":' + input_id + ',\"name\":\"' + input_name + '\",\"status\":\"available\"}'"
    - attempts: "'1'"
    - proxyHost: "'proxy.houston.hp.com'"
    - proxyPort: "'8080'"
    - authType: "'basic'"

  workflow:
    - post:
        do:
          http_client_action:
            - url
            - username
            - password
            - contentType
            - method
            - attempts
            - proxyHost
            - proxyPort
            - authType
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: check_result
          FAILURE: HTTP_CLIENT_POST_FAILURE

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
    - HTTP_CLIENT_POST_FAILURE
    - CHECK_FAILURE