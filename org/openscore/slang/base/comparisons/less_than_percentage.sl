#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will succeed if the first input is less than the second input.
#
#   Inputs:
#       - first_percentage - string which represents a percentage (must contain "%") - ex. (50%)
#       - second_percentage - string which represents a percentage (must contain "%") - ex. (50%)
#   Outputs:
#       - first_percentage_nr - first input string without "%"
#       - second_percentage_nr - second input string without "%"
#       - error_message - error occurred
        - result - True if first_percentage < second_percentage, False otherwise
#   Results:
#       - SUCCESS - succeeds if first_percentage < second_percentage
#       - FAILURE - fails if first_percentage >= second_percentage
#       - ERROR - if input was not in correct format
####################################################

namespace: org.openscore.slang.base.comparisons

operation:
  name: less_than_percentage
  inputs:
    - first_percentage
    - second_percentage
  action:
    python_script: |
      error_message = ""
      result = None
      first_percentage_nr = first_percentage.replace("%", "")
      second_percentage_nr = second_percentage.replace("%", "")
      try:
          int_value1 = int(first_percentage_nr)
          int_value2 = int(second_percentage_nr)
          result = error_message == "" and int_value1 < int_value2
      except ValueError:
          error_message = "Both inputs have to be integers"
  outputs:
    - first_percentage_nr
    - second_percentage_nr
    - error_message
    - result
  results:
    - LESS: result
    - MORE: not result
    - FAILURE: error_message <> ""