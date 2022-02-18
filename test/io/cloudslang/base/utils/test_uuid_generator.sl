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
namespace: io.cloudslang.base.utils

imports:
  utils: io.cloudslang.base.utils
  strings: io.cloudslang.base.strings

flow:
  name: test_uuid_generator

  workflow:
    - execute_uuid_generator:
        do:
          utils.uuid_generator:
        publish:
          - new_uuid
        navigate:
          - SUCCESS: verify_output_is_not_empty
    - verify_output_is_not_empty:
        do:
          strings.string_equals:
            - first_string: ''
            - second_string: ${ new_uuid }
        navigate:
          - SUCCESS: OUTPUT_IS_EMPTY
          - FAILURE: SUCCESS

  results:
    - SUCCESS
    - OUTPUT_IS_EMPTY
