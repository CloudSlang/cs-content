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
#!!
#! @description: Restarts a remote Linux process using SSH.
#!
#! @input host: hostname or IP address
#! @input port: Optional - SSH port
#! @input username: username to connect as
#! @input password: Optional - password of user
#! @input process_name: Linux process name to be restarted
#!                      NOTE: if Linux has several processes with the same name all of them will be restarted
#! @input sudo_user: Optional - whether to use 'sudo' prefix before command - Default: false
#! @input private_key_file: absolute path to the private key file
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of successful request, null otherwise
#! @output exception: contains the stack trace in case of an exception
#! @output command_return_code: return code of the remote command corresponding to the SSH channel. The return code is
#!                              only available for certain types of channels, and only after the channel was closed
#!                              (more exactly, just before the channel is closed).
#!                              Examples: '0' for a successful command, '-1' if the command was not yet terminated (or this
#!                              channel type has no command), '126' if the command cannot execute.
#! @output return_code: return code of the command
#!
#! @result SUCCESS: process on Linux host is restarted successfully
#! @result FAILURE: processes cannot be restarted due to an error
#!!#
########################################################################################################################

namespace: io.cloudslang.base.os.linux

imports:
  ssh: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings

flow:
  name: restart_process

  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
        sensitive: true
    - process_name
    - sudo_user:
        default: "False"
        required: False
    - private_key_file:
        required: false

  workflow:
    - process_restart:
        do:
          ssh.ssh_flow:
            - host
            - port
            - sudo_command: ${ ' echo ' + password + ' | sudo -S ' if bool(sudo_user) else '' }
            - command: ${ sudo_command + 'pkill -HUP -e ' + process_name }
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
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${ standard_out }
            - string_to_find: ${ process_name }

  outputs:
    - return_result
    - standard_out
    - standard_err
    - exception
    - command_return_code
    - return_code
