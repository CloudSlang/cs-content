#   Copyright 2023 Open Text
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
#! @description: Restarts a remote Linux service using SSH.
#!
#! @input host: hostname or IP address
#! @input port: Optional - port number for running the command - Default: '22'
#! @input username: username to connect as
#! @input password: Optional - password of user
#! @input service_name: Linux service name to be restarted
#! @input sudo_user: Optional - whether to execute the command on behalf of username with sudo. Default: false
#! @input private_key_file: Optional - absolute path to the private key file
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of successful request, null otherwise
#! @output exception: contains the stack trace in case of an exception
#! @output command_return_code: The return code of the remote command corresponding to the SSH channel. The return code is
#!                              only available for certain types of channels, and only after the channel was closed
#!                              (more exactly, just before the channel is closed).
#!                              Examples: '0' for a successful command, '-1' if the command was not yet terminated (or this
#!                              channel type has no command), '126' if the command cannot execute.
#! @output return_code: return code of the command
#!
#! @result SUCCESS: service was restarted successfully
#! @result FAILURE: service could not be restarted due to an error
#!!#
########################################################################################################################

namespace: io.cloudslang.base.os.linux

imports:
  ssh_command: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings

flow:
  name: restart_service
  inputs:
    - host
    - port:
        default: '22'
        required: false
    - username
    - password:
        required: false
        sensitive: true
    - service_name
    - sudo_user:
        default: "false"
        required: false
    - private_key_file:
        required: false
    - worker_group:
        required: false

  workflow:
    - service_restart:
        worker_group: ${get('worker_group', 'RAS_Operator_Path')}
        do:
          ssh_command.ssh_flow:
            - host
            - port
            - sudo_command: ${ 'echo -e ' + password + ' | sudo -S ' if bool(sudo_user) else '' }
            - command: ${ sudo_command + 'service ' + service_name + ' restart' + ' && echo CMD_SUCCESS' }
            - username
            - password
            - private_key_file
        publish:
          - return_result
          - standard_out
          - standard_err
          - exception
          - command_return_code
          - return_code

    - check_result:
        worker_group: ${get('worker_group', 'RAS_Operator_Path')}
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${ standard_out }
            - string_to_find: 'CMD_SUCCESS'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - return_result
    - standard_out
    - standard_err
    - exception
    - command_return_code
    - return_code
