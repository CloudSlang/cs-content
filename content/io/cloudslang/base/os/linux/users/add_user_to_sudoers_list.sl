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
#! @description: Perform a SSH command to add a specified user to sudoers group.
#!
#! @input host: hostname or IP address
#! @input port: Optional - port number for running the command
#!              Default: '22'
#! @input password: password of user
#! @input private_key_file: Optional - the path to the private key file
#! @input user: The user to be added in sudoers group
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of successful request, null otherwise
#! @output return_code: '0' if success, '-1' otherwise
#! @output exception: contains the stack trace in case of an exception
#! @output command_return_code: The return code of the remote command corresponding to the SSH channel. The return code is
#!                              only available for certain types of channels, and only after the channel was closed (more
#!                              exactly, just before the channel is closed).
#!                              Examples: '0' for a successful command, '-1' if the command was not yet terminated (or this
#!                              channel type has no command), '126' if the command cannot execute.
#! @output return_code: return code of the command
#!
#! @result SUCCESS: user was successfully added
#! @result FAILURE: error occurred when trying to add user
#!!#
########################################################################################################################

namespace: io.cloudslang.base.os.linux.users

imports:
  ssh: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings

flow:
  name: add_user_to_sudoers_list

  inputs:
    - host
    - port:
        default: "22"
        required: false
    - password:
        sensitive: true
    - private_key_file:
        required: false
    - user

  workflow:
    - add_user:
        do:
          ssh.ssh_flow:
            - host
            - port
            - username: "root"
            - password
            - private_key_file
            - user
            - command: >
                    ${'echo \"' + user + ' ALL=(ALL:ALL) ALL\" >> /etc/sudoers'}
        publish:
          - return_result
          - standard_out
          - standard_err
          - exception
          - command_return_code
          - return_code
        navigate:
          - SUCCESS: check_result
          - FAILURE: FAILURE

    - check_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${ command_return_code }
            - string_to_find: "0"
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

  results:
    - SUCCESS
    - FAILURE
