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
#! @description: Removes an object from a JSON array, specifying the JSON object to remove
#!               from array or the position from which to remove the existing object.
#!
#! @input json_array: JSON array to remove object from
#!                    Example: '[{"a": "0"}, {"b": "1"}, {"c": "2"}]'
#! @input json_object: Optional - JSON object to remove from array
#!                     Example: '{"b": "1"}'
#! @input index: Optional - Position from which to remove the existing object
#!               Example: 1
#!
#! @output return_result: JSON array with object removed
#! @output return_code: "0" if removing was successful, "-1" otherwise
#! @output error_message: Error message if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: Removing was successful (return_code == '0')
#! @result FAILURE: Otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.base.json

operation:
  name: remove_object_from_json_array

  inputs:
    - json_array
    - json_object:
        required: false
        default: null
    - index:
        required: false
        default: null

  python_action:
    script: |
      try:
        import json, re
        array_quote = None
        object_quote = None
        if (json_object is not None and index is not None) or (json_object is None and index is None):
         return_code = '-1'
         return_result= "Inputs are not valid"
        else:
          for c in json_array:
            if c in ['\'', '\"']:
              array_quote = c
              break
          if array_quote == '\'':
              json_array = str(re.sub(r"(?<!\\)(\')",'"', json_array))
              json_array = str(re.sub(r"(\\')",'\'', json_array))
          decoded_json_array = json.loads(json_array)

          if json_object is not None and index is None:
            for c in json_object:
              if c in ['\'', '\"']:
                object_quote = c
                break
            if object_quote == '\'':
              json_object = str(re.sub(r"(?<!\\)(\')",'"', json_object))
              json_object = str(re.sub(r"(\\')",'\'', json_object))
            decoded_json_object = json.loads(json_object)
            decoded_json_array.remove(decoded_json_object)
          if json_object is None and index is not None:
            index=int(index)
            decoded_json_array.pop(index)
          encoded_json_array = json.dumps(decoded_json_array)
          if array_quote == '\'':
            encoded_json_array = encoded_json_array.replace('\'','\\\'').replace('\"','\'')
          return_code = '0'
      except ValueError:
        return_result = "Object not found"
        return_code = '-1'
      except Exception as ex:
        error_message = ex
        return_code = '-1'

  outputs:
    - return_result: ${ str(encoded_json_array) if return_code == '0' else return_result }
    - return_code
    - error_message: ${ str(error_message) if return_code == '-1' else '' }

  results:
    - SUCCESS: ${ return_code == '0' }
    - FAILURE
