########################################################################################################################
#!!
#! @description: The flow verifies that 'operate_postgres_on_linux' flow works correctly.
#!               Logical steps:
#!                 - check host prerequest(db should be running)
#!                 - call postgres.linux.operate_postgres_on_linux flow
#!                 - verify operation result
#!                 - get system service status on boot
#!                 - check host postrequest (if db is running)
#!
#! @input hostname: Hostname or IP address of the target machine
#! @input username: Username used to connect to the target machine
#! @input password: The root or priviledged account password
#! @input proxy_host: The proxy server used to access the remote machine
#!                    Optional
#! @input proxy_port: The proxy server port
#!                    Valid values: -1 and numbers greater than 0
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
#! @input	installation_location: The full path to the location where PostgreSQL was installed
#!                               Default: '/var/lib/pgsql/10/data'
#! @input	start_on_boot: A flag to indicate if server should be restart after configuration
#!                       Valid values: 'yes' or 'no'
#!                       Optional
#! @input operation: The operation to be performed
#!                   Valid values: stop, start, restart, reload
#!                   Optional
#! @input private_key_file: Absolute path to private key file
#!                          Optional
#! @input pg_ctl_location: Path of the pg_ctl binary
#!                         Default: '/usr/pgsql-10/bin'
#!                         Optional
#!
#! @output  return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output  return_code: '0' if success, '-1' otherwise
#! @output  exception: contains the stack trace in case of an exception
#! @output  operation_return_result: STDOUT of the operation flow in case of success or the cause of the error in case of exception
#! @output  operation_exception: contains the stack trace of operation flow in case of an exception
#! @output  service_status: 'enabled' or 'disabled'
#! @output  command_return_code: '0' if success, '-1'/'1' otherwise
#! @output  current_process_id: Current postgres process id
#! @output  prev_process_id: Process Id before calling operation flow
#! @output  is_proccess_id_changed: true if process id was changed
#!
#! @result SUCCESS: Operation was executed successfully
#! @result FAILURE: There was an error
#! @result DB_IS_NOT_RUNNING: postgres is not running
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.linux

imports:
  postgres: io.cloudslang.postgresql

flow:
  name: test_operate_postgres_on_linux

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
    - installation_location:
        default: '/var/lib/pgsql/10'
    - operation:
        required: false
    - start_on_boot:
        required: false
    - private_key_file:
        required: false
    - pg_ctl_location:
        default: '/usr/pgsql-10/bin'
        required: false
  workflow:
    - check_host_prerequest:
        do:
          postgres.linux.utils.check_postgres_is_up:
            - hostname
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - connection_timeout
            - execution_timeout
            - installation_location
            - pg_ctl_location
            - private_key_file
        publish:
            - return_result
            - exception
            - return_code
            - prev_process_id: ${process_id}
        navigate:
            - SUCCESS: do_operation
            - FAILURE: DB_IS_NOT_RUNNING

    - do_operation:
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
             - installation_location
             - operation
             - start_on_boot
             - private_key_file
             - pg_ctl_location
        publish:
            - return_result
            - exception
            - command_return_code
            - return_code
            - operation_exception: ${exception}
        navigate:
           - SUCCESS: verify_operation_result
           - FAILURE: check_host_postrequest

    - verify_operation_result:
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
             - installation_location
             - operation: 'status'
             - private_key_file
             - pg_ctl_location
        publish:
            - return_result
            - exception
            - command_return_code
            - return_code
            - operation_return_result: ${return_result}

    - get_system_service_status_on_boot:
        do:
          postgres.linux.utils.get_system_serive_status_on_boot:
            - hostname
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - connection_timeout
            - execution_timeout
            - installation_location
            - pg_ctl_location
            - private_key_file
        publish:
          - service_status
          - exception
          - return_code

    - check_host_postrequest:
        do:
          postgres.linux.utils.check_postgres_is_up:
            - hostname
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - connection_timeout
            - execution_timeout
            - installation_location
            - pg_ctl_location
            - private_key_file
        publish:
          - current_process_id: ${process_id}
        navigate:
            - SUCCESS: SUCCESS
            - FAILURE: start_postgres_postrequest

    - start_postgres_postrequest:
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
             - installation_location
             - operation: 'start'
             - private_key_file
             - pg_ctl_location

  outputs:
    - return_result
    - exception
    - command_return_code
    - return_code
    - operation_return_result: ${get('operation_return_result', '').strip()}
    - operation_exception: ${get('operation_exception', '').strip()}
    - service_status
    - prev_process_id
    - current_process_id
    - is_proccess_id_changed: ${ str(prev_process_id != '' and current_process_id != '' and prev_process_id != current_process_id)}
  results:
    - SUCCESS
    - FAILURE
    - DB_IS_NOT_RUNNING