#   (c) Copyright 2022 Micro Focus, L.P.
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
#! @description: This operation is used to iterate a list of values with the help of GlobalSessionObject in order to
#!               keep track of the last index. It is not recommended to modify the value of the "list" and "separator"
#!               inputs during the iteration process.
#!
#! @input list: The list to iterate through.
#! @input separator: A delimiter separating the list elements. This may be single character, multi-characters or special
#!                   characters.
#!                   Default: ','
#!
#! @output result_string: The current list element (if the response is "has more").
#! @output return_result: "has more" - Another value was found in the list and it has been returned,
#!                        "no more" - The iterator has gone through the entire list. This response is returned once per
#!                        list iteration,
#!                        "failure" - The operation completed unsuccessfully.
#! @output return_code: "0" if has more, "1" if no more values, and "-1" if failed.
#!
#! @result HAS_MORE: Another value was found in the list and it has been returned.
#! @result NO_MORE: The iterator has gone through the entire list. This response is returned once per list iteration.  A
#!                  subsequent call to the List iterator operation restarts the list iteration process.
#! @result FAILURE: The operation completed unsuccessfully.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.lists

operation:
  name: list_iterator

  inputs:
  - list
  - separator:
      default: ','

  java_action:
    gav: 'io.cloudslang.content:cs-lists:0.0.100'
    class_name: 'io.cloudslang.content.actions.ListIteratorAction'
    method_name: 'execute'

  outputs:
  - result_string: ${resultString}
  - return_result: ${result}
  - return_code: ${returnCode}

  results:
  - HAS_MORE: ${returnCode == '0'}
  - NO_MORE: ${returnCode == '1'}
  - FAILURE
