#   (c) Copyright 2018 Micro Focus, L.P.
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
#! @description: Executes a Shell command(s) on the remote machine using the SSH protocol.
#!
#! @input command: Command to run.
#! @input cwd: Current working directory.
#!             Optional
#!
#! @output return_result: The output of the command
#! @output return_code: The returnCode of the operation: 0 for success, -1 for failure.
#! @output error_message: An error has occurred while executing the command.
#!
#! @result SUCCESS: The operation completed successfully.
#! @result FAILURE: An error occurred during execution.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.cmd

operation:
  name: run_command

  inputs:
  - command
  - cwd:
      required: false

  java_action:
    gav: 'io.cloudslang.content:cs-rft:0.0.6-SNAPSHOT'
    class_name: 'io.cloudslang.content.rft.actions.RunCommandAction'
    method_name: 'execute'

  outputs:
  - return_result: ${get('returnResult', '')}
  - return_code: ${get('returnCode', '')}
  - error_message: ${get('exception', '')}

  results:
  - SUCCESS: ${returnCode=='0'}
  - FAILURE
