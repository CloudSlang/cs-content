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
#! @description: Performs SSH command in order to install Java on machine that are running Gentoo based linux
#!
#! @input host: hostname or IP address
#! @input root_password: The root password
#! @input java_version: The java version that will be installed
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of unsuccessful request, null otherwise
#! @output return_code: '0' if success, '-1' otherwise
#! @output exception: contains the stack trace in case of an exception
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

namespace: io.cloudslang.base.os.linux.samples

imports:
  ssh: io.cloudslang.base.ssh

flow:
  name: install_java_on_gentoo

  inputs:
    - host
    - root_password:
        sensitive: true
    - java_version

  workflow:
    - install_java:
        do:
          ssh.ssh_flow:
            - host
            - username: 'root'
            - password: ${root_password}
            - command: ${'emerge ' + java_version}
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
          - exception

  outputs:
      - return_result
      - standard_err
      - standard_out
      - return_code
      - command_return_code
      - exception
