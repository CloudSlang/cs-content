#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
#!!
#! @description: Divides two numbers as floating point values.
#! @input value1: first value as number or string
#! @input value2: second value as number or string
#! @output result: value1 divide value2
#! @result ILLEGAL: value2 == 0
#! @result SUCCESS: values divided
#!!#
########################################################################################################
namespace: io.cloudslang.base.math

operation:
  name: divide_numbers
  inputs:
    - value1
    - value2
  python_action:
    script: |
      value1 = float(value1)
      value2 = float(value2)
      if value2 == 0:
         res='Cannot divide by zero'
      else:
        res = value1/value2
  outputs:
    - result: ${res}
  results:
     - ILLEGAL: ${res=='Cannot divide by zero'}
     - SUCSESS
