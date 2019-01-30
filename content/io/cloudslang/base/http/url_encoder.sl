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
#! @description: Encodes data for usage in a url.
#!
#! @input data: URL string to encode.
#! @input safe: Optional - Characters that should not be encoded.
#! @input quote_plus: Optional - If true, will replace spaces with plus signs.
#!                    Default: 'false'
#!
#! @output result: Encoded URL string.
#!
#! @result SUCCESS: URL was encoded successfully.
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.http

operation:
  name: url_encoder

  inputs:
    - data
    - safe:
        required: false
        default: ''
    - quote_plus:
        required: false
        default: 'false'

  python_action:
    script: |
      import urllib
      if quote_plus.lower() == 'true':
        encoded = urllib.quote_plus(data, safe)
      else:
        encoded = urllib.quote(data, safe)

  outputs:
    - result: ${encoded}

  results:
    - SUCCESS: ${ encoded != None }
    - FAILURE
