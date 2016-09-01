#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
##################################################
#!!
#! @description: Generates a random number.
#! @input max: maximum number that can be returned
#! @input min: minimum number that can be returned
#! @output random_number: random number between max and min (inclusive)
#! @output error_message: error message if error occurred
#! @result SUCCESS: a number was generated
#! @result FAILURE: otherwise
#!!#
##################################################
namespace: io.cloudslang.base.utils

operation:
  name: random_number_generator
  inputs:
    - min
    - max
  python_action:
    script: |
      import random

      random_number = None
      error_message = ""

      valid = 0
      length = len(min)
      vall = min[1:length]
      if min.isdigit() or (min.startswith("-") and vall.isdigit()):
        valid = 1
      else:
        valid = 0
      length = len(max)
      vall = max[1:length]
      if max.isdigit() or (max.startswith("-") and vall.isdigit()):
        valid = valid and 1
      else:
        valid = 0

      if valid == 1:
        minInteger = int(min)
        maxInteger = int(max)
        if minInteger > maxInteger:
          error_message = "Minimum number (%s) is bigger than maximum number(%s)" %(min,max)
        else:
          random_number = random.randint(minInteger,maxInteger)
      else:
          error_message = "%s or %s are not integers" %(min,max)
  outputs:
    - random_number
    - error_message
  results:
    - SUCCESS: ${ random_number is not None }
    - FAILURE
