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
#! @description: Performs several powershell commands in order to do a complete setup of postgresql on machines that are running
#!               windows Server 2016
#!
#! @input hostname: Hostname or IP address of the target machine
#! @input username: Username used to connect to the target machine
#! @input password: The root or priviledged account password
#! @input port: The WinRM service port
#!              Default: '5985'
#!              Optional
#! @input protocol: The protocol used to connect to the WinRM service.
#!                  Valid values: 'http' or 'https'.
#!                  Optional
#! @input proxy_host: The proxy server used to access the remote machine.
#!                    Optional
#! @input proxy_port: The proxy server port.
#!                    Valid values: -1 and numbers greater than 0.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: The user name used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input connection_timeout: Time in milliseconds to wait for the connection to be made.
#!                            Default value: '10000'
#!                            Optional
#! @input execution_timeout: Time in milliseconds to wait for the command to complete.
#!                           Default: '90000'
#!                           Optional
#! @input installation_file: The postgresql installation file or link
#!                           Default: 'http://get.enterprisedb.com/postgresql/postgresql-10.6-1-windows-x64.exe'
#!                           Optional
#! @input installation_location: The installation location in the target machine
#!                               Default: 'C:\\Program Files\\PostgreSQL\\10.6'
#!                               Optional
#! @input data_dir: The directory where database data files will reside
#!                  Default: 'C:\\Program Files\\PostgreSQL\\10.6\\data'
#!                  Optional
#! @input create_shortcuts: Flag to specify whether menu shortcuts should be created.
#!                          Valid values: true or false
#!                          Default: true
#!                          Optional
#! @input debug_level: Level of detail written to the debug_log file (debug_trace).
#!                     Valid values: 0 to 4
#!                     Default: 2
#!                     Optional
#! @input debug_trace: Log filename to troubleshoot installation problems.
#!                     Valid values: Filename with valid path.
#!                     Optional
#! @input extract_only: Flag to indicate that the installer should extract the PostgreSQL binaries without performing an installation.
#!                      Valid values: true or false
#!                      Default: false
#!                      Optional
#! @input installer_language: Installation language.
#!                            Valid values: en, es, fr
#!                            Default: en
#!                            Optional
#! @input install_runtimes: Flag to specify whether the installer should install the Microsoft Visual C++ runtime libraries.
#!                          Valid values: true or false
#!                          Default: true
#!                          Optional
#! @input listen_addresses: The address where the PostgreSQL database listens.
#!                          Optional
#! @input ssl: Flag to enable SSL connections.
#!             Optional
#! @input ssl_ca_file: The name of the file containing the SSL server certificate authority (CA).
#!                     Optional
#! @input ssl_cert_file: The name of the file containing the SSL server certificate.
#!                       Optional
#! @input ssl_key_file: The name of the file containing the SSL server private key.
#!                      Optional
#! @input max_connections: The maximum number of client connections allowed.
#!                         Optional
#! @input shared_buffers: Flag that determines how much memory is dedicated to PostgreSQL to use for caching data.
#!                        Optional
#! @input effective_cache_size: The effective cache size.
#!                              Optional
#! @input autovacuum: Flag to enable/disable autovacuum. The autovacuum process takes care of several maintenance chores inside your database that you really need.
#!                    Optional
#! @input work_mem: The memory used for sorting and queries.
#!                  Optional
#! @input configuration_file: The full path to the PostgreSQL configuration file in the local machine to be merged and applied to server.
#!                            Optional
#! @input allowed_hosts: A wildcard or a comma-separated list of hostnames or IPs (IPv4 or IPv6).
#!                       Optional
#! @input allowed_users: A comma-separated list of PostgreSQL users. If no value is specified for this input, all users will have access to the server.
#!                       Optional
#! @input reboot: A flag to indicate if server should be restart after configuration
#!                Default: 'no'
#!                Optional
#! @input private_key_file: Absolute path to private key file
#!                          Optional
#! @input temp_local_folder: The local folder to keep files downloaded from remote host. Use relative path to support different platforms. If the folder doesn't exist, it'll be created.
#!                           Default: '/tmp'
#!                           Optional
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
#! @input db_echo: Echo the commands that createdb generates and sends to the server
#!                 Valid values: 'true', 'false'
#!                 Default value: 'true'
#! @input start_on_boot: A flag to indicate if server should be restart after configuration
#!                       Valid values: true, false
#!                       Optional
#! @input server_port: The postgres db server port
#!                     Default: '5432'
#!                     Optional
#! @input service_name: The service name
#!                      Default: 'postgresql'
#! @input service_account: The service account
#!                         Default: 'postgres'
#! @input service_password: The service password
#!                          Optional
#! @input locale: The locale
#!                Default: 'English, United States'
#!                Optional
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output return_code: '0' if success, '-1' otherwise
#! @output stderr: contains the stack trace in case of an exception
#!
#! @result SUCCESS: Postgresql setup was successful
#! @result FAILURE: Postgresql setup was failed
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.windows

imports:
  postgres: io.cloudslang.postgresql
  print: io.cloudslang.base.print

