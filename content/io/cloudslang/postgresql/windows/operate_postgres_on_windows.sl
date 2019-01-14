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
#! @description: This flow allows operating (start/stop/restart/reload/status) on existing postgres database.
#!
#! @input hostname: Hostname or IP address of the target machine
#! @input hostname_port: The WinRM service port
#!                       Default: '5985'
#!                       Optional
#! @input hostname_protocol: The protocol used to connect to the WinRM service.
#!                           Valid values: 'http', 'https'.
#!                           Optional
#! @input username: Username used to connect to the target machine
#! @input password: The privileged account password
#! @input proxy_host: The proxy server used to access the remote machine
#!                    Optional
#! @input proxy_port: The proxy server port
#!                    Valid values: -1 and numbers greater than 0
#!                    Optional
#! @input proxy_username: The user name used when connecting to the proxy
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value
#!                        Optional
#! @input execution_timeout: Time in seconds to wait for the command to complete.
#!                           Default: '180'
#!                           Optional
#! @input installation_location: The full path to the location where PostgreSQL was installed
#!                               Default: 'C:\\Program Files\\PostgreSQL\\10.6'
#! @input data_dir: The directory where database data files reside
#!                  Default: 'C:\\Program Files\\PostgreSQL\\10.6\\data'
#!                  Optional
#! @input service_name: The service name
#!                      Default: 'postgresql'
#! @input operation: The operation to be performed
#!                   Valid values: stop, start, restart, reload, status
#!                   Optional
#! @input start_on_boot: A flag to indicate if server should be restart after configuration
#!                       Valid values: true, false
#!                       Optional
#! @input private_key_file: Absolute path to private key file
#!                          Optional
#!
#! @output  return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output  return_code: '0' if success, '-1' otherwise
#! @output  exception: contains the stack trace in case of an exception
#!
#! @result SUCCESS: Operation was executed successfully
#! @result FAILURE: There was an error
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.windows

imports:
  base: io.cloudslang.base.cmd
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils
  postgres: io.cloudslang.postgresql
  scripts: io.cloudslang.base.powershell

flow:
  name: operate_postgres_on_windows

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
        sensitive: true
    - password:
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
        default: '180'
    - installation_location:
        default: 'C:\\Program Files\\PostgreSQL\\10.6'
    - data_dir:
        default: 'C:\\Program Files\\PostgreSQL\\10.6\\data'
    - service_name:
        default: 'postgresql'
    - operation:
        required: false
    - start_on_boot:
        required: false
    - private_key_file:
        required: false

  workflow:
    - check_installation_location:
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
                ${'$is_found = Test-Path -Path "'+ installation_location +'"; ; if(!$is_found) {" installation_location was not found"; Exit(1)}'}
        publish:
          -  return_code
          -  return_result
          -  stderr
          -  script_exit_code
          -  exception
        navigate:
          - SUCCESS: check_data_dir
          - FAILURE: FAILURE

    - check_data_dir:
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
                 ${'$is_found = Test-Path -Path "'+ data_dir +'"; ; if(!$is_found) {" Data_dir was not found"; Exit(1)}'}
        publish:
          -  return_code
          -  return_result
          -  stderr
          -  script_exit_code
          -  exception
        navigate:
          - SUCCESS: check_operation_value
          - FAILURE: FAILURE

    - check_operation_value:
        do:
           utils.is_null:
            - variable: ${operation}
        navigate:
          - IS_NULL: check_start_on_boot_value
          - IS_NOT_NULL: get_pwsh_command_by_operation_name

    - get_pwsh_command_by_operation_name:
        do:
          postgres.windows.utils.get_system_service_command:
             - service_name: ${service_name}
             - operation: ${operation}
        publish:
            - pwsh_command
            - exception
            - return_code
            - return_result
        navigate:
          - SUCCESS: run_command
          - FAILURE: FAILURE

    - run_command:
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
            - script: ${pwsh_command}
        publish:
          -  return_code
          -  return_result
          -  script_exit_code
          -  exception
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

    - check_start_on_boot_value:
        do:
           utils.is_null:
            - variable: ${start_on_boot}
        navigate:
          - IS_NULL: SUCCESS
          - IS_NOT_NULL: run_start_on_boot

    - run_start_on_boot:
        do:
           utils.is_true:
            - bool_value: ${start_on_boot}
        navigate:
          - 'TRUE': enable_start_on_boot
          - 'FALSE': disable_start_on_boot

    - enable_start_on_boot:
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
               ${'Set-Service -Name '+ service_name +' -StartupType Automatic'}
       publish:
          -  return_code
          -  return_result
          -  exception
       navigate:
         - SUCCESS: SUCCESS
         - FAILURE: FAILURE

    - disable_start_on_boot:
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
               ${'Set-Service -Name '+ service_name + ' -StartupType Disabled'}
       publish:
          -  return_code
          -  return_result
          -  exception
       navigate:
         - SUCCESS: SUCCESS
         - FAILURE: FAILURE

  outputs:
    - return_result
    - exception
    - return_code
  results:
    - SUCCESS
    - FAILURE
