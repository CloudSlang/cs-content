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
#! @description: Perform a SSH command to make a new folder named <folder_name>
#!               in a specified path indicated by <folder_path>
#!
#! @input return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @input host: hostname or IP address
#! @input root_password: The root password
#! @input folder_name: The folder name to be added
#! @input folder_path: Optional - the absolute path under the folder will be created - Default: '/home'
#!
#! @output return_result: output of the command
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of unsuccessful request, null otherwise
#! @output return_code: '0' if success, '-1' otherwise
#! @output command_return_code: The return code of the remote command corresponding to the SSH channel. The return code
#!                              is only available for certain types of channels, and only after the channel was closed
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
  name: make_new_folder

  inputs:
    - host
    - root_password:
        sensitive: true
    - folder_name
    - folder_path:
        default: '/home'
        required: false

  workflow:
    - make_folder:
        do:
          ssh.ssh_flow:
            - host
            - port: '22'
            - username: 'root'
            - password: ${root_password}
            - folder_path_string: ${'/home' if folder_path == '' else folder_path}
            - command: >
                 ${'cd ' + folder_path_string + ' && mkdir ' + folder_name}
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code

    - evaluate_result:
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
