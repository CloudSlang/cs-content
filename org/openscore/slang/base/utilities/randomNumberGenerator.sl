#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
##################################################
# Generates a random number
#
# Inputs:
#   - max - The maximum number that can be returned.
#   - min - The minimum number that can be returned.
#
# Results:
#   - SUCCESS - The operation completed Successfully.
#   - FAILURE - Something went wrong.

# Outputs:
#   - returnResult - A random number between max and min (inclusive)
##################################################

namespace: org.openscore.slang.base.utilities
operations:
  - randomNumberGenerator:
      inputs:
        - min
        - max
      action:
        python_script: |    
          import random
          if min.isnumeric() and max.isnumeric():
            minInteger = int(min)
            maxInteger = int(max)
            if minInteger > maxInteger:
              returnResult = "Minimum number (%s) is bigger than maximum number(%s)" %(min,max)
            else:
              returnResult = random.randint(minInteger,maxInteger)
          else:
            returnResult = "%s or %s are not integers" %(min,max)
      outputs:
        - returnResult
      results:
        - SUCCESS
        - FAILURE