########################################################################################################################
#!!
#! @description: The flow allows modification of the configuration of the PostgreSQL database. It modifies the files
#!               postgresql.conf and pg_hba.conf.
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
#! @input proxy_host: The proxy server used to access the remote machine.
#!                    Optional
#! @input proxy_port: The proxy server port.
#!                    Valid values: -1 and numbers greater than 0.
#!                    Optional
#! @input proxy_username: The user name used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input execution_timeout: Time in seconds to wait for the command to complete.
#!                           Default: '90'
#!                           Optional
#! @input listen_addresses: Changes the address where the PostgreSQL database listens.
#!                          Default: 'localhost'
#!                          Optional
#! @input port: The port the PostgreSQL database should listen.
#!              Default: '5432'
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
#! @input configuration_file: The full path to the PostgreSQL configuration file in the local machine to be applied to server.
#!                            Optional
#! @input allowed_hosts: A wildcard or a comma-separated list of hostnames or IPs (IPv4 or IPv6).
#!                       Optional
#! @input allowed_users: A comma-separated list of PostgreSQL users. If no value is specified for this input, all users will have access to the server.
#!                       Optional
#! @input installation_location: The full path to the location where PostgreSQL was installed.
#!                               Default: 'C:\\Program Files\\PostgreSQL\\10.6'
#!                               Optional
#! @input data_dir: The full path to the directory where database data files reside
#!                  Default: 'C:\\Program Files\\PostgreSQL\\10.6\\data'
#!                  Optional
#! @input reboot: A flag to indicate if server should be restart after configuration.
#!                Valid values: 'yes' or 'no'
#!                Default: 'no'
#!                Optional
#! @input private_key_file: The absolute path to a private key file
#!                          Optional
#! @input temp_local_dir: The local folder to keep files downloaded from remote host. Use relative path to support different platforms. If the folder doesn't exist, it'll be created.
#!                        Default: '/tmp'
#!                        Optional
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output return_code: '0' if success, '-1' otherwise
#! @output exception: contains the stack trace in case of an exception
#!
#! @result SUCCESS: Postgresql configuration was modified successfully
#! @result FAILURE: There was an error modifying postgresql configuration
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.windows

imports:
  scripts: io.cloudslang.base.powershell
  strings: io.cloudslang.base.strings
  print: io.cloudslang.base.print
  utils: io.cloudslang.base.utils
  cmd: io.cloudslang.base.cmd
  rft: io.cloudslang.base.remote_file_transfer
  fs: io.cloudslang.base.filesystem
  postgres: io.cloudslang.postgresql

