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

flow:
  name: test_create_folder

  inputs:
    - folder_name

  workflow:
    - test_create_folder_operation:
        do:
          files.create_folder:
            - folder_name
        navigate:
          - SUCCESS: delete_copied_folder
          - FAILURE: FOLDERFAILURE
    - delete_copied_folder:
        do:
          files.delete:
            - source: ${folder_name}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: DELETEFAILURE
  results:
    - SUCCESS
    - FOLDERFAILURE
    - DELETEFAILURE
