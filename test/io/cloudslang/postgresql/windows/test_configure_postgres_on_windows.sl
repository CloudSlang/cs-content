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
  name: test_configure_postgres_on_windows

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
    - service_name:
        default: 'postgresql'
        required: true
    - service_account:
        required: true
    - service_password:
        required: true
  workflow:
    - configure:
        do:
          postgres.windows.configure_postgres_on_windows:
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
            - data_dir
            - reboot
            - private_key_file
            - temp_local_dir
            - service_name
        publish:
            - return_result
            - exception
            - return_code
            - configure_return_code: ${return_code}
            - configure_return_result: ${return_result}
            - configure_exception: ${exception}
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
                  ${'$env:PGPASSWORD=\''+service_password+'\';Set-Location -Path \"' + installation_location+'\\\\bin\"; $psql = get-command .\\psql.exe; $user =\''+ service_account +'\'; & $psql -U $user -A -t -c \"'+ sql_query + '\"'}
        publish:
            - return_code
            - return_result
            - exception
            - db_settings: ${return_result.strip().replace('\r', '')}
        navigate:
          - SUCCESS: check_host_postrequest
          - FAILURE: check_host_postrequest

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
            - return_result
            - exception
            - return_code
        navigate:
            - SUCCESS: SUCCESS
            - FAILURE: FAILURE

  outputs:
      - db_settings : ${get('db_settings', '')}
      - configure_return_code: ${return_code}
      - configure_return_result: ${return_result}
      - configure_exception: ${exception}
      - return_result
      - exception
      - return_code
  results:
      - SUCCESS
      - FAILURE
