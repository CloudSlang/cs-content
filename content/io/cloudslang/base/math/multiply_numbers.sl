#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
#!!
#! @description: Multiply two numbers as floating point values.
#! @input value1: first value as number or string
#! @input value2: second value as number or string
#! @output result: value1 multiplied by value2
#! @result SUCCESS: always
#!!#
########################################################################################################
namespace: io.cloudslang.base.math

operation:
  name: multiply_numbers
  inputs:
    - value1
    - value2
  python_action:
    script: |
      value1 = float(value1)
      value2 = float(value2)
      if bool(value1 == 0 or value2 == 0):
        result = abs(value1 * value2)
      else:
        result = value1 * value2
  outputs:
     - result