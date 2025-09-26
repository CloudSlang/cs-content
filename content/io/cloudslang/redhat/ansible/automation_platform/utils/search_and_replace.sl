#   Copyright 2025 Open Text
#   This program and the accompanying materials
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
#! @description: Replaces a substring within a string.
#!
#! @input origin_string: Optional - Original string.
#! @input text_to_replace: Text to replace.
#! @input replace_with: Optional - Text to replace with.
#!
#! @output replaced_string: String with the text replaced.
#! @output error_message: Substring not found.
#!
#! @result SUCCESS: Parsing successful.
#!!#
########################################################################################################################

namespace: io.cloudslang.redhat.ansible.automation_platform.utils
operation:
  name: search_and_replace
  inputs:
    - origin_string:
        required: false
    - text_to_replace
    - replace_with:
        required: false
  python_action:
    script: "try:\n  error_message = \"\"\n  if text_to_replace in origin_string:\n    replaced_string = origin_string.replace(text_to_replace, replace_with)\n  elif origin_string:\n      replaced_string=origin_string\n  else:\n    error_message = \"string not found\" \nexcept Exception as e:\n  error_message = e"
  outputs:
    - replaced_string
    - error_message: '${ str(error_message) }'
  results:
    - SUCCESS: '${error_message == ""}'
    - FAILURE

