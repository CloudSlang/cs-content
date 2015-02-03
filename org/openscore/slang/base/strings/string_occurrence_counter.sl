#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will count the occurrences of a string in another string ( *needs to be more general).
#
#   Inputs:
#       - string_in_which_to_search - string where to search
#       - string_to_find - string to be found
#       - ignore_case - optional - ignores case if set to true - Default: true
#   Outputs:
#       - occurrence - number of times toFind was found in container
#       - return_result - notification string
#       - return_code - 0 if everything went ok, -1 if an error was thrown
#       - error_message: returnResult if occurrence == '0'  else ''
#   Results:
#       - SUCCESS - string is found at least once
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.base.strings

operation:
  name: string_occurrence_counter
      inputs:
        - string_in_which_to_search
        - string_to_find
        - ignore_case:
            default: "''true'"
            required: false
      action:
        python_script: |
          try:
            if ignore_case == 'true':
              string_in_which_to_search.lower()
              string_to_find.lower()
            occurrence = string_in_which_to_search.count(string_to_find)
            return_code = '0'
            if occurrence == 0:
              return_result = 'Server was not created'
            else:
              return_result = occurrence
          except:
            return_code = '-1'
            return_result = 'String occurrence error.'
      outputs:
        - occurrence
        - return_result
        - return_code
        - error_message: return_result if occurrence == '0'  else ''
      results:
        - SUCCESS: occurrence >= '1'
        - FAILURE