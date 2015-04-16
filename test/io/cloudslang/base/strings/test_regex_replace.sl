#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.base.strings

imports:
  strings: io.cloudslang.base.strings

flow:
  name: test_regex_replace
  inputs:
    - regex
    - text
    - replacement
    - expected_output
  workflow:
    - test_regex_replace_operation:
        do:
          strings.regex_replace:
            - regex
            - text
            - replacement
        publish:
          - result_text
    - verify_returned_output:
        do:
          strings.string_equals:
            - first_string: expected_output
            - second_string: result_text
        navigate:
          SUCCESS: SUCCESS
          FAILURE: DIFFERENT_OUTPUTS

  results:
    - SUCCESS
    - FAILURE
    - DIFFERENT_OUTPUTS