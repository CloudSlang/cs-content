#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################

namespace: io.cloudslang.cloud.amazon_aws.signature

imports:
  lists: io.cloudslang.base.lists
  signature: io.cloudslang.cloud.amazon_aws.signature
  strings: io.cloudslang.base.strings

flow:
  name: test_compute_signature_v4

  inputs:
    - endpoint
    - identity
    - credential
    - amazon_api
    - uri
    - http_verb
    - payload_hash
    - security_token
    - date
    - headers
    - query_params

  workflow:
    - compute_signature:
        do:
          signature.compute_signature_v4:
            - endpoint
            - identity
            - credential
            - amazon_api
            - uri
            - http_verb
            - payload_hash
            - security_token
            - date
            - headers
            - query_params
        publish:
          - authorization_header: ${authorizationHeader}
          - signature
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_result
          - FAILURE: COMPUTE_SIGNATURE_V4_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${str(exception) + "," + return_code}
            - list_2: ",0"
        navigate:
          - SUCCESS: check_authorization_type_exist
          - FAILURE: CHECK_RESULT_FAILURE

    - check_authorization_type_exist:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${return_result}
            - string_to_find: 'Authorization:AWS4-HMAC-SHA256 Credential=AKIAIOSFODNN7EXAMPLE/20130524/us-east-1/s3/aws4_request'
        navigate:
          - SUCCESS: check_signature
          - FAILURE: CHECK_AUTHORIZATION_TYPE_EXIST_FAILURE

    - check_signature:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${signature}
            - string_to_find: 'f0e8bdb87c964420e857bd35b5d6ed310bd44f0170aba48dd91039c6036bdb41'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_SIGNATURE_FAILURE

  results:
    - SUCCESS
    - COMPUTE_SIGNATURE_V4_FAILURE
    - CHECK_RESULT_FAILURE
    - CHECK_AUTHORIZATION_TYPE_EXIST_FAILURE
    - CHECK_SIGNATURE_FAILURE
