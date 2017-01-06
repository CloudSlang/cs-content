#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
namespace: io.cloudslang.base.datetime

imports:
  datetime: io.cloudslang.base.datetime
  strings: io.cloudslang.base.strings

flow:
  name: test_offset_time_by

  inputs:
    - date: 'April 26, 2016 1:32:20 PM EEST'
    - offset: '5'
    - locale_lang:
        required: false
        default: 'en'
    - locale_country:
        required: false
        default: 'US'

  workflow:
    - execute_offset_time_by:
        do:
          datetime.offset_time_by:
            - date
            - offset
            - locale_lang
            - locale_country
        publish:
            - output
        navigate:
            - SUCCESS: verify_against_expected_result
            - FAILURE: OFFSET_TIME_BY_FAILURE

    - verify_against_expected_result:
        do:
          strings.string_equals:
            - first_string: 'April 26, 2016 1:32:25 PM EEST'
            - second_string: ${output}
        navigate:
            - SUCCESS: SUCCESS
            - FAILURE: INCORRECT_OUTPUT

  results:
    - SUCCESS
    - OFFSET_TIME_BY_FAILURE
    - INCORRECT_OUTPUT
