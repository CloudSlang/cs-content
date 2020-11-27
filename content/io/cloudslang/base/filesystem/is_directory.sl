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
#! @description: Checks to see if the file/folder a path points to is a directory.
#!
#! @input source: Path of source file or folder to be checked.
#!
#! @output return_result: A success message if source is a directory. Otherwise, it will contain the exception message.
#! @output return_code: 0 if source is a directory, -1 otherwise.
#! @output exception: The exception"s stack trace if source is not a directory or operation failed. Empty otherwise.
#!
#! @result SUCCESS: Source is a directory.
#! @result FAILURE: Source is not a directory or does not exist.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.filesystem

operation:
  name: is_directory

  inputs:
    - source

  java_action:
    gav: 'io.cloudslang.content:cs-filesystem:0.0.1-RC2'
    class_name: io.cloudslang.content.filesystem.actions.IsDirectoryAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${ returnCode == '0'}
    - FAILURE