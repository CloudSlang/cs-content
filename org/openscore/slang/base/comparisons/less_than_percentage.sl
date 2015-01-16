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
#       - first_percentage
#       - second_percentage
#   Outputs:
#       - firstPercentageNr
#       - secondPercentageNr
#   Results:
#       - SUCCESS
#       - FAILURE
####################################################

namespace: org.openscore.slang.comparisons

operations:
  - less_than_percentage:
        inputs:
          - first_percentage
          - second_percentage
        action:
          python_script: |
            firstPercentageNr = first_percentage.replace("%", "")
            secondPercentageNr = second_percentage.replace("%", "")
        outputs:
          - firstPercentageNr
          - secondPercentageNr
        results:
          - SUCCESS: firstPercentageNr < secondPercentageNr
          - FAILURE
