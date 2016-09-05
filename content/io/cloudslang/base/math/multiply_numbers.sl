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
      from java.math import BigDecimal,MathContext
      value1 = BigDecimal(value1, MathContext.DECIMAL64)
      value2 = BigDecimal(value2, MathContext.DECIMAL64)
      result = value1.multiply(value2, MathContext.DECIMAL64).stripTrailingZeros().toPlainString()
  outputs:
     - result: ${ str(result) }