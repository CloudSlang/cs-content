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
#! @description: Adds an element to a list of strings
#!
#! @input list: List in which to add the element
#!              Example: '1,2,3,4,5,6'
#! @input element: Element to add to the list
#!                 Example: '7'
#! @input delimiter: The list delimiter
#!
#! @output return_result: The new list or an error message otherwise
#!
#! @result SUCCESS: The new list was retrieved with success
#!!#
########################################################################################################################
namespace: io.cloudslang.base.lists
operation:
  name: add_element
  inputs:
    - list:
        required: false
    - element:
        required: false
    - delimiter:
        default: ','
        required: false
  python_action:
    script: |
      list = list+delimiter+element if list else element
  outputs:
    - return_result: ${list}
  results:
    - SUCCESS