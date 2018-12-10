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
#! @output  operation_return_result: STDOUT of the operation flow in case of success or the cause of the error in case of exception
#! @output  operation_exception: contains the stack trace of operation flow in case of an exception
#! @output  service_status: 'enabled' or 'disabled'
#! @output  command_return_code: '0' if success, '-1'/'1' otherwise
#! @output  operation_return_code: '0' if success, '-1'/'1' otherwise
#! @output  current_process_id: Current postgres process id
#! @output  prev_process_id: Process Id before calling operation flow
#! @output  is_proccess_id_changed: true if process id was changed
#!
#! @result SUCCESS: Operation was executed successfully
#! @result FAILURE: There was an error
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.windows

imports:
  postgres: io.cloudslang.postgresql

flow:
  name: test_operate_postgres_on_windows

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
    - check_host_prerequest:
        do:
          postgres.windows.utils.check_postgres_is_up:
            - hostname
            - hostname_port
            - hostname_protocol
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - execution_timeout
            - service_name
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
          postgres.windows.operate_postgres_on_windows:
            - hostname
            - hostname_port
            - hostname_protocol
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
            - operation
            - start_on_boot
            - private_key_file
        publish:
            - return_result
            - exception
            - command_return_code
            - return_code
            - operation_return_code: ${return_code}
            - operation_return_result: ${return_result}
            - operation_exception: ${exception}

    - check_host_postrequest:
        do:
          postgres.windows.utils.check_postgres_is_up:
            - hostname
            - hostname_port
            - hostname_protocol
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
        publish:
          - current_process_id: ${process_id}
          - service_status: ${return_result.splitlines()[3].split(':')[1].strip() if return_result is not None and 'StartMode' in return_result else ""}
        navigate:
            - SUCCESS: SUCCESS
            - FAILURE: start_postgres_postrequest

    - start_postgres_postrequest:
        do:
          postgres.windows.operate_postgres_on_windows:
            - hostname
            - hostname_port
            - hostname_protocol
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
            - operation: 'start'
            - start_on_boot
            - private_key_file
  outputs:
    - return_result
    - exception
    - command_return_code
    - return_code
    - operation_return_code: ${get(operation_return_code,'')}
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