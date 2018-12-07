########################################################################################################################
#!!
#! @description: The flow verifies that 'configure_postgres_on_linux' flow works correctly.
#!               Logical steps:
#!                  - check host prerequest
#!                  - call postgres.linux.configure_postgres_on_linux with custom parameters
#!                  - get configuration query
#!                  - verify updated postgres configuration
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
#! @result DB_IS_NOT_RUNNING: Postgres is not available
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.linux

imports:
  postgres: io.cloudslang.postgresql
  ssh: io.cloudslang.base.ssh

flow:
  name: test_configure_postgres_on_linux

  inputs:
    - hostname:
        required: true
    - username:
        sensitive: true
    - password:
        default: ''
        required: false
        sensitive: true
    - private_key_file:
        required: false
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
        default: '*'
    - allowed_users:
        default: 'postgres'
    - installation_location:
        default: '/var/lib/pgsql/10'
    - reboot:
        default: 'no'
    - temp_local_folder:
        default: '/tmp'
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
          - SUCCESS: configure
          - FAILURE: DB_IS_NOT_RUNNING

    - configure:
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
              - private_key_file
              - temp_local_folder
              - pg_ctl_location
        publish:
           - return_result
           - exception
           - return_code
        navigate:
          - SUCCESS: get_configuration_query
          - FAILURE: FAILURE

    - get_configuration_query:
        do:
          postgres.common.get_configuration_query:
        publish:
          - sql_query
        navigate:
          - SUCCESS: verify

    - verify:
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
                  ${'sudo su - postgres -c \"psql -A -t -c \\\"'+ sql_query +'\\\"\"'}
        publish:
            - return_code
            - return_result
            - exception: ${standard_err}

  outputs:
    - return_result: ${return_result.strip()}
    - exception
    - return_code
  results:
    - SUCCESS
    - FAILURE
    - DB_IS_NOT_RUNNING