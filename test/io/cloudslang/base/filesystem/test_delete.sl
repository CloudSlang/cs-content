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
  name: test_delete

  inputs:
    - delete_source

  workflow:
    - create_file:
        do:
          files.write_to_file:
            - file_path: ${delete_source}
            - text: "hello"
        navigate:
          - SUCCESS: test_delete_operation
          - FAILURE: WRITEFAILURE
    - test_delete_operation:
        do:
          files.delete:
            - source: ${delete_source}
        publish:
          - message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: DELETEFAILURE

  outputs:
    - message
  results:
    - SUCCESS
    - WRITEFAILURE
    - DELETEFAILURE
