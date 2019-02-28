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
#! @description: The flow allows modification of the configuration of the PostgreSQL database. It modifies the files
#!               postgresql.conf and pg_hba.conf.
#!
#! @input hostname: Hostname or IP address of the target machine
#! @input username: Username used to connect to the target machine
#! @input password: The root or priviledged account password
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
#! @input listen_addresses: Changes the address where the PostgreSQL database listens.
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
#! @input private_key_file: Absolute path to private key file
#!                          Optional
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
#! @result SUCCESS: Postgresql configuration was modified successfully
#! @result FAILURE: There was an error modifying postgresql configuration
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.linux

imports:
  base: io.cloudslang.base.cmd
  ssh: io.cloudslang.base.ssh
  rft: io.cloudslang.base.remote_file_transfer
  remote: io.cloudslang.base.remote_file_transfer
  folders: io.cloudslang.base.os.linux.folders
  groups: io.cloudslang.base.os.linux.groups
  users: io.cloudslang.base.os.linux.users
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils
  postgres: io.cloudslang.postgresql

flow:
  name: configure_postgres_on_linux

  inputs:
    - hostname:
        required: true
    - username:
        sensitive: true
        required: true
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
        default: '/var/lib/pgsql/10'
    - reboot:
        default: 'no'
        required: false
    - private_key_file:
        required: false
    - temp_local_folder:
        default: '/tmp'
        required: false
    - pg_ctl_location:
        default: '/usr/pgsql-10/bin'
        required: false

  workflow:
    - check_installation_path:
        do:
          ssh.ssh_flow:
            - host: ${hostname}
            - port: '22'
            - username
            - password
            - private_key_file
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - timeout: ${execution_timeout}
            - connect_timeout: ${connection_timeout}
            - command: >
                ${'sudo -u postgres [ -d ' + installation_location + '/data ] && echo "true" || echo "false"'}
        publish:
          - standard_out
          - return_code
        navigate:
          - SUCCESS: verify_installation_path
          - FAILURE: FAILURE

    - verify_installation_path:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${standard_out}
            - string_to_find: 'true'
        navigate:
          - SUCCESS: check_configuration_file_value
          - FAILURE: FAILURE

    - check_configuration_file_value:
        do:
           utils.is_null:
            - variable: ${configuration_file}
        navigate:
          - IS_NULL: copy_configs_from_installation_location_to_user_folder
          - IS_NOT_NULL: upload_local_configuration_file_to_user_folder

    # user don't have permission to any postgres config files. Copy the files using 'sudo cp' to his folder and give the rw access
    - copy_configs_from_installation_location_to_user_folder:
          do:
            ssh.ssh_flow:
              - host: ${hostname}
              - port: '22'
              - username
              - password
              - private_key_file
              - proxy_host
              - proxy_port
              - proxy_username
              - proxy_password
              - timeout: ${execution_timeout}
              - connect_timeout: ${connection_timeout}
              - command: >
                  ${'mkdir -p ~/temp && sudo cp -a '+ installation_location  +'/data/postgresql.conf ~/temp  && sudo chmod 777 '+ '~/temp/postgresql.conf && sudo cp -a '+ installation_location  +'/data/pg_hba.conf ~/temp && sudo chmod 664 '+ '~/temp/pg_hba.conf && sudo chown ' + username + ' ~/temp/*' }
          publish:
            - return_result
            - standard_err
            - standard_out
            - return_code
            - command_return_code
          navigate:
            - SUCCESS: download_postgres_conf_to_temp_local_folder
            - FAILURE: FAILURE

    - download_postgres_conf_to_temp_local_folder:
        do:
          rft.remote_secure_copy:
            - source_path: ${'./temp/postgresql.conf'}
            - source_host: ${hostname}
            - source_port: '22'
            - source_username: ${username}
            - source_password: ${password if private_key_file is None else None}
            - source_private_key_file: ${private_key_file}
            - destination_path: ${temp_local_folder + '/postgresql.conf'}
        navigate:
          - SUCCESS: download_hba_conf_to_temp_local_folder
          - FAILURE: FAILURE

    - download_hba_conf_to_temp_local_folder:
        do:
          rft.remote_secure_copy:
            - source_path: ${'./temp/pg_hba.conf'}
            - source_host: ${hostname}
            - source_port: '22'
            - source_username: ${username}
            - source_password: ${password if private_key_file is None else None}
            - source_private_key_file: ${private_key_file}
            - destination_path: ${temp_local_folder + '/pg_hba.conf'}
        navigate:
          - SUCCESS: update_postgres_conf
          - FAILURE: FAILURE

    - upload_local_configuration_file_to_user_folder:
        do:
          rft.remote_secure_copy:
            - source_path: ${configuration_file}
            - destination_host: ${hostname}
            - destination_path: ${'./temp/' + configuration_file}
            - destination_port: '22'
            - destination_username: ${username}
            - destination_password: ${password if private_key_file is None else None}
            - destination_private_key_file: ${private_key_file}
        navigate:
          - SUCCESS: change_permission_and_move_file_to_postgress_installation_location
          - FAILURE: FAILURE

    - update_postgres_conf:
        do:
           postgres.common.update_postgres_config:
             - file_path: ${temp_local_folder + '/postgresql.conf'}
             - listen_addresses: ${listen_addresses}
             - port: ${port}
             - ssl: ${ssl}
             - ssl_ca_file: ${ssl_ca_file}
             - ssl_cert_file: ${ssl_cert_file}
             - ssl_key_file: ${ssl_key_file}
             - max_connections: ${max_connections}
             - shared_buffers: ${shared_buffers}
             - effective_cache_size: ${effective_cache_size}
             - autovacuum: ${autovacuum}
             - work_mem: ${work_mem}
        publish:
            - return_result
            - return_code
            - exception
            - stderr
        navigate:
           - SUCCESS: update_pg_hba_config
           - FAILURE: FAILURE


    - update_pg_hba_config:
        do:
           postgres.common.update_pg_hba_config:
              - file_path: ${temp_local_folder + '/pg_hba.conf'}
              - allowed_hosts: ${allowed_hosts}
              - allowed_users: ${allowed_users}
        publish:
            - return_result
            - return_code
            - exception
            - stderr
        navigate:
           - SUCCESS: upload_updated_postgres_conf_to_data_dir
           - FAILURE: FAILURE

    - upload_updated_postgres_conf_to_data_dir:
        do:
          rft.remote_secure_copy:
            - source_path: ${temp_local_folder + '/postgresql.conf'}
            - destination_host: ${hostname}
            - destination_path: ${'temp/postgresql.conf'}
            - destination_port: '22'
            - destination_username: ${username}
            - destination_password: ${password if private_key_file is None else None}
            - destination_private_key_file: ${private_key_file}
        navigate:
          - SUCCESS: upload_updated_pg_hba_conf_to_data_dir
          - FAILURE: FAILURE

    - upload_updated_pg_hba_conf_to_data_dir:
        do:
          rft.remote_secure_copy:
            - source_path: ${temp_local_folder + '/pg_hba.conf'}
            - destination_host: ${hostname}
            - destination_path: ${'temp/pg_hba.conf'}
            - destination_port: '22'
            - destination_username: ${username}
            - destination_password: ${password if private_key_file is None else None}
            - destination_private_key_file: ${private_key_file}
        navigate:
          - SUCCESS: change_permission_and_move_file_to_postgress_installation_location
          - FAILURE: FAILURE

    - change_permission_and_move_file_to_postgress_installation_location:
       do:
         ssh.ssh_flow:
           - host: ${hostname}
           - port: '22'
           - username
           - password
           - private_key_file
           - proxy_host
           - proxy_port
           - proxy_username
           - proxy_password
           - timeout: ${execution_timeout}
           - connect_timeout: ${connection_timeout}
           - command: >
               ${'sudo chgrp postgres ~/temp/*.conf  && sudo chown postgres ~/temp/*.conf  && sudo chmod 600 ~/temp/*.conf && sudo mv -f ~/temp/*.conf ' + installation_location + '/data' }
       publish:
         - return_result: ${standard_err}
         - return_code
         - command_return_code
       navigate:
         - SUCCESS: need_reboot_postgres
         - FAILURE: FAILURE

    - need_reboot_postgres:
        do:
          strings.string_equals:
            - first_string: ${reboot}
            - second_string: 'yes'
        navigate:
          - SUCCESS: reboot_postgres
          - FAILURE: SUCCESS

    - reboot_postgres:
       do:
         ssh.ssh_flow:
           - host: ${hostname}
           - port: '22'
           - username
           - password
           - private_key_file
           - proxy_host
           - proxy_port
           - proxy_username
           - proxy_password
           - timeout: ${execution_timeout}
           - connect_timeout: ${connection_timeout}
           - command: >
               ${'sudo -i -u postgres '+ pg_ctl_location + '/pg_ctl -s -D ' + installation_location  + '/data restart > /dev/null'}
       publish:
         - return_result
         - standard_err
         - standard_out
         - return_code
         - command_return_code
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
