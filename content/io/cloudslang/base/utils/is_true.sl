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
#! @description: Checks if boolean is true or false. Used for flow control.
#!
#! @input bool_value: Boolean value to check.
#!
#! @output return_code: '0' if success, '-1' otherwise.
#!
#! @result TRUE: bool_value is true.
#! @result FALSE: bool_value is false.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.utils

operation:
  name: is_true

  inputs:
    - bool_value:
        required: true
    - boolValue:
        default: ${get('bool_value', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-utilities:0.1.15-SNAPSHOT'
    class_name: io.cloudslang.content.utilities.actions.IsTrue
    method_name: execute

  outputs:
    - return_code: ${get('returnCode', '')}

  results:
    - 'TRUE': ${ returnCode == '0'}
    - 'FALSE'
