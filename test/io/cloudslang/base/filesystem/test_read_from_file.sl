#   (c) Copyright 2014-2017 EntIT Software LLC, a Micro Focus company, L.P.
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
namespace: io.cloudslang.base.filesystem

imports:
  files: io.cloudslang.base.filesystem
  strings: io.cloudslang.base.strings

flow:
  name: test_read_from_file
  inputs:
    - read_file_path
    - expected_read_text
    - expected_message
  workflow:
    - create_file:
        do:
          files.write_to_file:
            - file_path: ${read_file_path}
            - text: 'hello'
        navigate:
          - SUCCESS: test_read_from_file
          - FAILURE: WRITE_FAILURE
    - test_read_from_file:
        do:
          files.read_from_file:
            - file_path: ${read_file_path}
        publish:
          - read_text
          - message
        navigate:
          - SUCCESS: check_read_text
          - FAILURE: FAILURE
    - check_read_text:
        do:
          strings.string_equals:
            - first_string: ${read_text}
            - second_string: ${expected_read_text}
        navigate:
          - SUCCESS: check_error_message
          - FAILURE: delete_created_file_outputs_different
    - check_error_message:
        do:
          strings.string_equals:
            - first_string: ${message}
            - second_string: ${expected_message}
        navigate:
          - SUCCESS: delete_created_file_outputs_checked
          - FAILURE: delete_created_file_outputs_different

    - delete_created_file_outputs_checked:
        do:
          files.delete:
            - source: ${read_file_path}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: DELETE_FAILURE
    - delete_created_file_outputs_different:
        do:
          files.delete:
            - source: ${read_file_path}
        navigate:
          - SUCCESS: DIFFERENT_OUTPUTS
          - FAILURE: DELETE_FAILURE

  results:
    - SUCCESS
    - WRITE_FAILURE
    - DELETE_FAILURE
    - DIFFERENT_OUTPUTS
    - FAILURE
