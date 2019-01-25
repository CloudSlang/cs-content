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
  name: test_create_folder_already_existent

  inputs:
    - folder_name

  workflow:
    - create_folder:
        do:
          files.create_folder:
            - folder_name
        navigate:
          - SUCCESS: test_create_folder_already_existent
          - FAILURE: FOLDERFAILURE
    - test_create_folder_already_existent:
        do:
          files.create_folder:
            - folder_name
        navigate:
          - SUCCESS: delete_folder_from_success
          - FAILURE: delete_folder_from_failure
    - delete_folder_from_success:
        do:
          files.delete:
            - source: ${folder_name}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: DELETEFAILURE
    - delete_folder_from_failure:
        do:
          files.delete:
            - source: ${folder_name}
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: DELETEFAILURE
  results:
    - SUCCESS
    - FOLDERFAILURE
    - DELETEFAILURE
    - FAILURE
