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
#! @description: Remove an element from a list of strings.
#!
#! @input list: The list to remove from.
#!              Example: '1,2,3,4,5'
#! @input element: The index of the element to remove from the list.
#!                 Example: '1'
#! @input delimiter: The list delimiter.
#!                   Example: ','
#!
#! @output response: Index of the element to remove
#! @output return_result: The new list or an error message otherwise
#! @output return_code: 0 if success, -1 if failure
#!
#! @result SUCCESS: Element removed with success
#! @result FAILURE: Otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.base.lists

operation:
   name: remove_by_index

   inputs:
     - list
     - element
     - delimiter

   java_action:
     gav: 'io.cloudslang.content:cs-lists:0.0.7'
     class_name: io.cloudslang.content.actions.ListRemoverAction
     method_name: removeElement

   outputs:
     - return_result: ${returnResult}
     - return_code: ${returnCode}

   results:
     - SUCCESS: ${returnCode == '0'}
     - FAILURE
