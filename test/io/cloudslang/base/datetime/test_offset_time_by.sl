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
  name: test_offset_time_by

  inputs:
    - date:
        required: true
    - offset:
        required: true
    - locale_lang:
        required: false
    - localeLang:
        private: true
        default: ${get("locale_lang", "en")} 
    - locale_country:
        required: false
    - localeCountry:
        private: true
        default: ${get("locale_country", "US")}

  workflow:
    - execute_offset_time_by:
        do:
          offset_time_by:
            - date
            - offset
            - localeLang
            - localeCountry
        publish:
            - returnStr: ${result}
        navigate:
            - SUCCESS: verify_against_expected_result
            - FAILURE: FAILURE

    - verify_against_expected_result:
        do:
          strings.string_equals:
            - first_string: 'April 26, 2016 1:32:25 PM EEST'
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