flow:
  name: setup_postgres_on_windows

  inputs:
    - hostname:
        required: true
    - port:
        default: '5985'
        required: false
    - protocol:
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
    - connection_timeout:
        default: '10'
    - execution_timeout:
        default: '90'
    - installation_file:
        default: 'http://get.enterprisedb.com/postgresql/postgresql-10.6-1-windows-x64.exe'
        required: false
    - installation_location:
        default: 'C:\\Program Files\\PostgreSQL\\10.6'
        required: false
    - data_dir:
        default: 'C:\\Program Files\\PostgreSQL\\10.6\\data'
        required: false
    - server_port:
        default: '5432'
        required: false
    - service_name:
        default: 'postgresql'
    - service_account:
        default: 'postgres'
    - service_password:
        sensitive: true
        required: true
    - locale:
        default: 'English, United States'
        required: false
    - create_shortcuts:
        default: 'true'
        required: false
    - debug_level:
        default: '2'
        required: false
    - debug_trace:
        default: ''
        required: false
    - extract_only:
        default: 'false'
        required: false
    - installer_language:
        default: 'en'
        required: false
    - install_runtimes:
        default: 'true'
        required: false
    - listen_addresses:
        default: 'localhost'
        required: false
    - ssl:
        required: false
    - ssl_ca_file:
        required: false
    - ssl_cert_file:
        required: false
    - ssl_key_file:
        required: false
    - max_connections:
        required: false
    - shared_buffers:
        required: false
    - effective_cache_size:
        required: false
    - autovacuum:
        required: false
    - work_mem:
        required: false
    - configuration_file:
        required: false
    - allowed_hosts:
        required: false
    - allowed_users:
        required: false
    - reboot:
        default: 'no'
        required: false
    - private_key_file:
        required: false
    - temp_local_folder:
        default: '/tmp'
        required: false
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
    - start_on_boot:
        required: false


  workflow:
    - install_postgres:
        do:
          postgres.windows.install_postgres_on_windows:
          - hostname
          - port
          - protocol
          - username
          - password
          - proxy_host
          - proxy_port
          - proxy_username
          - proxy_password
          - connection_timeout
          - execution_timeout
          - installation_file
          - installation_location
          - data_dir
          - server_port
          - service_name
          - service_account
          - service_password
          - locale
          - create_shortcuts
          - debug_level
          - debug_trace
          - extract_only
          - installer_language
          - install_runtimes
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: configure_postgres
          - DOWNLOAD_INSTALLER_MODULE_FAILURE: FAILURE
          - INSTALL_INSTALLER_MODULE_FAILURE: FAILURE
          - POSTGRES_INSTALL_PACKAGE_FAILURE: FAILURE

    - configure_postgres:
        do:
          postgres.windows.configure_postgres_on_windows:
            - hostname
            - hostname_port: ${port}
            - hostname_protocol: ${protocol}
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - execution_timeout
            - listen_addresses
            - port: ${server_port}
            - ssl
            - ssl_ca_file
            - ssl_cert_file
            - ssl_key_file
            - max_connections
            - shared_buffers
            - effective_cache_size
            - autovacuum
            - work_mem
            - configuration_file
            - allowed_hosts
            - allowed_users
            - installation_location
            - data_dir
            - reboot
            - private_key_file
            - temp_local_folder
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: create_database
          - FAILURE: FAILURE

    - create_database:
        do:
          postgres.windows.create_db_on_windows:
            - hostname
            - hostname_port: ${port}
            - hostname_protocol: ${protocol}
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - execution_timeout
            - installation_location
            - service_name
            - service_account
            - service_password
            - db_name
            - db_description
            - db_tablespace
            - db_encoding
            - db_locale
            - db_owner
            - db_template
            - db_echo
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: stop_postgres
          - FAILURE: FAILURE

    - stop_postgres:
        do:
          postgres.windows.operate_postgres_on_windows:
            - hostname
            - hostname_port: ${port}
            - hostname_protocol: ${protocol}
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - execution_timeout
            - installation_location
            - data_dir
            - service_name
            - start_on_boot
            - private_key_file
            - operation: 'stop'
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: start_postgres
          - FAILURE: FAILURE

    - start_postgres:
        do:
          postgres.windows.operate_postgres_on_windows:
            - hostname
            - hostname_port: ${port}
            - hostname_protocol: ${protocol}
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - execution_timeout
            - installation_location
            - data_dir
            - service_name
            - start_on_boot
            - private_key_file
            - operation: 'start'
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: restart_postgres
          - FAILURE: FAILURE

    - restart_postgres:
        do:
          postgres.windows.operate_postgres_on_windows:
            - hostname
            - hostname_port: ${port}
            - hostname_protocol: ${protocol}
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - execution_timeout
            - installation_location
            - data_dir
            - service_name
            - start_on_boot
            - private_key_file
            - operation: 'restart'
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: drop_database
          - FAILURE: FAILURE

    - drop_database:
        do:
          postgres.windows.drop_db_on_windows:
            - hostname
            - hostname_port: ${port}
            - hostname_protocol: ${protocol}
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - execution_timeout
            - installation_location
            - service_name
            - service_account
            - service_password
            - db_name
            - db_echo
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    -  return_code
    -  return_result
    -  stderr

  results:
    - SUCCESS
    - FAILURE
