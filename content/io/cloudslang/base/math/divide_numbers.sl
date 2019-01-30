#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: Divides two numbers as floating point values.
#!
#! @input value1: First value as number or string.
#! @input value2: Second value as number or string.
#!
#! @output result: Value1 divided by value2.
#!
#! @result ILLEGAL: Value2 == 0.
#! @result SUCCESS: Values divided.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.math

operation:
  name: divide_numbers

  inputs:
    - value1
    - value2

  python_action:
    script: |
      from java.math import BigDecimal,MathContext
      value1 = BigDecimal(value1, MathContext.DECIMAL64)
      value2 = BigDecimal(value2, MathContext.DECIMAL64).stripTrailingZeros()
      if (value2.equals(BigDecimal.ZERO)):
        result = 'Cannot divide by zero'
      else:
        result = value1.divide(value2, MathContext.DECIMAL64).stripTrailingZeros().toPlainString()

  outputs:
    - result: ${ str(result) }

  results:
     - ILLEGAL: ${result == 'Cannot divide by zero'}
     - SUCCESS