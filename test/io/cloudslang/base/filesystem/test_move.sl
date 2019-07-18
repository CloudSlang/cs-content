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
namespace: io.cloudslang.base.filesystem

imports:
  files: io.cloudslang.base.filesystem

flow:
  name: test_move

  inputs:
    - move_source
    - move_destination

  workflow:
    - create_file_to_be_moved:
        do:
          files.write_to_file:
            - file_path: ${move_source}
            - text: "text-to-be-copied"
        navigate:
          - SUCCESS: test_move_operation
          - FAILURE: create_folder_to_be_moved
    - create_folder_to_be_moved:
        do:
          files.create_folder:
            - folder_name: ${move_source}
        navigate:
          - SUCCESS: test_move_operation
          - FAILURE: CREATEFAILURE
    - test_move_operation:
        do:
          files.move:
            - source: ${move_source}
            - destination: ${move_destination}
        navigate:
          - SUCCESS: delete_moved_file
          - FAILURE: delete_moved_file_after_move_failure
    - delete_moved_file_after_move_failure:
        do:
          files.delete:
            - source: ${move_source}
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: DELETEFAILURE
    - delete_moved_file:
        do:
          files.delete:
            - source: ${move_destination}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: DELETEFAILURE
  results:
    - SUCCESS
    - CREATEFAILURE
    - DELETEFAILURE
    - FAILURE
