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
#! @description: Create a postgresql database on machines that are running on Windows
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
#! @input execution_timeout: Time in seconds to wait for the command to complete
#!                           Default: '90'
#!                           Optional
#! @input installation_location: The full path to the location where PostgreSQL was installed.
#!                               Default: 'C:\\Program Files\\PostgreSQL\\10.6'
#!                               Optional
#! @input service_name: The service name
#!                      Default: 'postgresql'
#! @input service_account: The service account
#! @input service_password: The service password
#! @input db_name: Specifies the name of the database to be created.
#!                 The default is to create a database with the same name as the current system user ('postgres')
#!                 Default: 'postgres'
#! @input db_description: Specifies a comment to be associated with the newly created database
#!                        Optional
#! @input db_owner: Specifies the database user who will own the new database.
#!                  If no value is specified, the superuser account will own this database.
#!                  Default: 'postgres'
#! @input db_tablespace: Specifies the default tablespace for the database
#!                       Optional
#! @input db_encoding: Specifies the character encoding scheme to be used in this database
#!                     Optional
#! @input db_locale: Specifies the locale to be used in this database
#!                   Optional
#! @input db_template: Specifies the template database from which to build this database
#!                     Optional
#! @input db_echo: Echo the commands that createddb generates and sends to the server
#!                 Valid values: 'true', 'false'
#!                 Default value: 'true'
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
  base: io.cloudslang.base.cmd
  ssh: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings
  postgres: io.cloudslang.postgresql
  scripts: io.cloudslang.base.powershell

flow:
  name: create_db_on_windows

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
        default: ''
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
        default: '90'
    - installation_location:
        default: 'C:\\Program Files\\PostgreSQL\\10.6'
    - service_name:
        default: 'postgresql'
    - service_account:
        required: true
    - service_password:
        required: true
        sensitive: true
    - db_name:
        default: 'postgres'
    - db_description:
        required: false
    - db_tablespace:
        required: false
    - db_encoding:
        required: false
    - db_locale:
        required: false
    - db_owner:
        required: false
    - db_template:
        required: false
    - db_echo:
        default: 'true'
  workflow:
      - check_postgress_is_running:
          do:
             postgres.windows.utils.get_system_service_command:
                - service_name: ${service_name}
                - operation: 'status'
          publish:
             - pwsh_command
             - exception
             - return_code
             - return_result
          navigate:
            - SUCCESS: get_postgresql_service_user
            - FAILURE: FAILURE

      - get_postgresql_service_user:
          do:
             postgres.windows.utils.get_system_service_user:
                - service_name
                - hostname
                - hostname_port
                - hostname_protocol
                - username
                - password
                - execution_timeout
                - proxy_host
                - proxy_port
                - proxy_username
                - proxy_password
          publish:
             - service_user
             - exception
             - return_code
             - return_result
             - stderr

      - is_postgres_service_user_found:
           do:
              strings.string_equals:
                - first_string: ''
                - second_string: ${service_user}
           navigate:
             - SUCCESS: FAILURE
             - FAILURE: build_createdb_command

      - build_createdb_command:
           do:
              postgres.common.createdb_command:
                - db_name
                - db_description
                - db_tablespace
                - db_encoding
                - db_locale
                - db_owner: ${db_owner if db_owner is not None and db_owner !=''  else service_user}
                - db_template
                - db_echo
                - db_username: ${service_user}
                - db_password: ${service_password}
           publish:
              - psql_command
           navigate:
              - SUCCESS: create_database

      - create_database:
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
                  ${ '$env:PGPASSWORD = \"' + service_password + '\"; Set-Location -Path \"' + installation_location+'\\\\bin\"; .\\' + psql_command}
         publish:
            - return_code: ${script_exit_code}
            - script_exit_code
            - return_result
            - stderr
            - exception: ${'' if get('script_exit_code','') == "0" else stderr}
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
