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
#! @description: Test if two JSONs are equal.
#!
#! @input json_input1: First JSON input.
#!                     Example: '{"k1":"v1", "k2": "v2"}'
#! @input json_input2: Second JSON input.
#!                     Example: '{"k2":"v2", "k1": "v1"}'
#!
#! @output return_result: Parsing was successful or not.
#! @output return_code: "0" if parsing was successful, "-1" otherwise.
#! @output error_message: Error message if there was an error when executing, empty otherwise.
#!
#! @result EQUALS: Two JSONs are equal.
#! @result NOT_EQUALS: Two JSONs are not equal.
#! @result FAILURE: Parsing was unsuccessful (return_code != '0').
#!!#
########################################################################################################################

namespace: io.cloudslang.base.json

operation:
  name: equals

  inputs:
    - json_input1
    - json_input2

  python_action:
    script: |
      try:
        import json, re
        quote1 = None
        quote2 = None

        for c in json_input1:
          if c in ['\'', '\"']:
            quote1 = c
            break
        if quote1 == '\'':
          json_input1 = str(re.sub(r"(?<!\\)(\')",'"', json_input1))
          json_input1 = str(re.sub(r"(\\')",'\'', json_input1))

        for c in json_input2:
          if c in ['\'', '\"']:
            quote2 = c
            break
        if quote2 == '\'':
          json_input2 = str(re.sub(r"(?<!\\)(\')",'"', json_input2))
          json_input2 = str(re.sub(r"(\\')",'\'', json_input2))

        decoded1 = json.loads(json_input1)
        decoded2 = json.loads(json_input2)
        return_code = '0'
        return_result = 'Parsing successful.'
      except Exception as ex:
        return_result = ex
        return_code = '-1'

  outputs:
    - return_result
    - return_code
    - error_message: ${ return_result if return_code == '-1' else '' }

  results:
    - EQUALS: ${ return_code == '0' and decoded1 == decoded2 and quote1 == quote2}
    - NOT_EQUALS: ${ return_code == '0' }
    - FAILURE
