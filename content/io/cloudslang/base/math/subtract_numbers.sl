#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
#!!
#! @description: Subtracts two numbers as floating point values.
#! @input value1: first value as number or string
#! @input value2: second value as number or string
#! @output result: operation result or reason for failure
#! @output return_code: operation return code ('0' or '-1')
#! @result SUCCESS: The operation completed successfully
#! @result FAILURE: The operation failed
#!!#
########################################################################################################
namespace: io.cloudslang.base.math

operation:
  name: subtract_numbers
  inputs:
    - value1
    - value2
  python_action:
    script: |
      try:
        from java.math import BigDecimal,MathContext
        from java.lang import Exception as JavaException
        value1 = BigDecimal(value1, MathContext.DECIMAL64)
        value2 = BigDecimal(value2, MathContext.DECIMAL64)
        result = value1.subtract(value2, MathContext.DECIMAL64).stripTrailingZeros().toPlainString()
        return_code = '0'
      except JavaException as je:
        return_code = '-1'
        result = "Invalid number format"
      except Exception as e:
        return_code = '-1'
        result = e

  outputs:
     - result
     - return_code

  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE