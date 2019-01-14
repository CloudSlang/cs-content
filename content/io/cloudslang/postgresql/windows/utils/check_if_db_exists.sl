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
#! @description: Check whether a postgresql database exists
#!
#! @input hostname: Hostname or IP address of the target machine
#! @input hostname_port: The WinRM service port
#! @input hostname_protocol: The WinRM service protocol
#! @input service_account: The service account
#! @input service_password: The service password
#! @input installation_location: The full path to the location where PostgreSQL was installed.
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
#! @input connection_timeout: Time in milliseconds to wait for the connection to be made
#!                            Default value: '10000'
#!                            Optional
#! @input execution_timeout: Time in milliseconds to wait for the command to complete
#!                           Default: '90000'
#!                           Optional
#! @input db_name: Specifies the name of the database
#! @input private_key_file: Absolute path to private key file
#!                          Optional
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output return_code: '0' if success, '-1' otherwise
#! @output exception: contains the stack trace in case of an exception
#! @output stderr: contains the stack trace in case of an exception
#! @output xml_output: contains the xml output of the execution
#!
#! @result DB_EXIST: The database was found
#! @result DB_NOT_EXIST: The database was not found
#! @result FAILURE: error
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.windows.utils

imports:
  strings: io.cloudslang.base.strings
  math: io.cloudslang.base.math
  postgres: io.cloudslang.postgresql
  scripts: io.cloudslang.base.powershell

flow:
  name: check_if_db_exists

  inputs:
    - hostname:
        required: true
    - hostname_port:
        required: true
    - hostname_protocol:
        required: true
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
        default: '90000'
    - db_name:
       required: true
    - service_account:
        required: true
    - service_password:
        required: true
    - installation_location:
        required: true
    - private_key_file:
        required: false
    - exec_command:
        private: true
        default: ${'select count(datname) from pg_catalog.pg_database where datname=\'' + db_name +  '\';'}
  workflow:
    - check_host_prereqeust:
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
                  ${'$env:PGPASSWORD=\''+service_password+'\';Set-Location -Path \"' + installation_location+'\\\\bin\"; $psql = get-command .\\psql.exe; $user =\''+ service_account +'\'; & $psql -U $user -A -t -c \"'+ exec_command + '\"'}
         publish:
            - return_code
            - return_result
            - exception
            - stderr
            - xml_output: ${stderr[10:] if '#< CLIXML' in get('stderr','') else ""}
            - test: ${return_result}
         navigate:
            - SUCCESS: check_if_db_exist_result
            - FAILURE: FAILURE
    - check_if_db_exist_result:
         do:
            math.compare_numbers:
              - value1: '${(str(test)).strip()}'
              - value2: "0"
         navigate:
             - GREATER_THAN: DB_EXIST
             - EQUALS: DB_NOT_EXIST
             - LESS_THAN: FAILURE

  outputs:
    - return_code
    - return_result
    - exception
    - stderr
    - xml_output
  results:
    - DB_EXIST
    - DB_NOT_EXIST
    - FAILURE