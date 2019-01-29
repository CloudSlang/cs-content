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
#! @description: Decodes a Base64-encoded string into a clear string.
#!
#! @input data: String to decode.
#! @input character_set: The character decoding used for the data string. If you do not specify a value for this input,
#!                       it uses the system's default character decoding.
#!                       Examples: UTF-8, ISO-8859-1, US-ASCII or Shift_JIS.
#!                       Default: 'UTF-8'
#!                       Optional
#!
#! @output result: Decoded string.
#!
#! @result SUCCESS: Operation completed successfully.
#! @result FAILURE: Operation failed.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.utils

operation:
  name: base64_decoder

  inputs:
    - data
    - character_set:
        default: 'UTF-8'
        required: false

  python_action:
    script: |
      import base64
      decoded = base64.b64decode(data).decode(character_set)

  outputs:
    - result: ${decoded}

  results:
    - SUCCESS: ${ decoded != None }
    - FAILURE
