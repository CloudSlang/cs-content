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
  strings: io.cloudslang.base.strings
  base_print: io.cloudslang.base.print

flow:
  name: test_parse_date

  inputs:
    - date:
        required: true
    - date_format:
        required: false
    - date_locale_lang:
        required: false
    - date_locale_country:
        required: false
    - out_format:
        required: false
    - out_locale_lang:
        required: false
    - out_locale_country:
        required: false

  workflow:
    - execute_parse_date:
        do:
          parse_date:
            - date
            - date_format
            - date_locale_lang
            - date_locale_country
            - out_format
            - out_locale_lang
            - out_locale_country
        publish:
            - returnStr: ${result}
        navigate:
            - SUCCESS: verify_against_expected_result
            - FAILURE: FAILURE

    - verify_against_expected_result:
        do:
          strings.string_equals:
            - first_string: 'mer, lug 4, ''01'
            - second_string: ${returnStr}
        navigate:
            - SUCCESS: print_result
            - FAILURE: OUTPUT_IS_INCORRECT

    - print_result:
        do:
          base_print.print_text:
            - text: "${'result:<' + returnStr + '>'}"

  results:
    - SUCCESS
    - FAILURE
    - OUTPUT_IS_INCORRECT
