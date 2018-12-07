########################################################################################################################
#!!
#! @description: The flow verifies that 'drop_db_on_linux' flow works correctly.
#!               Logical steps:
#!                  - check_host_prerequest
#!                  - call postgres.linux.create_db_on_linux flow
#!                  - call postgres.linux.drop_db_on_linux flow
#!                  - verify if db exists
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
#! @input installation_location: The postgresql installation location
#!                           Default: '/var/lib/pgsql/10'
#! @input pg_ctl_location: Path of the pg_ctl binay
#!                         Default: '/usr/pgsql-10/bin'
#! @input db_name: Specifies the name of the database to be dropped
#! @input db_echo: Echo the commands that dropdb generates and sends to the server
#!              Valid values: 'true', 'false'
#!              Default value: 'true'
#! @input private_key_file: Absolute path to private key file
#!                          Optional
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output return_code: '0' if success, '-1' otherwise
#! @output exception: contains the stack trace in case of an exception
#!
#! @result SUCCESS: The result of a flow
#! @result FAILURE: error
#! @result DB_IS_NOT_CLEAN: Database exists
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.linux

imports:
  base: io.cloudslang.base.cmd
  ssh: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils
  postgres: io.cloudslang.postgresql
  print: io.cloudslang.base.print

flow:
  name: test_drop_db_on_linux

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
    - pg_ctl_location:
        default: '/usr/pgsql-10/bin'
    - db_name:
        required: true
    - db_echo:
        default: 'true'
    - private_key_file:
        required: false
  workflow:
    - check_host_prereqeust:
         do:
            postgres.linux.utils.check_if_db_exists:
              - hostname
              - username
              - password
              - proxy_host
              - proxy_port
              - proxy_username
              - proxy_password
              - connection_timeout
              - execution_timeout
              - db_name
              - private_key_file
         publish:
            - return_code
            - return_result
            - exception
         navigate:
            - DB_EXIST: DB_IS_NOT_CLEAN
            - DB_NOT_EXIST: create_db
            - FAILURE: FAILURE

    - create_db:
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
            - installation_location
            - pg_ctl_location
            - db_name
            - db_description
            - db_tablespace
            - db_encoding
            - db_locale
            - db_owner
            - db_template
            - db_echo
            - private_key_file
        publish:
          - return_result
          - exception
          - return_code
        navigate:
          - SUCCESS: drop_db
          - FAILURE: FAILURE

    - drop_db:
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
              - installation_location
              - pg_ctl_location
              - db_name
              - db_echo
              - private_key_file
         publish:
             - return_result
             - exception
             - return_code
         navigate:
          - SUCCESS: verify
          - FAILURE: FAILURE
    - verify:
         do:
            postgres.linux.utils.check_if_db_exists:
              - hostname
              - username
              - password
              - proxy_host
              - proxy_port
              - proxy_username
              - proxy_password
              - connection_timeout
              - execution_timeout
              - db_name
              - private_key_file
         publish:
            - return_code
            - return_result
            - exception
         navigate:
            - DB_EXIST: FAILURE
            - DB_NOT_EXIST: SUCCESS
            - FAILURE: FAILURE

  outputs:
    - return_result
    - exception
    - return_code
  results:
    - SUCCESS
    - FAILURE
    - DB_IS_NOT_CLEAN
