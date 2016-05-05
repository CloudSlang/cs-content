#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
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
    - date
    - dateFormat
    - dateLocaleLang
    - dateLocaleCountry
    - outFormat
    - outLocaleLang
    - outLocaleCountry

  workflow:
    - execute_parse_date:
        do:
          parse_date:
            - date
            - dateFormat
            - dateLocaleLang
            - dateLocaleCountry
            - outFormat
            - outLocaleLang
            - outLocaleCountry
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
