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
#! @description: Compare the first list with the second list to see if they are identical or not.
#! @input list_1: first list - ex. [123, 'xyz']
#! @input list_2: second list - ex. [456, 'abc']
#! @output result: if "true" first list is identical with the second list
#! @result SUCCESS: list are identical
#! @result FAILURE: list are not identical
#!!#
####################################################

namespace: io.cloudslang.base.lists

operation:
  name: test_compare_lists
  inputs:
    - list_1
    - list_2
  python_action:
    script: |
      result = list_1 == list_2
  results:
    - SUCCESS: ${str(result)}
    - FAILURE
