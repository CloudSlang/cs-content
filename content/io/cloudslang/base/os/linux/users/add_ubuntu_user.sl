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
#! @description: Perform a SSH command to add a specified user named <user_name> on machines that are running Ubuntu based linux
#!
#! @input host: hostname or IP address
#! @input root_password: The root password
#! @input user_name: The name of the user to verify if exist
#! @input user_password: The password to be set for the <user_name>
#! @input group_name: Optional - the group name where the <user_name> will be added - Default: ''
#! @input create_home: Optional - if True then a <user_name> folder with be created in <home_path> path
#!                     if False then no folder will be created - Default: True
#! @input home_path: Optional - the path of the home folder - Default: '/home'
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of successful request, null otherwise
#! @output return_code: '0' if success, '-1' otherwise
#! @output exception: contains the stack trace in case of an exception
#! @output command_return_code: The return code of the remote command corresponding to the SSH channel. The return code is
#!                              only available for certain types of channels, and only after the channel was closed
#!                              (more exactly, just before the channel is closed).
#!                              Examples: 0 for a successful command, -1 if the command was not yet terminated (or this
#!                              channel type has no command), 126 if the command cannot execute.
#!
#! @result SUCCESS: add user SSH command was successfully executed
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.base.os.linux.users

imports:
  ssh: io.cloudslang.base.ssh
  utils: io.cloudslang.base.utils

flow:
  name: add_ubuntu_user

  inputs:
    - host
    - root_password:
        sensitive: true
    - user_name
    - user_password:
        default: ''
        required: false
        sensitive: true
    - group_name:
        default: ''
        required: false
    - create_home:
        default: "True"
        required: false
    - home_path:
        default: '/home'
        required: false
    - worker_group:
        required: false

  workflow:
    - add_user:
        worker_group: ${get('worker_group', 'RAS_Operator_Path')}
        do:
          ssh.ssh_flow:
            - host
            - port: '22'
            - username: 'root'
            - password: ${root_password}
            - group_name_string: ${'' if group_name == '' else ' --ingroup ' + group_name}
            - create_home_string: ${'' if create_home.lower() in [True, true, 'True', 'true'] else ' --no-create-home '}
            - home_path_string: >
                ${'/home' if (home_path == '' and create_home.lower() in [True, true, 'True', 'true']) else ' --home ' +
                home_path}
            - command: >
                ${'adduser ' + user_name + ' --disabled-password --gecos \"\"' + create_home_string +
                group_name_string + home_path_string + ' && echo \"' + user_name + ':' + user_password +
                '\" | chpasswd' if user_password != '' else ''}
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - exception
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
    - exception
    - command_return_code

  results:
    - SUCCESS
    - FAILURE
