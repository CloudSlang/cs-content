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
########################################################################################################################
#!!
#! @description: Removes text from a string.
#!
#! @input origin_string: Optional - Original string.
#!                       Example: "SPAMgood morning"
#! @input text: Optional - Text to be removed.
#!              Example: "SPAM"
#!
#! @output new_string: String after removing.
#!                     Example: "good morning"
#!
#! @result SUCCESS: Text removed from string successfully.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.strings

operation:
  name: remove

  inputs:
    - origin_string:
        required: false
    - text:
        required: false

  python_action:
    script: |
      if text in origin_string:
         new_string = origin_string.replace(text, "")
      else:
         new_string = origin_string

  outputs:
    - new_string

  results:
    - SUCCESS
