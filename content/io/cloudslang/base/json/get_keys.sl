#   (c) Copyright 2015-2018 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: Retrieves keys from a JSON object at a given JSON path.
#!
#! @input json_input: JSON from which to retrieve keys
#!                     Examples: {"one":1, "two":2}, {"one":{"a":"a","B":"B"}, "two":"two", "three":[1,2,3.4]}
#! @input json_path: path from which to retrieve key represented as a list of keys and/or indices.
#!                   Passing $ will retrieve top level keys.
#!                   Example: $, $.one, one
#!
#! @output return_result: If any keys were found, list of keys found
#!                        A JSON object is an unordered set of key/value pairs,
#!                        therefore the order of the keys returned is arbitrary.
#! @output return_code: "0" if parsing was successful, "-1" otherwise
#! @output exception: Error message if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: Parsing was successful (return_code == '0')
#! @result FAILURE: Otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.base.json

operation:
  name: get_keys

  inputs:
    - json_input
    - jsonInput:
        default: ${get('json_input', '')}
        required: false
        private: true

    - json_path:
        required: false
    - jsonPath:
        default: ${get('json_path', '$')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-json:0.0.9-SNAPSHOT'
    class_name: 'io.cloudslang.content.json.actions.GetKeys'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE
