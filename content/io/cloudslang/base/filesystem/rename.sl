#   (c) Copyright 2020 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: Renames a file or a directory.
#!
#! @input source:  Absolute path to the file or directory that will be renamed.
#! @input new_name: The new name for the file or directory. The value of this input should contain only the
#!                  name and extension of the file and not the full path or parent folders names.
#!                  Example: "file.txt".
#! @input overwrite:  Optional - Optional. If set to "false" the operation will fail if new_name exists.
#!                    Valid values: 'true', 'false'.
#!                    Default value: 'false'.
#!
#! @output return_result: A message describing the success or failure of the operation.
#! @output return_code: 0 if operation succeeded, -1 otherwise.
#! @output exception: The exception's stack trace if operation failed. Empty otherwise.
#! @output renamed_path: The absolute path of the renamed file if operation succeeded. Empty otherwise.
#!
#! @result SUCCESS: Rename operation succeeded.
#! @result FAILURE: The file or directory could not be renamed.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.filesystem

operation:
  name: rename

  inputs:
    - source
    - new_name
    - newName:
        default: ${get('new_name', '')}
        private: true
    - overwrite:
        default: 'false'
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-filesystem:1.1.1-SNAPSHOT'
    class_name: io.cloudslang.content.filesystem.actions.RenameAction
    method_name: execute

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception
    - renamed_path: ${get('renamedPath', '')}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
