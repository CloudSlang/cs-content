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
#! @description: This operation sorts a list of strings. If the list contains only numerical strings,
#!               it is sorted in numerical order. Otherwise it is sorted alphabetically.
#!
#! @input list: The list to be sorted.
#!              Example: '4,3,5,2,1'
#! @input delimiter: The list delimiter.
#!                   Example: ','
#!                   For special delimiters, they must be escaped. e.g. '\\.'
#! @input reverse: Optional - A boolean value for sorting the list in reverse order.
#!                 Default: 'false'
#!
#! @output response: 'Success' or 'failure'
#! @output return_result: The sorted list or an error message otherwise.
#! @output return_code: 0 if success, -1 if failure
#!
#! @result SUCCESS: Sorting successful.
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.lists

operation:
  name: sort_list

  inputs:
    - list
    - delimiter
    - reverse:
        required: false
        default: "false"

  java_action:
    gav: 'io.cloudslang.content:cs-lists:0.0.7'
    class_name: io.cloudslang.content.actions.ListSortAction
    method_name: sortList

  outputs:
    - return_code: ${returnCode}
    - return_result: ${returnResult}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
