#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
#!!
#! @description: Compares two numbers as floating point values.
#! @input value1: first value as number or string
#! @input value2: second value as number or string
#! @result GREATER_THAN: value1 is greater than value2
#! @result EQUALS: value1 is equal to value2
#! @result LESS_THAN: value1 is less than value2
#!!#
########################################################################################################

namespace: io.cloudslang.base.math

decision:
  name: compare_numbers
  inputs:
    - value1
    - value2
  results:
    - GREATER_THAN: ${ float(value1) > float(value2) }
    - EQUALS: ${ float(value1) == float(value2) }
    - LESS_THAN
