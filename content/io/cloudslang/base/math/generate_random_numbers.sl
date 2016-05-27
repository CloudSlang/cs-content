#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
#!!
#! @description: Generates a random number.
#! @input max: maximum number that can be returned
#! @input min: minimum number that can be returned
#! @output result: random number between max and min
#! @output error_message: error message if error occurred
#! @result SUCCESS: a number was generated
#! @result FAILURE: otherwise
#!!#
########################################################################################################

namespace: io.cloudslang.base.math

operation:
  name: generate_random_numbers

  inputs:
    - min
    - max

  python_action:
    script: |
      import random

      rand = None
      error_message = ""
      minInt = 0
      maxInt = 0

      if isinstance(min,int) and isinstance(max,int):
           if min < max :
              rand = random.randint(min, max)
           else:
              error_message = 'min must be less than max'
      elif isinstance(min,basestring) and isinstance(max,basestring):
             lengthMin = len(min)
             valueMin = min[1:lengthMin]
             lengthMax = len(max)
             valueMax = max[1:lengthMax]
             if min.isdigit() or (min[:1]=='-' and valueMin.isdigit()):
                 if max.isdigit() or (max[:1]=='-' and valueMax.isdigit()):
                    minInt = int(min)
                    maxInt = int(max)
                    if minInt < maxInt:
                      rand = random.randint(minInt, maxInt)
                    else:
                      error_message = 'min must be less than max'
                 else:
                   error_message = 'max and min must be integer'
             else:
                error_message = 'max and min must be integer'
      else:
         error_message = 'max and min must be integer'

  outputs:
    - result: ${rand}
    - error_message
  results:
    - SUCCESS: ${rand != None}
    - FAILURE
