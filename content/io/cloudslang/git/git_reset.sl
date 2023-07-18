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
#! @description: Performs a git reset on a git directory to clean it up.
#!
#! @input host: hostname or IP address
#! @input port: Optional - port number for running the command
#! @input username: username to connect as
#! @input password: Optional - password of user
#! @input git_repository_localdir: target directory where a git repository exists - Default: /tmp/repo.git
#! @input git_reset_target: Optional - SHA you want to reset the branch to - Default: HEAD
#! @input sudo_user: Optional - true or false, whether the command should execute using sudo
#! @input private_key_file: absolute path to the private key file
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of successful request, null otherwise
#! @output exception: contains the stack trace in case of an exception
#! @output command_return_code: return code of remote command corresponding to the SSH channel. The return code is
#!                              only available for certain types of channels, and only after the channel was closed
#!                              (more exactly, just before the channel is closed).
#!                              Examples: '0' for a successful command, '-1' if the command was not yet terminated (or this
#!                              channel type has no command), '126' if the command cannot execute
#! @output return_code: return code of the command
#!
#! @result SUCCESS: GIT directory was reset successfully
#! @result FAILURE: There was an error while trying to reset GIT directory and/or while trying to clean it
#!!#
########################################################################################################################

namespace: io.cloudslang.git

imports:
  ssh: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings

flow:
  name: git_reset

  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
        sensitive: true
    - git_repository_localdir: "/tmp/repo.git"
    - git_reset_target:
        default: "HEAD"
        required: false
    - sudo_user:
        default: 'false'
        required: false
    - private_key_file:
        required: false

  workflow:
    - git_reset:
        do:
          ssh.ssh_flow:
            - host
            - port
            - sudo_command: ${ 'echo ' + password + ' | sudo -S ' if (sudo_user=="true") else '' }
            - git_reset: ${ ' && git reset --hard ' + git_reset_target }
            - command: ${ sudo_command + ' cd ' + git_repository_localdir + git_reset + ' && echo GIT_SUCCESS' }
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
            - string_to_find: "GIT_SUCCESS"

  outputs:
    - return_result
    - standard_out
    - standard_err
    - exception
    - command_return_code
    - return_code
