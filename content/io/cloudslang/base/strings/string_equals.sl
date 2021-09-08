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
#! @description: Verifies if two strings are equal.
#!
#! @input first_string: First string to compare.
#!                      Default: ''
#!                      Optional
#! @input second_string: Second string to compare.
#!                       Default: ''
#!                       Optional
#! @input ignore_case: If set to 'true', then the comparison ignores case considerations. The two strings are
#!                     considered equal ignoring case if they are of the same length and corresponding characters in the
#!                     two strings are equal ignoring case. If set to any value other than 'true', then the strings must
#!                     match exactly to be considered equal.
#!                     Default: 'false'
#!                     Optional
#!
#! @result SUCCESS: Strings are equal.
#! @result FAILURE: Strings are not equal.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.strings

decision:
  name: string_equals

  inputs:
    - first_string:
         default: ''
         required: false
    - second_string:
         default: ''
         required: false
    - ignore_case:
         default: 'false'
         required: false

  results:
    - SUCCESS: ${first_string is not None and second_string is not None and ((ignore_case in [True, true, 'True', 'true'] and first_string.lower() == second_string.lower()) or (first_string == second_string))}
    - FAILURE
