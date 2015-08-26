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
  parser: io.cloudslang.base.network.rest.utils
  utils: io.cloudslang.base.utils
flow:
  name: test_http_client_action
  inputs:
    - url
    - username:
        required: false
    - password:
        required: false
    - contentType:
        default: "'text/plain'"
    - method
    - attempts
  workflow:
    - test_http_client_action_put_create_db:
        do:
          http_client_action:
            - url
            - username
            - password
            - contentType
            - method
            - attempts
        publish:
          - return_result
        navigate:
          SUCCESS: sleep0
          FAILURE: FAILURE
    - sleep0:
        do:
          utils.sleep:
            - seconds: 10
        navigate:
          SUCCESS: test_http_client_action_put_create_collection
          FAILURE: FAILURE
    - test_http_client_action_put_create_collection:
        do:
          http_client_action:
            - url:
                default: "url + '/myfirstcoll'"
                overridable: false
            - username
            - password
            - contentType
            - method
            - attempts
        publish:
          - return_result
        navigate:
          SUCCESS: test_http_client_action_post_create_document_inside_collection
          FAILURE: FAILURE
    - test_http_client_action_post_create_document_inside_collection:
        do:
          http_client_action:
            - url:
                default: "url + '/myfirstcoll'"
                overridable: false
            - username
            - password
            - contentType
            - method:
                default: "'POST'"
                overridable: false
            - attempts
        publish:
          - return_result
        navigate:
          SUCCESS: sleep1
          FAILURE: FAILURE
    - sleep1:
        do:
          utils.sleep:
            - seconds: 10
        navigate:
          SUCCESS: test_http_client_action_get_collection
          FAILURE: FAILURE
    - test_http_client_action_get_collection:
        do:
          http_client_action:
            - url:
                default: "url + '/myfirstcoll'"
                overridable: false
            - username
            - password
            - contentType
            - method:
                default: "'GET'"
                overridable: false
            - attempts
        publish:
          - return_result
        navigate:
          SUCCESS: parse_etag_collection
          FAILURE: FAILURE
    - parse_etag_collection:
        do:
          parser.parse_etag:
            - json_response: return_result
        publish:
          - etag_id
        navigate:
          SUCCESS: test_http_client_action_delete_collection
          FAILURE: FAILURE
    - test_http_client_action_delete_collection:
        do:
          http_client_action:
            - url:
                default: "url + '/myfirstcoll'"
                overridable: false
            - username
            - password
            - headers: "'If-Match:' + etag_id"
            - contentType
            - method:
                default: "'DELETE'"
                overridable: false
            - attempts
        publish:
          - return_result
          - status_code
          - return_code
        navigate:
          SUCCESS: test_http_client_action_get_db
          FAILURE: FAILURE
    - test_http_client_action_get_db:
        do:
          http_client_action:
            - url
            - username
            - password
            - contentType
            - method:
                default: "'GET'"
                overridable: false
            - attempts
        publish:
          - return_result
        navigate:
          SUCCESS: parse_etag_db
          FAILURE: FAILURE
    - parse_etag_db:
        do:
          parser.parse_etag:
            - json_response: return_result
        publish:
          - etag_id
        navigate:
          SUCCESS: sleep2
          FAILURE: FAILURE
    - sleep2:
        do:
          utils.sleep:
            - seconds: 10
        navigate:
          SUCCESS: test_http_client_action_delete_db
          FAILURE: FAILURE
    - test_http_client_action_delete_db:
        do:
          http_client_action:
            - url
            - username
            - password
            - headers: "'If-Match:' + etag_id"
            - contentType
            - connectTimeout: "'9'"
            - socketTimeout: "'9000'"
            - method:
                default: "'DELETE'"
                overridable: false
            - attempts
        publish:
          - return_result
          - status_code
          - return_code
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE
  outputs:
    - status_code
    - return_code
    - return_result
  results:
    - SUCCESS
    - FAILURE
