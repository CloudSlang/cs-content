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
  name: test_get_current_time

  inputs:
    - localeLang
    - localeCountry

  workflow:
    - execute_get_current_time:
        do:
          get_time:
            - localeLang
            - localeCountry
        publish:
            - returnStr: ${result}
        navigate:
            - SUCCESS: verify_output_is_not_empty
            - FAILURE: FAILURE

    - verify_output_is_not_empty:
        do:
          strings.string_equals:
            - first_string: ''
            - second_string: ${returnStr}
        navigate:
            - SUCCESS: OUTPUT_IS_EMPTY
            - FAILURE: print_result

    - print_result:
        do:
          base_print.print_text:
            - text: "${'result:<' + returnStr + '>'}"

  results:
    - SUCCESS
    - FAILURE
    - OUTPUT_IS_EMPTY
