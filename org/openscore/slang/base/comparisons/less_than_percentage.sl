#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will succeed if the first input is less than the second input
#   Inputs:
#       - first_percentage - string which represents a percentage (must contain "%") - ex. (50%)
#       - second_percentage - string which represents a percentage (must contain "%") - ex. (50%)
#   Outputs:
#       - first_percentage_nr - first input string without "%"
#       - second_percentage_nr - second input string without "%"
#   Results:
#       - SUCCESS - succeeds if first_percentage < second_percentage
#       - FAILURE - fails if first_percentage >= second_percentage
####################################################

namespace: org.openscore.slang.base.comparisons

operations:
  - less_than_percentage:
        inputs:
          - first_percentage
          - second_percentage
        action:
          python_script: |
            first_percentage_nr = first_percentage.replace("%", "")
            second_percentage_nr = second_percentage.replace("%", "")
        outputs:
          - first_percentage_nr
          - second_percentage_nr
        results:
          - SUCCESS: first_percentage_nr < second_percentage_nr
          - FAILURE
