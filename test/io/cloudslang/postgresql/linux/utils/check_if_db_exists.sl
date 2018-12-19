########################################################################################################################
#!!
#! @description: Check whether a postgresql database exists
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
#! @input db_name: Specifies the name of the database
#! @input private_key_file: Absolute path to private key file
#!                          Optional
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output return_code: '0' if success, '-1' otherwise
#! @output exception: contains the stack trace in case of an exception
#!
#! @result SUCCESS: The result of a flow
#! @result FAILURE: error
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.linux.utils

imports:
  strings: io.cloudslang.base.strings
  math: io.cloudslang.base.math
  postgres: io.cloudslang.postgresql
  ssh: io.cloudslang.base.ssh

flow:
  name: check_if_db_exists

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
    - db_name:
       required: true
    - private_key_file:
        required: false
  workflow:
    - check_host_prereqeust:
         do:
            ssh.ssh_flow:
              - host: ${hostname}
              - port: '22'
              - username
              - password
              - proxy_host
              - proxy_port
              - proxy_username
              - proxy_password
              - connect_timeout: ${connection_timeout}
              - timeout: ${execution_timeout}
              - private_key_file
              - command: >
                  ${'sudo su - postgres -c \"psql -A -t -c \\\"select count(datname) from pg_catalog.pg_database where datname = \''+ db_name +  '\';\\\"\"'}
         publish:
            - return_code
            - return_result
            - exception
            - standard_err
            - standard_out
            - test: ${return_result}
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
  results:
    - DB_EXIST
    - DB_NOT_EXIST
    - FAILURE