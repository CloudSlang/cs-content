#   (c) Copyright 2020 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: Adds a key to a map. If the given key already exists in the map then its value will be overwritten.
#!
#! @input map: The map to add a key to.
#!             Example: {'a': 1, 'b': 2, 'c': 3, 'd': 4}
#! @input key: Optional - The key to add.
#!             Valid values: Any string or null value.
#!             Default value: null
#! @input value: Optional - The value to map to the added key.
#!               Valid values: Any number, string, boolean, array, map or a value of None
#!               Default value: null
#!
#! @output return_result: The map with the added key if operation succeeded. Otherwise it will contain the message of the exception.
#! @output return_code: 0 if operation succeeded, -1 otherwise.
#! @output exception: The exception's stack trace if operation failed. Empty otherwise.
#!
#! @result SUCCESS: The key was successfully added to the map.
#! @result FAILURE: An error occurred.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.maps

operation:
  name: add_key

  inputs:
    - map
    - key: 
        default: None
        required: false
    - value: 
        default: None
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-maps:0.0.1-SNAPSHOT-maps-2'
    class_name: io.cloudslang.content.maps.actions.AddKeyAction
    method_name: execute


  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
