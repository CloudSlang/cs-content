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
#! @description: Compare the first list with the second list to see if they are identical.
#!
#! @input list_1: First list.
#!                Example: [123, 'xyz']
#! @input list_2: Second list.
#!                Example: [456, 'abc']
#!
#! @output result: True if list_1 is identical to list_2.
#!
#! @result SUCCESS: Lists are identical.
#! @result FAILURE: Lists are not identical.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.lists

decision:
  name: compare_lists

  inputs:
    - list_1
    - list_2

  outputs:
    - result: ${ str(list_1 == list_2) }

  results:
    - SUCCESS: ${list_1 == list_2}
    - FAILURE
