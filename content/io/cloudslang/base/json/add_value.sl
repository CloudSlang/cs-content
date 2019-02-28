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
#! @description: Adds or replaces a value to the given JSON at the keys or indices represented by the json_path.
#!               If the last key in the path does not exist, the key is added as well.
#!
#! @input json_input: JSON data input.
#!                    Example: '{"k1": {"k2": ["v1", "v2"]}}'
#! @input json_path: Path at which to add value represented as a list of keys and/or indices.
#!                   Example: ["k1","k2",1]
#! @input value: Value to associate with key.
#!               Example: "v3"
#!
#! @output return_result: JSON with key:value added.
#! @output return_code: "0" if parsing was successful, "-1" otherwise.
#! @output error_message: error message if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The operation executed successfully and the 'return_code' is 0.
#! @result FAILURE: The operation could not be executed or the value of the 'return_code' is different than 0.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.json

operation:
  name: add_value

  inputs:
    - json_input
    - json_path
    - value:
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
        quote_value = None
        json_pa = json_path.split(",")
        if len(json_pa) > 0:
          for c in json_input:
            if c in ['\'', '\"']:
              quote = c
              break
          if quote == '\'':
            json_input = str(re.sub(r"(?<!\\)(\')",'"', json_input))
            json_input = str(re.sub(r"(\\')",'\'', json_input))
            for c in value:
              if c in ['\'', '\"']:
                quote_value = c
                break
            if quote_value == '\'':
              value = str(re.sub(r"(?<!\\)(\')",'"', value))
              value = str(re.sub(r"(\\')",'\'', value))

          try:
            decoded_value = json.loads(value)
          except Exception as ex:
            decoded_value = value

          decoded = json.loads(json_input)
          temp = decoded
          for key in json_pa[:-1]:
            if representsInt(key):
              key = int(key)
            temp = temp[key]
          if representsInt(json_pa[-1]):
            json_pa[-1] = int(json_pa[-1])
            if json_pa[-1] >= len(temp):
              temp.extend([None]*(json_pa[-1]-len(temp)+1))
          temp[json_pa[-1]] = decoded_value
        elif (json_pa == [] and decoded_value == '' and json_input == '{}'):
          decoded = {}
        else:
          decoded = decoded_value
        encoded = json.dumps(decoded)
        if quote == '\'':
          encoded = encoded.replace('\'','\\\'').replace('\"','\'')
        return_code = '0'
      except Exception as ex:
        error_message = ex
        return_code = '-1'

  outputs:
    - return_result: ${ str(encoded) if return_code == '0' else ''}
    - return_code
    - error_message: ${ str(error_message) if return_code == '-1' else ''}

  results:
    - SUCCESS: ${ return_code == '0' }
    - FAILURE
