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
#! @description: Encodes a clear string into a Base64-encoded string.
#!
#! @input data: String to encode.
#! @input character_set: The character encoding used for the data string. If you do not specify a value for this input,
#!                       it uses the system's default character encoding.
#!                       Examples: 'UTF-8', 'ISO-8859-1', 'US-ASCII' or 'Shift_JIS'
#!                       Default: 'UTF-8'
#!                       Optional
#!
#! @output result: Encoded string.
#!
#! @result SUCCESS: Operation completed successfully.
#! @result FAILURE: Operation failed.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.utils

operation:
  name: base64_encoder

  inputs:
    - data
    - character_set:
        default: 'UTF-8'
        required: false

  python_action:
    script: |
      import base64
      encoded = base64.b64encode(data).encode(character_set)

  outputs:
    - result: ${encoded}

  results:
    - SUCCESS: ${ encoded != None }
    - FAILURE
