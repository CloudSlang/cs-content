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
#! @description: Filters input text by string/regex, removing all lines that do not contain a match to the filter.
#!
#! @input text: Multiline text to be filtered.
#! @input filter: String or Python regex expression.
#!                Example: "f\\w*r"
#!
#! @output filter_result: Filtered text.
#!
#! @result SUCCESS: Always.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.strings

operation:
  name: filter_lines

  inputs:
    - text
    - filter

  python_action:
    script: |
      import re
      res = re.findall('.*' + filter + '.*', text)
      filter_result = '\n'.join(res)

  outputs:
    - filter_result

  results:
    - SUCCESS
