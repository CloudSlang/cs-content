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
#! @description: This operation is used to retrieve a value from a list.
#!               When the index of an element from a list is known,
#!               this operation can be used to get the element.
#!
#! @input list: List from which we want to get the element.
#!              Example: '1,2,3,4,5,6'
#! @input delimiter: The list delimiter.
#! @input index: Index of the value (starting with 0) to retrieve from the list.
#!
#! @output response: 'success' or 'failure'
#! @output return_code: 0 if success, -1 if failure
#! @output return_result: Returns the value found at the specified index in the list, if the value specified for
#!                        the index input is (starting with 0) positive and less than the size of the list.
#!                        Otherwise, it returns the value specified for index.
#!
#! @result SUCCESS: Value retrieved with success
#! @result FAILURE: Otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.base.lists

operation:
   name: get_by_index

   inputs:
     - list
     - delimiter
     - index

   java_action:
     gav: 'io.cloudslang.content:cs-lists:0.0.7'
     class_name: io.cloudslang.content.actions.ListItemGrabberAction
     method_name: grabItemFromList

   outputs:
     - return_code: ${returnCode}
     - return_result: ${returnResult}

   results:
     - SUCCESS: ${returnCode == '0'}
     - FAILURE
