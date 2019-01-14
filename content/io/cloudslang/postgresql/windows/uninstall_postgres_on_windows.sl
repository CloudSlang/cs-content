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
#! @description: Uninstall postgresql on machines that are running on Windows. The flow also remove 'data_dir' and an system account
#!
#!
#! @input hostname: Hostname or IP address of the target machine
#! @input hostname_port: The WinRM service port
#!                       Default: '5985'
#!                       Optional
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
#! @input execution_timeout: Time in seconds to wait for the command to complete
#!                           Default: '90'
#!                           Optional
#! @input installation_location: The postgresql installation location
#!                               Default: 'C:\\Program Files\\PostgreSQL\\10.6'
#! @input data_dir: The directory where database data files will reside
#!                  Default: 'C:\\Program Files\\PostgreSQL\\10.6\\data'
#!                  Optional
#! @input service_name: The service name
#!                      Default: 'postgresql'
#! @input service_account: The service account
#!                         Default: 'postgres'
#! @input service_password: The service password
#!                          Optional
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output return_code: '0' if success, '-1' otherwise
#! @output exception: contains the stack trace in case of an exception
#!
#! @result SUCCESS: The result of a flow
#! @result FAILURE: error
#!!#
########################################################################################################################
namespace: io.cloudslang.postgresql.windows

imports:
  scripts: io.cloudslang.base.powershell
  strings: io.cloudslang.base.strings
  postgres: io.cloudslang.postgresql

flow:
  name: uninstall_postgres_on_windows

  inputs:
    - hostname:
        required: true
    - hostname_port:
        default: '5985'
        required: false
    - hostname_protocol:
        default: 'http'
        required: false
    - username:
        required: true
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
        default: '600'
    - installation_location:
        default: 'C:\\Program Files\\PostgreSQL\\10.6'
        required: false
    - data_dir:
        default: 'C:\\Program Files\\PostgreSQL\\10.6\\data'
        required: false
    - service_name:
        required: true
    - service_account:
        required: true
  workflow:
    - uninstall_postgres:
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
                ${'Remove-LocalUser -Name ' + service_account + '; Set-Location -Path \"' + installation_location+'\"; $uninstaller = get-command .\\uninstall-postgresql.exe; & $uninstaller --mode unattended;' }
        publish:
            - return_code
            - return_result
            - exception: ${get('stderr')}
        navigate:
           - SUCCESS: remove_data_and_service_account
           - FAILURE: FAILURE

    - remove_data_and_service_account:
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
                ${'Remove-Item -Path \"' + data_dir + '\" -Recurse -Force;' }
        publish:
            - return_code
            - return_result
            - exception: ${get('stderr')}
        navigate:
            - SUCCESS: SUCCESS
            - FAILURE: FAILURE
  outputs:
    - return_code
    - return_result
    - exception
  results:
    - SUCCESS
    - FAILURE
