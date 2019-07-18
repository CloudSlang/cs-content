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
#! @description: Returns the length of the list
#!
#! @input list: List which we want to get the length of.
#!              Example: 1,2,3,4,5
#! @input delimiter: List delimiter
#!                   Example: ','
#!                   Default: ','
#!
#! @output response: 'Success' or 'failure'
#! @output return_result: Length of the list or an error message otherwise
#! @output return_code: 0 if success, -1 if failure
#!
#! @result SUCCESS: String list length was returned
#! @result FAILURE: Otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.base.lists

operation:
  name: length

  inputs:
    - list
    - delimiter:
        default: ','

  java_action:
    gav: 'io.cloudslang.content:cs-lists:0.0.7'
    class_name: io.cloudslang.content.actions.ListSizeAction
    method_name: getListSize

  outputs:
    - return_code: ${returnCode}
    - return_result: ${returnResult}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