flow:
  name: configure_postgres_on_windows

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
        default: '90'
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
        required: false
    - allowed_users:
        required: false
    - installation_location:
        default: 'C:\\Program Files\\PostgreSQL\\10.6'
    - data_dir:
        default: 'C:\\Program Files\\PostgreSQL\\10.6\\data'
    - reboot:
        default: 'no'
        required: false
    - private_key_file:
        required: true
    - temp_local_dir:
        default: '/tmp'
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
                ${'Test-Path -Path "'+ installation_location +'"'}
        publish:
          -  return_code
          -  return_result
          -  stderr
          -  script_exit_code
          -  exception
        navigate:
          - SUCCESS: check_installation_location_result
          - FAILURE: FAILURE

    - check_installation_location_result:
        do:
          utils.is_true:
            - bool_value: ${return_result}
        publish:
          - return_result: 'The installation location was not found.'
        navigate:
          - 'TRUE': check_data_dir
          - 'FALSE': FAILURE

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
                ${'Test-Path -Path "'+ data_dir +'"'}
        publish:
          -  return_code
          -  return_result
          -  stderr
          -  script_exit_code
          -  exception
        navigate:
          - SUCCESS: check_data_dir_result
          - FAILURE: FAILURE

    - check_data_dir_result:
        do:
          utils.is_true:
            - bool_value: ${return_result}
        publish:
          - return_result: 'The data_dir was not found.'
        navigate:
          - 'TRUE': create_temp_dir_if_not_exist
          - 'FALSE': FAILURE

    - create_temp_dir_if_not_exist:
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
                ${'$homeDir = "$Home"; New-Item -Force -Name tmp -Path $homeDir -ItemType Directory;'}
        publish:
          -  return_code
          -  return_result
          -  script_exit_code
          -  exception: ${stderr}
        navigate:
          - SUCCESS: check_configuration_file_value
          - FAILURE: FAILURE

    - check_configuration_file_value:
        do:
           utils.is_null:
            - variable: ${configuration_file}
        navigate:
          - IS_NULL: check_if_temp_local_dir_exists
          - IS_NOT_NULL: check_if_configuration_file_exists

    - check_if_temp_local_dir_exists:
        do:
          fs.create_folder:
            - folder_name: ${temp_local_dir}
        publish:
          - temp_local_dir_exists_message: ${message}
        navigate:
           - SUCCESS: copy_configuration_files_to_temp_dir
           - FAILURE: check_if_temp_local_dir_exists_result

    - check_if_temp_local_dir_exists_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${temp_local_dir_exists_message}
            - string_to_find: 'folder already exists'
        publish:
          - return_result
          - exception: ${get('temp_local_dir_exists_message', '')}
        navigate:
          - SUCCESS: copy_configuration_files_to_temp_dir
          - FAILURE: FAILURE

    - check_if_configuration_file_exists:
        do:
          fs.read_from_file:
            - file_path: ${configuration_file}
        publish:
            - exception: ${message}
            - return_result
        navigate:
            - SUCCESS: upload_configuration_file_to_temp_dir
            - FAILURE: FAILURE

    - upload_configuration_file_to_temp_dir:
        do:
           cmd.run_command:
               - command: >
                  ${'scp -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=QUIET -i ' + private_key_file + ' \"' + configuration_file + '\" ' + username + '@'+ hostname+':/C:/Users/'+username+'/tmp'}
        publish:
             - return_result: ''
             - exception: ${error_message}
             - return_code
        navigate:
          - SUCCESS: move_file_to_data_dir
          - FAILURE: FAILURE

    - move_file_to_data_dir:
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
                ${'$tmpDir = \"$Home\\tmp\\*.conf";Move-Item -Path "$tmpDir" -Destination \"'+ data_dir +'\" -Force;Get-Acl -Path "'+ data_dir +'\\\\PG_VERSION" | Set-Acl -Path \"'+ data_dir +'\\\\postgresql.conf";Get-Acl -Path "'+ data_dir +'\\\\PG_VERSION" | Set-Acl -Path \"' + data_dir +'\\\\pg_hba.conf";'}
        publish:
          -  return_code
          -  return_result
          -  exception
          -  stderr
        navigate:
          - SUCCESS: need_reboot_postgres
          - FAILURE: FAILURE

    - copy_configuration_files_to_temp_dir:
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
                ${'$tmpDir = \"$Home\\tmp"; Copy-Item -Path \"'+ data_dir + '\\\\postgresql.conf\" -Destination "$tmpDir" -Force;Copy-Item -Path \"'+ data_dir +'\\\\pg_hba.conf\" -Destination "$tmpDir" -Force;'}
        publish:
          -  return_code
          -  return_result
          -  exception
          -  stderr
        navigate:
          - SUCCESS: download_configuration_files_to_temp_local_dir
          - FAILURE: FAILURE

    - download_configuration_files_to_temp_local_dir:
        do:
           cmd.run_command:
             - command: >
                ${'scp -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=QUIET -i ' + private_key_file +' ' + username + '@'+ hostname +':/C:/Users/'+ username+'/tmp/postgresql.conf \"' + temp_local_dir + '\"'
                ' && scp -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=QUIET -i ' + private_key_file +' ' +  username + '@'+ hostname + ':/C:/Users/' + username +'/tmp/pg_hba.conf \"' + temp_local_dir +'\"'}
        publish:
          - exception : ${error_message}
          - return_code
        navigate:
          - SUCCESS: update_postgresql_conf
          - FAILURE: FAILURE

    - update_postgresql_conf:
        do:
           postgres.common.update_postgres_config:
             - file_path: ${temp_local_dir + '/postgresql.conf'}
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
           - SUCCESS: upload_updated_postgres_conf_to_data_dir
           - FAILURE: FAILURE

    - upload_updated_postgres_conf_to_data_dir:
        do:
           cmd.run_command:
             - command: >
                ${'scp -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=QUIET -i ' + private_key_file + ' \"' + temp_local_dir + '/postgresql.conf\" ' + username + '@'+ hostname + ':/C:/Users/'+username+'/tmp'}
        publish:
          - exception : ${error_message}
          - return_code
        navigate:
          - SUCCESS: update_pg_hba_conf
          - FAILURE: FAILURE

    - update_pg_hba_conf:
        do:
           postgres.common.update_pg_hba_config:
              - file_path: ${temp_local_dir + '/pg_hba.conf'}
              - allowed_hosts: ${allowed_hosts}
              - allowed_users: ${allowed_users}
        publish:
            - return_result
            - return_code
            - exception: ${stderr}
        navigate:
           - SUCCESS: upload_updated_pg_hba_conf_to_data_dir
           - FAILURE: FAILURE

    - upload_updated_pg_hba_conf_to_data_dir:
        do:
           cmd.run_command:
             - command: >
                 ${'scp -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=QUIET -i ' + private_key_file + ' \"' + temp_local_dir + '/pg_hba.conf\" ' + username + '@'+ hostname + ':/C:/Users/'+username+'/tmp'}
        publish:
          - exception : ${error_message}
          - return_code
        navigate:
          - SUCCESS: move_file_to_data_dir
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
                ${'$dl_path=\"' + data_dir +'\"; $il_path=\"' + installation_location +'\\\\bin\\\\pg_ctl.exe\"; & "$il_path" -s -D "$dl_path" restart;'}
        publish:
          -  return_code
          -  return_result
          -  script_exit_code
          -  exception: ${stderr}
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
