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
#! @description: Determines whether two sets are equal.
#!               Sets are represented as strings in the following format: '1 2 3 4'.
#!
#! @input raw_set_1: Optional - First set.
#! @input delimiter_1: Delimiter of first set.
#!                     Default: `,`
#! @input raw_set_2: Optional - second set
#! @input delimiter_2: Delimiter of second set
#!                     Default: `,`
#!
#! @result EQUAL: The sets are equal
#! @result NOT_EQUAL: The sets are not equal
#!!#
########################################################################################################################

namespace: io.cloudslang.base.lists

operation:
  name: set_equals

  inputs:
    - raw_set_1:
        required: false
    - delimiter_1:
        default: ','
    - raw_set_2:
        required: false
    - delimiter_2:
        default: ','

  python_action:
    script: |
      from sets import Set

      def create_set_from_str(set_as_str, delimiter):
        return Set() if (set_as_str == '') else Set(set_as_str.split(delimiter))

      set_1 = create_set_from_str(raw_set_1, delimiter_1)
      set_2 = create_set_from_str(raw_set_2, delimiter_2)

  results:
    - EQUAL: ${set_1 == set_2}
    - NOT_EQUAL
