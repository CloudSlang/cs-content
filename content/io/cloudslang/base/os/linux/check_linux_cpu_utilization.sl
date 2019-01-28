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
#! @description: Checks the CPU percentage on a Linux machine.
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
#!
#! @output disk_space: percentage - Example: 50%
#! @output cpu: percentage of the CPU used
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
  name: check_linux_cpu_utilization
  inputs:
    - host
    - port:
        default: "22"
        required: false
    - username
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

  workflow:
    - check_linux_cpu:
        do:
          ssh.ssh_flow:
            - host
            - port
            - username
            - password
            - private_key_file
            - command: >
                (top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.1f%%\n", prefix, 100 - v }')
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
    - cpu: ${standard_out}
    - error_message: ${ '' if 'standard_err' not in locals() else standard_err if return_code == '0' else return_result }

  results:
    - SUCCESS
    - FAILURE
