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
#! @description: Appends text to string.
#!
#! @input origin_string: String.
#!                       Example: 'good'
#! @input text: Optional - Text which need to be appended.
#!              Example: ' morning'
#!
#! @output new_string: String after appending.
#!                     Example: 'good morning'
#!
#! @result SUCCESS: Always.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.strings

operation:
  name: append

  inputs:
    - origin_string:
        required: false
    - text:
        required: false

  python_action:
    script: |
      origin_string+=text

  outputs:
    - new_string: ${origin_string}

  results:
    - SUCCESS
