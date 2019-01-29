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
#! @description: Replaces a string in another string by a Python regex expression.
#!
#! @input regex: Python regex expression.
#!               Example: "f\\w*r"
#! @input text: Optional - String to replace in.
#! @input replacement: Optional - Replacement string.
#!
#! @output result_text: String after replacement.
#!
#! @result SUCCESS: Always.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.strings

operation:
  name: regex_replace

  inputs:
    - regex
    - text:
        required: false
    - replacement:
        required: false

  python_action:
    script: |
      import re
      result_text = ""
      result_text = re.sub(regex, replacement, text)

  outputs:
    - result_text

  results:
    - SUCCESS
