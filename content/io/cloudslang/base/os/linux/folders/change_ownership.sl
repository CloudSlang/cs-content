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
#! @description: Perform a SSH command to change ownership of the specified folder indicated by <folder_path> to a user
#!               indicated by <user_name> and with group indicated by <group_name> recursively or not
#!
#! @input host: hostname or IP address
#! @input root_password: The root password
#! @input folder_path: The absolute path of the targeted folder
#! @input user_name: The name of the user that acquire the ownership
#! @input group_name: Optional - the name of the group that acquire the ownership; if not specified the group will be
#!                    the default group for that user - Default: ''
#! @input recursively: Optional - if True the ownership change will be applied recursively to the whole content of the
#!                     targeted folder; if False the ownership change will be applied ony to the folder itself
#!                     Default: True
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
#!
#! @result SUCCESS: SSH access was successful
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.base.os.linux.folders

imports:
  ssh: io.cloudslang.base.ssh
  utils: io.cloudslang.base.utils

flow:
  name: change_ownership

  inputs:
    - host
    - root_password:
        sensitive: true
    - folder_path
    - user_name
    - group_name:
        default: ''
        required: false
    - recursively:
        default: "True"
        required: false
    - worker_group:
        required: false

  workflow:
    - change_ownership:
        worker_group: ${get('worker_group', 'RAS_Operator_Path')}
        do:
          ssh.ssh_flow:
            - host
            - port: '22'
            - username: 'root'
            - password: ${root_password}
            - group_name_string: ${'' if group_name == '' else group_name}
            - recursively_string: ${'-R ' if recursively.lower() in [True, true, 'True', 'true'] else ''}
            - command: >
                ${'chown ' + recursively_string + user_name + ':' + group_name + ' ' + folder_path}
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
            - bool_value: ${str(return_code == '0' and command_return_code == '0')}
        navigate:
            - 'TRUE': SUCCESS
            - 'FALSE': FAILURE

  outputs:
    - return_result
    - standard_err
    - standard_out
    - return_code
    - command_return_code

  results:
    - SUCCESS
    - FAILURE
