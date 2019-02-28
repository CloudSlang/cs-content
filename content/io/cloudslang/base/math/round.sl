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
#! @description: Rounds a float by converting it to integer and saving it as a string.
#!
#! @input value1: String which represents a float, with or without a percentage.
#!                Example: "58.44%"
#!
#! @output error_message: Error message if error occurred.
#! @output rounded: Rounded value of the float as a string.
#!
#! @result SUCCESS: The value was rounded successfully.
#! @result FAILURE: Input was not in correct format.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.math

operation:
  name: round

  inputs:
    - value1

  python_action:
    script: |
      from java.math import BigDecimal,MathContext
      error_message = ""
      value1 = value1.replace("%", "")
      try:
          rounded = BigDecimal(value1, MathContext.DECIMAL64).toBigInteger()
      except:
          error_message = "input cannot be rounded"

  outputs:
    - error_message
    - rounded

  results:
    - SUCCESS: ${error_message == ""}
    - FAILURE