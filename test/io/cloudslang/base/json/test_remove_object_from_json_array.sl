#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.base.json

flow:
  name: test_remove_object_from_json_array

  inputs:
    - json_array
    - json_object
    - index:
        required: false
    - json_after

  workflow:
    - remove_object_from_json_array:
        do:
          remove_object_from_json_array:
            - json_array
            - json_object
            - index

        publish:
          - json_output

        navigate:
          - SUCCESS: test_equality
          - FAILURE: CREATEFAILURE

    - test_equality:
        do:
          equals:
            - json_input1: ${ json_output }
            - json_input2: ${ json_after }

        navigate:
          - EQUALS: SUCCESS
          - NOT_EQUALS: EQUALITY_FAILURE
          - FAILURE: FAILURE

  results:
    - SUCCESS
    - FAILURE
    - EQUALITY_FAILURE
    - CREATEFAILURE