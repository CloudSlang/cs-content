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
#! @description: This operation checks to see if a list contains every element from another list.
#!
#! @input container: The containing list.
#!                   Example: 'Luke,Vader,Kenobi'
#! @input sublist: The contained list.
#!                 Example: 'Kenobi'
#! @input delimiter: A delimiter separating elements in the two lists.
#!                   Default: ','
#! @input ignore_case: If set to 'true' then the compare is not case sensitive.
#!                     Default: 'true'
#!
#! @output response: 'True' if found, 'false' if not found.
#! @output return_result: Empty if sublist found in container.
#!                        If the sublist was not found in the container,
#!                        it will show the elements that were not found.
#! @output return_code: 0 if found, -1 if not found
#! @output exception: Something went wrong.
#!
#! @result SUCCESS: Sublist was found in container.
#! @result FAILURE: Sublist was not found in container.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.lists

operation:
  name: contains

  inputs:
    - container
    - sublist
    - delimiter:
        default: ','
    - ignore_case:
        required: false
    - ignoreCase:
        default: ${get("ignore_case", "true")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-lists:0.0.7'
    class_name: io.cloudslang.content.actions.ListContainsAction
    method_name: containsElement

  outputs:
    - response
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
