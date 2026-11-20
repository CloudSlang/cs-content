#   (c) Copyright 2014-2017 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description:  This operation adds a new property into a JSON object, with a value of type string.
#!                In case that a new property with the same name as an existing one is added, the old property's value
#!                will be overwritten.
#!
#! @input json_object: String representation of a JSON object.
#! @input new_property_name:  The name of the new property to add to the JSON object.
#!                            Optional
#! @input new_property_value: The value for the new property. This is interpreted as a string,
#!                            no matter what the contents of the input.
#!                            Optional
#!
#! @output return_result: That will contain the JSON with the new property/value added.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output exception: The exception message if the operation goes to failure.
#!
#! @result SUCCESS: Operation executed successfully.
#! @result FAILURE: An error occurred while trying to complete the operation.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.json

operation:
  name: add_property_to_object

  inputs:
    - json_object
    - jsonObject:
        default: ${json_object}
        private: true
    - new_property_name:
        required: false
    - newPropertyName:
        default: ${get('new_property_name', '')}
        required: false
        private: true
    - new_property_value:
        required: false
    - newPropertyValue:
        default: ${get('new_property_value', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-json:0.0.9-SNAPSHOT'
    class_name: io.cloudslang.content.json.actions.AddPropertyToObject
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get(exception, '')}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
