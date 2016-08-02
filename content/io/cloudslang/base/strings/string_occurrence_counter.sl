#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Counts the occurrences of a string in another string.
#! @input string_in_which_to_search: string where to search
#! @input string_to_find: string to be found
#! @input ignore_case: optional - ignores case if set to true - Default: true
#! @output return_result: number of times string_to_find was found in container
#! @output return_code: 0 if everything went ok, -1 if an error was thrown
#! @output error_message: return_result if occurrence == '0'  else ''
#! @result SUCCESS: string is found at least once
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.base.strings

operation:
  name: string_occurrence_counter
  inputs:
    - string_in_which_to_search:
        required: false
    - string_to_find:
        required: false
    - ignore_case:
        default: 'true'
        required: false
  python_action:
    script: |
      try:
        if ignore_case == 'true':
          string_in_which_to_search = string_in_which_to_search.lower()
          string_to_find = string_to_find.lower()
        occurrence = string_in_which_to_search.count(string_to_find)
        return_code = '0'
        return_result = occurrence
      except:
        occurrence = 0
        return_code = '-1'
        return_result = occurrence
  outputs:
    - return_result
    - return_code
    - error_message: ${ return_result if occurrence == 0  else '' }
  results:
    - SUCCESS: ${ return_result >= 1 }
    - FAILURE
