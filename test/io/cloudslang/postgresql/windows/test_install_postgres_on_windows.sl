########################################################################################################################
#!!
#! @description: Performs several powershell commands in order to deploy install postgresql application on machines that are running
#!               windows Server 2016
#!
#! @input hostname: Hostname or IP address of the target machine
#! @input hostname_port: The WinRM service port
#!              Default: '5985'
#!              Optional
#! @input hostname_protocol: The protocol used to connect to the WinRM service.
#!                  Valid values: 'http' or 'https'.
#!                  Optional
#! @input username: Username used to connect to the target machine
#! @input password: The root or priviledged account password
#! @input port: The WinRM service port
#!              Default: '5985'
#!              Optional
#! @input protocol: The protocol used to connect to the WinRM service.
#!                  Valid values: 'http' or 'https'.
#!                  Optional
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
#! @input installation_file: The postgresql installation file or link
#!                           Default: 'http://get.enterprisedb.com/postgresql/postgresql-10.6-1-windows-x64.exe'
#!                           Optional
#! @input installation_location: The installation location in the target machine
#!                               Default: 'C:\\Program Files\\PostgreSQL\\10.6'
#!                               Optional
#! @input data_dir: The directory where database data files will reside
#!                  Default: 'C:\\Program Files\\PostgreSQL\\10.6\\data'
#!                  Optional
#! @input create_shortcuts: Flag to specify whether menu shortcuts should be created.
#!                          Valid values: true or false
#!                          Default: true
#!                          Optional
#! @input debug_level: Level of detail written to the debug_log file (debug_trace).
#!                     Valid values: 0 to 4
#!                     Default: 2
#!                     Optional
#! @input debug_trace: Log filename to troubleshoot installation problems.
#!                     Valid values: Filename with valid path.
#!                     Optional
#! @input extract_only: Flag to indicate that the installer should extract the PostgreSQL binaries without performing an installation.
#!                      Valid values: true or false
#!                      Default: false
#!                      Optional
#! @input installer_language: Installation language.
#!                            Valid values: en, es, fr
#!                            Default: en
#!                            Optional
#! @input install_runtimes: Flag to specify whether the installer should install the Microsoft Visual C++ runtime libraries.
#!                          Valid values: true or false
#!                          Default: true
#!                          Optional
#! @input server_port: The postgres db server port
#!                     Default: '5432'
#!                     Optional
#! @input service_name: The service name
#!                      Default: 'postgresql'
#! @input service_account: The service account
#!                         Default: 'postgres'
#! @input service_password: The service password
#!                          Optional
#! @input locale: The locale
#!                Default: 'English, United States'
#!                Optional
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output return_code: '0' if success, '-1' otherwise
#! @output stderr: contains the stack trace in case of an exception
#!
#! @result SUCCESS: Postgresql install and/or startup was successful
#! @result DOWNLOAD_INSTALLER_MODULE_FAILURE: There was an error downloading or extracting the installer module
#! @result POSTGRES_INSTALL_PACKAGE_FAILURE: error installing postgres
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.windows

imports:
  scripts: io.cloudslang.base.powershell
  strings: io.cloudslang.base.strings
  postgres: io.cloudslang.postgresql

flow:
  name: test_install_postgres_on_windows

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
        required: true
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
        default: '10'
    - execution_timeout:
        default: '900'
    - installation_file:
        default: 'http://get.enterprisedb.com/postgresql/postgresql-10.6-1-windows-x64.exe'
        required: false
    - installation_location:
        default: 'C:\\Program Files\\PostgreSQL\\10.6'
        required: false
    - data_dir:
        default: 'C:\\Program Files\\PostgreSQL\\10.6\\data'
        required: false
    - server_port:
        default: '5432'
        required: false
    - service_name:
        default: 'postgresql'
        required: false
    - service_account:
        required: true
    - service_password:
        required: true
        sensitive: true
    - locale:
        required: false
    - create_shortcuts:
        required: false
    - debug_level:
        required: false
    - debug_trace:
        required: false
    - extract_only:
        required: false
    - installer_language:
        required: false
    - install_runtimes:
        required: false

  workflow:
    - check_postgress_is_running:
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
           - exception
           - return_code
           - return_result
        navigate:
          - SUCCESS: POSTGRES_ALREADY_EXISTS
          - FAILURE: verify

    - verify:
          do:
            strings.string_occurrence_counter:
              - string_in_which_to_search: ${return_result}
              - string_to_find: 'State     : Running'
          navigate:
            - SUCCESS: parse_xml_exception
            - FAILURE: installer_postgres

    - installer_postgres:
        do:
          postgres.windows.install_postgres_on_windows:
             - hostname
             - port: ${hostname_port}
             - protocol: ${hostname_protocol}
             - username
             - password
             - proxy_host
             - proxy_port
             - proxy_username
             - proxy_password
             - connection_timeout
             - execution_timeout
             - installation_file
             - installation_location
             - data_dir
             - server_port
             - service_name
             - service_account
             - service_password
             - locale
             - create_shortcuts
             - debug_level
             - debug_trace
             - extract_only
             - installer_language
             - install_runtimes
        publish:
            -  return_code
            -  installer_return_result: ${return_result}
            -  exception
            -  installer_exception: ${exception}
            -  print_install_error
        navigate:
          - SUCCESS: check_postgres_version
          - DOWNLOAD_INSTALLER_MODULE_FAILURE: parse_xml_exception
          - POSTGRES_INSTALL_PACKAGE_FAILURE: parse_xml_exception

    - parse_xml_exception:
         do:
            parse_powershell_xml_object:
               - xml_object: ${get('exception', '')}
         publish:
             - exception_from_xml: ${exception_message}
         navigate:
            - SUCCESS: uninstall_postgres

    - check_postgres_version:
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
                    ${'$env:PGPASSWORD=\''+ service_password +'\';Set-Location -Path \"' + installation_location+'\\\\bin\"; $psql = get-command .\\psql.exe; $user =\''+ service_account +'\'; & $psql -U $user --version'}
            publish:
                - return_code
                - installed_postgres_version: ${return_result.replace('\r', '')}
                - exception
            navigate:
                - SUCCESS: uninstall_postgres
                - FAILURE: uninstall_postgres

    - uninstall_postgres:
        do:
          postgres.windows.uninstall_postgres_on_windows:
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
            - service_account
            - service_password
            - installation_location
            - data_dir
        publish:
            - return_code
            - return_result
            - exception
        navigate:
            - SUCCESS: SUCCESS
            - FAILURE: FAILURE

  outputs:
    - return_code
    - return_result
    - exception
    - installed_postgres_version
    - exception_from_xml: ${get('exception_from_xml', '')}
    - installer_exception: ${get('installer_exception', '')}
    - installer_return_result: ${get('installer_return_result', '').strip()}

  results:
    - SUCCESS
    - FAILURE
    - POSTGRES_ALREADY_EXISTS
