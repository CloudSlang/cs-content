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
#! @description: Parses the given JSON input to retrieve the corresponding value addressed by the json_path input.
#!
#! @input json_input: JSON data input
#!                    Example 1: '{"k1": {"k2": ["v1", "v2"]}}'
#!                    Example 2: '{"token":"0123456789"}'
#! @input json_path: path from which to retrieve value represented as a list of keys and/or indices.
#!                   Passing an empty list ([]) will retrieve the entire json_input.
#!                   Example 1: ["k1", "k2", 1]
#!                   Example 2 (get the value of the token from json_input from Example 2 above): token
#!
#! @output return_result: The corresponding value of the key referred to by json_path
#! @output return_code: "0" if parsing was successful, "-1" otherwise
#! @output error_message: Error message if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: Parsing was successful (return_code == '0')
#! @result FAILURE: Otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.base.json

operation:
  name: get_value

  inputs:
    - json_input
    - json_path:
        required: false

  python_action:
    script: |
      def representsInt(s):
          try:
              int(s)
              return True
          except ValueError:
              return False
      try:
        import json, re
        quote = None
        for c in json_input:
          if c in ['\'', '\"']:
            quote = c
            break
        if quote == '\'':
          json_input = str(re.sub(r"(?<!\\)(\')",'"', json_input))
          json_input = str(re.sub(r"(\\')",'\'', json_input))
        decoded = json.loads(json_input)
        for key in json_path.split(","):
          if key in ["", ''] and key not in decoded:
            pass
          else:
            if representsInt(key):
              key = int(key)
            decoded = decoded[key]
        if type(decoded) in [dict, list]:
          encoded = json.dumps(decoded, ensure_ascii=False)
          if quote == '\'':
            encoded = encoded.replace('\'','\\\'').replace('\"','\'')
        elif decoded is None:
          encoded = 'null'
        else:
          encoded = str(decoded)
        return_code = '0'
      except Exception as ex:
        error_message = ex
        return_code = '-1'

  outputs:
    - return_result: ${ encoded if return_code == '0' else '' }
    - return_code
    - error_message: ${ str(error_message) if return_code == '-1' else '' }

  results:
    - SUCCESS: ${ return_code == '0' }
    - FAILURE
