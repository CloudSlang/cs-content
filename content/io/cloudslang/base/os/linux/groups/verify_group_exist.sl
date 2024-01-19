#   Copyright 2024 Open Text
#   This program and the accompanying materials
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
#! @description: Perform a SSH command to verify if a specified <group_name> exist
#!
#! @input host: hostname or IP address
#! @input root_password: The root password
#! @input group_name: The name of the group to verify if exist
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of unsuccessful request, null otherwise
#! @output return_code: '0' if success, '-1' otherwise
#! @output command_return_code: The return code of the remote command corresponding to the SSH channel. The return code is
#!                              only available for certain types of channels, and only after the channel was closed
#!                              (more exactly, just before the channel is closed).
#!                              Examples: 0 for a successful command, -1 if the command was not yet terminated (or this
#!                              channel type has no command), 126 if the command cannot execute.
#! @output message: returns 'The "<group_name>" group exist.' if the group exist or 'The "<group_name>" group does not exist.'
#!                  otherwise
#!
#! @result SUCCESS: verify group exist SSH command was successfully executed
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.base.os.linux.groups

imports:
  ssh: io.cloudslang.base.ssh
  utils: io.cloudslang.base.utils

flow:
  name: verify_group_exist

  inputs:
    - host
    - root_password:
        sensitive: true
    - group_name
    - worker_group:
        required: false

  workflow:
    - verify_if_group_exist:
        worker_group: ${get('worker_group', 'RAS_Operator_Path')}
        do:
          ssh.ssh_flow:
            - host
            - port: '22'
            - username: 'root'
            - password: ${root_password}
            - command: >
                ${'cat /etc/group | grep ' + group_name +  ' | cut -d \":\" -f1 | grep ' + group_name}
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code

    - evaluate_result:
        worker_group: ${get('worker_group', 'RAS_Operator_Path')}
        do:
          utils.is_true:
            - bool_value: ${str(return_code == '0')}
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': FAILURE

  outputs:
    - return_result
    - standard_err
    - standard_out
    - return_code
    - command_return_code
    - message: >
        ${'The \"' + group_name + '\" group exist.' if (command_return_code == '0' and standard_out.strip() == group_name)
        else 'The \"' + group_name + '\" group does not exist.'}

  results:
    - SUCCESS
    - FAILURE
