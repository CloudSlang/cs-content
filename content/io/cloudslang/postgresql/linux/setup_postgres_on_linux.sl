########################################################################################################################
#!!
#! @description: Performs several linux commands in order to deploy install postgresql application on machines that are running
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
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output return_code: '0' if success, '-1' otherwise
#! @output exception: contains the stack trace in case of an exception
#!
#! @result SUCCESS: Postgresql install and/or startup was successful
#! @result POSTGRES_PROCESS_CHECK_FAILURE: There was an error checking postgresql process
#! @result POSTGRES_VERIFY_INSTALL_FAILURE: error verifying installation
#! @result POSTGRES_VERIFY_RPM_FAILURE: error verifying existence of postgresql rpm installer
#! @result POSTGRES_INSTALL_RPM_REPO_FAILURE: error installation postgresql rpm repo
#! @result POSTGRES_INSTALL_PACKAGE_FAILURE: error installing postgresql package
#! @result POSTGRES_INIT_DB_FAILURE: error initializing db
#! @result POSTGRES_START_FAILURE: error starting postgresql
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
        default: 'postgres'
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
