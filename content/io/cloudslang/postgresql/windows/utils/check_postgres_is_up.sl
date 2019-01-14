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
#! @description: This flow checks if existing postgres database is up.
#!
#! @input hostname: Hostname or IP address of the target machine
#! @input hostname_port: The WinRM service port
#! @input hostname_protocol: The protocol used to connect to the WinRM service.
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
#! @input data_dir: The directory where database data files reside
#! @input service_name: The service name
#!                      Default: 'postgresql'
#!
#! @output  process_id: process id of system service
#! @output  return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output  return_code: '0' if success, '-1' otherwise
#! @output  exception: contains the stack trace in case of an exception
#!
#! @result SUCCESS: Operation was executed successfully
#! @result FAILURE: There was an error
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.windows.utils

imports:
  base: io.cloudslang.base.cmd
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils
  postgres: io.cloudslang.postgresql
  scripts: io.cloudslang.base.powershell

flow:
  name: check_postgres_is_up

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
    - service_name:
        required: true
  workflow:
    - get_system_service_process_info_command:
        do:
          postgres.windows.utils.get_system_service_process_info_command:
             - service_name: ${service_name}
        publish:
            - pwsh_command
        navigate:
          - SUCCESS: run_command

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
          -  stderr
        navigate:
          - SUCCESS: verify
          - FAILURE: FAILURE

    - verify:
          do:
            strings.string_occurrence_counter:
              - string_in_which_to_search: ${return_result}
              - string_to_find: 'State     : Running'
          navigate:
            - SUCCESS: SUCCESS
            - FAILURE: FAILURE
  outputs:
      - process_id : ${return_result.splitlines()[2].split(':')[1] if return_result is not None and 'ProcessId' in return_result else ""}
      - return_result
      - exception : ${get('stderr','').strip()}
      - return_code: ${}
  results:
    - SUCCESS
    - FAILURE
