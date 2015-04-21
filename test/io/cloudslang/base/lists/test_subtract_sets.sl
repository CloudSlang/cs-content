#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.base.lists

imports:
  strings: io.cloudslang.base.strings
  lists: io.cloudslang.base.lists
flow:
  name: test_subtract_sets
  inputs:
    - set_1
    - set_1_delimiter
    - set_2
    - set_2_delimiter
    - result_set_delimiter
    - expected_output
  workflow:
    - test_subtract_sets_operation:
        do:
          lists.subtract_sets:
          - set_1
          - set_1_delimiter
          - set_2
          - set_2_delimiter
          - result_set_delimiter
        publish:
          - result_set
        navigate:
          SUCCESS: verify_returned_output
    - verify_returned_output:
        do:
          strings.string_equals:
            - first_string: expected_output
            - second_string: "'' if result_set == None else result_set"
        navigate:
          SUCCESS: SUCCESS
          FAILURE: DIFFERENT_OUTPUTS

  results:
    - SUCCESS
    - DIFFERENT_OUTPUTS