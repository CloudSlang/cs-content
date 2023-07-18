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
#! @description: Checks the disk space percentage on a Linux machine.
#!
#! @input host: Docker machine host
#! @input port: Optional - port number for running the command - Default: '22'
#! @input username: Docker machine username
#! @input mount: Optional - mount to check disk space for - Default: '/'
#! @input password: Optional - Docker machine password
#! @input private_key_file: Optional - path to private key file
#! @input arguments: Optional - arguments to pass to the command
#! @input character_set: Optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#! @input pty: Optional - whether to use PTY - Valid: true, false
#! @input timeout: Optional - time in milliseconds to wait for command to complete
#! @input close_session: Optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#!                       if 'true' the SSH session used will be closed - Valid: true, false
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output disk_space: percentage - Example: 50%
#! @output error_message: error message if error occurred
#!
#! @result SUCCESS: operation finished successfully
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.base.os.linux

imports:
  ssh: io.cloudslang.base.ssh

flow:
  name: check_linux_disk_space
  inputs:
    - host
    - port:
        default: "22"
        required: false
    - username
    - mount:
        default: "/"
        required: false
    - password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - arguments:
        required: false
    - character_set:
        required: false
    - pty:
        required: false
    - timeout:
        required: false
    - close_session:
        required: false
    - worker_group:
        required: false

  workflow:
    - check_linux_disk_space:
        worker_group: ${get('worker_group', 'RAS_Operator_Path')}
        do:
          ssh.ssh_flow:
            - host
            - port
            - username
            - password
            - private_key_file
            - command: >
                ${"df -kh " + mount + " | grep -v 'Filesystem' | awk '{print $5}'"}
            - arguments
            - character_set
            - pty
            - timeout
            - close_session
        publish:
          - return_result
          - standard_out
          - standard_err
          - return_code

  outputs:
    - disk_space: ${ '' if 'standard_out' not in locals() else standard_out.strip() }
    - error_message: ${ '' if 'standard_err' not in locals() else standard_err if return_code == '0' else return_result }

  results:
    - SUCCESS
    - FAILURE
