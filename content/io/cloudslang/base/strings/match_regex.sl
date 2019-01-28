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
#! @description: Tests whether a Python regex expression matches a string.
#!
#! @input regex: Python regex expression.
#!               Example: "f\\w*r"
#! @input text: String to match.
#!              Optional
#!
#! @output match_text: Matched text.
#!
#! @result MATCH: A match was found.
#! @result NO_MATCH: No match found.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.strings

operation:
  name: match_regex

  inputs:
    - regex
    - text:
        required: false

  python_action:
    script: |
      import re

      match_text = ""
      m = re.search(regex, text)
      if m is not None:
        match_text = m.group(0)
      res = False
      if match_text:
        res = True

  outputs:
    - match_text

  results:
    - MATCH: ${ res }
    - NO_MATCH
