#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.base.datetime

imports:
  datetime: io.cloudslang.base.datetime
  strings: io.cloudslang.base.strings

flow:
  name: test_get_time

  inputs:
    - locale_lang:
        required: false
    - locale_country:
        required: false
    - timezone:
        required: false
    - date_format:
        required: false

  workflow:
    - execute_get_current_time:
        do:
          datetime.get_time:
            - locale_lang
            - locale_country
            - timezone
            - date_format
        publish:
            - response: ${result}
        navigate:
            - SUCCESS: verify_output_is_not_empty
            - FAILURE: GET_CURRENT_TIME_FAILURE

    - verify_output_is_not_empty:
        do:
          strings.string_equals:
            - first_string: ''
            - second_string: ${response}
        navigate:
            - SUCCESS: OUTPUT_IS_EMPTY
            - FAILURE: SUCCESS

  results:
    - SUCCESS
    - GET_CURRENT_TIME_FAILURE
    - OUTPUT_IS_EMPTY
