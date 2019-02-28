#   (c) Copyright 2019 Micro Focus, L.P.
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
#! @description: This flow allows operating (start/stop/restart/reload,status) on existing postgres database.
#!
#! @input operation: The operation to be performed
#!                   Valid values: stop, start, restart, reload, status
#! @input	installation_location: The full path to the location where PostgreSQL was installed
#! @input pg_ctl_location: Path of the pg_ctl binary
#! @input hostname: Hostname or IP address of the target machine
#! @input username: Username used to connect to the target machine
#! @input password: The root or privileged account password
#! @input proxy_host: The proxy server used to access the remote machine
#!                    Optional
#! @input proxy_port: The proxy server port
#!                    Valid values: -1 and numbers greater than 0
#!                    Optional
#! @input proxy_username: The user name used when connecting to the proxy
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value
#!                        Optional
#! @input connection_timeout: Time in milliseconds to wait for the connection to be made
#!                            Default value: '10000'
#!                            Optional
#! @input execution_timeout: Time in milliseconds to wait for the command to complete
#!                           Default: '90000'
#!                           Optional
#! @input private_key_file: Absolute path to private key file
#!                          Optional
#! @input exec_command: The command to execute
#!                      Private
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output return_code: Return code of the command
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of successful request, null otherwise
#! @output exception: Contains the stack trace in case of an exception
#!
#!
#! @result SUCCESS: Operation was executed successfully
#! @result FAILURE: There was an error
#!!#
########################################################################################################################
namespace: io.cloudslang.postgresql.linux.utils

imports:
  base: io.cloudslang.base.cmd
  ssh: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils
  list: io.cloudslang.base.lists

flow:
  name: run_pg_ctl_command
  inputs:
      - operation:
          required: true
      - installation_location:
          required: true
      - pg_ctl_location:
          required: true
      - hostname:
          required: true
      - username:
          required: true
      - proxy_host:
          required: false
      - proxy_port:
          required: false
      - proxy_username:
          required: false
      - proxy_password:
          required: false
      - connection_timeout:
          default: '10000'
      - execution_timeout:
          default: '90000'
      - private_key_file:
          required: false
      - exec_command:
         default: ${'sudo -i -u postgres ' + pg_ctl_location + '/pg_ctl -s -D ' + installation_location + '/data ' + operation}
         private: true
  workflow:
     - is_required_out_redirect:
         do:
             list.contains:
                 - container: 'start,restart'
                 - sublist: ${operation}
         navigate:
            - SUCCESS: run_pg_ctl_command_with_dev_null
            - FAILURE: run_pg_ctl_command

     - run_pg_ctl_command:
         do:
            ssh.ssh_flow:
             - host: ${hostname}
             - port: '22'
             - username
             - private_key_file
             - proxy_host
             - proxy_port
             - proxy_username
             - proxy_password
             - timeout: ${execution_timeout}
             - connect_timeout: ${connection_timeout}
             - command: >
                 ${exec_command}
         publish:
            - return_result
            - exception
            - return_code
            - standard_err
            - standard_out
            - command_return_code
         navigate:
            - SUCCESS: SUCCESS
            - FAILURE: FAILURE

     - run_pg_ctl_command_with_dev_null:
         do:
            ssh.ssh_flow:
             - host: ${hostname}
             - port: '22'
             - username
             - private_key_file
             - proxy_host
             - proxy_port
             - proxy_username
             - proxy_password
             - timeout: ${execution_timeout}
             - connect_timeout: ${connection_timeout}
             - command: >
                 ${exec_command + ' > /dev/null'}
         publish:
          - return_result
          - exception
          - return_code
          - standard_err
          - standard_out
          - command_return_code
         navigate:
            - SUCCESS: SUCCESS
            - FAILURE: FAILURE

  outputs:
      - return_result
      - exception: ${get('exception', '').strip()}
      - return_code
      - standard_err
      - standard_out
