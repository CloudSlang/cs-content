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
#! @description: Performs several linux commands in order to do a complete setup of postgresql on machines that are running
#!               Red Hat based linux
#!
#! @prerequisites: Java package
#!
#! @input hostname: Hostname or IP address of the target machine
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
#! @input installation_file: The postgresql installation file or link
#!                           Default: 'https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-redhat10-10-2.noarch.rpm'
#! @input service_name: The service name
#! @input service_account: The service account
#!                         Default: 'postgres'
#!                         Optional
#! @input service_password: The service password
#!                          Default: 'postgres'
#!                          Optional
#! @input private_key_file: Absolute path to private key file
#!                          Optional
#! @input listen_addresses: The address where the PostgreSQL database listens.
#!                          Optional
#! @input port: The port the PostgreSQL database should listen.
#!              Optional
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
#! @input installation_location: The full path to the location where PostgreSQL was installed.
#!                               Default: '/var/lib/pgsql/10'
#!                               Optional
#! @input reboot: A flag to indicate if server should be restart after configuration
#!                Default: 'no'
#!                Optional
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
#! @input temp_local_folder: The temporary solution to keep files downloaded from remote host.
#!                           Default: '/tmp'
#!                           Optional
#! @input pg_ctl_location: Path of the pg_ctl binay
#!                         Default: '/usr/pgsql-10/bin'
#!                         Optional
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output return_code: '0' if success, '-1' otherwise
#! @output exception: contains the stack trace in case of an exception
#!
#! @result SUCCESS: Postgresql setup was successful
#! @result FAILURE: Postgresql setup was failed
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.linux

imports:
  postgres: io.cloudslang.postgresql
  print: io.cloudslang.base.print

flow:
  name: setup_postgres_on_linux

  inputs:
    - hostname:
        required: true
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
        default: '10000'
    - execution_timeout:
        default: '90000'
    - installation_file:
        required: false
    - service_account:
        default: 'postgres'
    - service_name:
        default: 'postgresql-10'
    - service_password:
        required: true
        sensitive: true
    - private_key_file:
        required: false
    - listen_addresses:
        default: 'localhost'
        required: false
    - port:
        default: '5432'
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
        required: true
    - allowed_users:
        required: true
    - installation_location:
        required: true
        default: '/var/lib/pgsql/10'
    - reboot:
        default: 'no'
        required: false
    - temp_local_folder:
        default: '/tmp'
        required: false
    - pg_ctl_location:
        default: '/usr/pgsql-10/bin'
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

  workflow:
    - install_postgres:
        do:
          postgres.linux.install_postgres_on_linux:
            - hostname
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - connection_timeout
            - execution_timeout
            - installation_file
            - service_account
            - service_name
            - service_password
            - private_key_file
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: configure_postgres
          - POSTGRES_START_FAILURE: FAILURE
          - POSTGRES_PROCESS_CHECK_FAILURE: FAILURE
          - POSTGRES_VERIFY_INSTALL_FAILURE: FAILURE
          - POSTGRES_VERIFY_RPM_FAILURE: FAILURE
          - POSTGRES_INSTALL_RPM_REPO_FAILURE: FAILURE
          - POSTGRES_INSTALL_PACKAGE_FAILURE: FAILURE
          - POSTGRES_INIT_DB_FAILURE: FAILURE

    - configure_postgres:
        do:
          postgres.linux.configure_postgres_on_linux:
            - hostname
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - connection_timeout
            - execution_timeout
            - installation_file
            - service_account
            - service_name
            - service_password
            - private_key_file
            - listen_addresses
            - port
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
            - reboot
            - temp_local_folder
            - pg_ctl_location
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: create_database
          - FAILURE: FAILURE

    - create_database:
        do:
          postgres.linux.create_db_on_linux:
            - hostname
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - connection_timeout
            - execution_timeout
            - installation_file
            - service_account
            - service_name
            - service_password
            - private_key_file
            - db_username: ${service_account}
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
          postgres.linux.operate_postgres_on_linux:
            - hostname
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - connection_timeout
            - execution_timeout
            - installation_file
            - service_account
            - service_name
            - service_password
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
          postgres.linux.operate_postgres_on_linux:
            - hostname
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - connection_timeout
            - execution_timeout
            - installation_file
            - service_account
            - service_name
            - service_password
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
          postgres.linux.operate_postgres_on_linux:
            - hostname
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - connection_timeout
            - execution_timeout
            - installation_file
            - service_account
            - service_name
            - service_password
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
          postgres.linux.drop_db_on_linux:
            - hostname
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - connection_timeout
            - execution_timeout
            - installation_file
            - service_account
            - service_name
            - service_password
            - private_key_file
            - db_username: ${service_account}
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
    - return_result
    - return_code
    - exception
  results:
    - SUCCESS
    - FAILURE
