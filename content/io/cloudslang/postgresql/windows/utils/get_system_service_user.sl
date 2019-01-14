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
#! @description: Get user of a postgresql service on machines that are running on Windows
#!
#! @input hostname: Hostname or IP address of the target machine
#! @input hostname_port: The WinRM service port
#!              Default: '5985'
#!              Optional
#! @input hostname_protocol: The WinRM service protocol
#!              Default: 'http'
#!              Optional
#! @input username: Username used to connect to the target machine
#! @input password: The root or priviledged account password
#! @input proxy_host: The proxy server used to access the remote machine
#!                    Optional
#! @input proxy_port: The proxy server port
#!                    Valid values: -1 and numbers greater than 0.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: The user name used when connecting to the proxy
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value
#!                        Optional
#! @input execution_timeout: Time in milliseconds to wait for the command to complete
#!                           Default: '90000'
#!                           Optional
#! @input service_name: The service name
#!                      Default: 'postgresql'
#! @input private_key_file: Absolute path to private key file
#!                          Optional
#!
#! @output service_user: service user if success
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output return_code: '0' if success, '-1' otherwise
#! @output exception: an exception
#! @output stderr: contains the stack trace in case of an exception
#!
#! @result SUCCESS: The result of a flow
#! @result FAILURE: error
#!!#
########################################################################################################################
namespace: io.cloudslang.postgresql.windows.utils

imports:
  base: io.cloudslang.base.cmd
  ssh: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings
  scripts: io.cloudslang.base.powershell

flow:
  name: get_system_service_user

  inputs:
    - hostname:
        required: true
    - hostname_port:
        required: false
    - hostname_protocol:
        required: false
    - username:
        sensitive: true
    - password:
        required: false
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - execution_timeout:
         required: true
    - service_name:
         required: true
    - private_key_file:
        required: false
  workflow:
      - get_postgresql_service_user:
          do:
            scripts.powershell_script:
              - host: ${hostname}
              - port: ${hostname_port}
              - protocol: ${hostname_protocol}
              - username
              - password
              - proxy_host
              - proxy_port
              - proxy_username
              - proxy_password
              - operation_timeout: ${execution_timeout}
              - script: >
                  ${'$credential = gwmi -class win32_service | ? {$_.Name -eq \''+ service_name  +'\'} | Select startname -ExpandProperty startname; if ($credential) { $credential.TrimStart(\'.\\\'); Exit(0);} else { "Windows service \''+ service_name +'\' was not found"; Exit(1);}'}
          publish:
            - script_exit_code
            - return_code
            - return_result
            - stderr
            - exception
  outputs:
    - service_user: ${return_result if script_exit_code == "0" else ''}
    - exception: ${get('exception', '')}
    - return_code:  ${script_exit_code}
    - return_result
    - stderr: ${get('stderr', '')}
