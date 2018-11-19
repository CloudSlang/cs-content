########################################################################################################################
#!!
#! @description: Performs several powershell commands in order to deploy install postgresql application on machines that are running
#!               windows Server 2016
#!
#! @input hostname: hostname or IP address
#! @input port: winrm port
#! @input protocol: http or https
#! @input username: username
#! @input password: The root or priviledged account password
#! @input proxy_host: Optional - The proxy server used to access the remote machine.
#! @input proxy_port: Optional - The proxy server port.
#!                    Valid values: -1 and numbers greater than 0.
#!                    Default: '8080'
#! @input proxy_username: Optional - The user name used when connecting to the proxy.
#! @input proxy_password: Optional - The proxy server password associated with the proxy_username input value.
#! @input connection_timeout: Optional - Time in milliseconds to wait for the connection to be made.
#!                         Default value: '10000'
#! @input execution_timeout: Optional - Time in milliseconds to wait for the command to complete.
#!                 Default: '90000'
#! @input installation_file: Optional - the postgresql installation file or link - Default: 'http://get.enterprisedb.com/postgresql/postgresql-10.6-1-windows-x64.exe'
#! @input installation_location: Optional - the installation location - Default: 'C:\\Program Files\\PostgreSQL\\10.6'
#! @input data_dir: Optional - the directory where database files will reside - Default: 'C:\\Program Files\\PostgreSQL\\10.6\\data'

#! @input create_shortcuts: Optional: Flag to specify whether menu shortcuts should be created.
#!                          Valid values: true or false
#!                          Default: true
#! @input debug_level: Optional: Level of detail written to the debug_log file (debug_trace).
#!                     Valid values: 0 to 4
#!                     Default: 2
#! @input debug_trace: Optional: Log filename to troubleshoot installation problems.
#!                     Valid values: Filename with valid path.
#! @input extract_only: Optional: Flag to indicate that the installer should extract the PostgreSQL binaries without performing an installation.
#!                      Valid values: true or false
#!                      Default: false
#! @input installer_language: Optional: Installation language.
#!                            Valid values: en, es, fr
#!                            Default: en
#! @input install_runtimes: Optional: Flag to specify whether the installer should install the Microsoft Visual C++ runtime libraries.
#!                          Valid values: true or false
#!                          Default: true
#! @input super_account: The user name of the database superuser.
#!                       Default: postgres
#! @input super_password: The database superuser password.

#! @input server_port: The postgres db server port - Default: 5432
#! @input service_name: The service name
#! @input service_account: The service account
#! @input service_password: The service password
#! @input locale: The locale
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output return_code: '0' if success, '-1' otherwise
#! @output exception: contains the stack trace in case of an exception
#!
#! @result SUCCESS: Postgresql install and/or startup was successful
#! @result DOWNLOAD_INSTALLER_MODULE_FAILURE: There was an error downloading or extracting the installer module
#! @result POSTGRES_INSTALL_PACKAGE_FAILURE: error installing postgres
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql

imports:
  scripts: io.cloudslang.base.powershell
  strings: io.cloudslang.base.strings
  print: io.cloudslang.base.print

flow:
  name: install_postgres_on_windows

  inputs:
    - hostname:
        required: true
    - port:
        default: '5985'
        required: false
    - protocol:
        default: 'http'
        required: false
    - username:
        default: 'Administrator'
        sensitive: true
    - password:
        default: '9B-CIqRP@z&rzv2HP)k8bCi$oeo?86G5'
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
        default: '90'
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
    - service_account:
        default: 'postgres'
    - service_password:
        default: 'Passw0rd123!'
        required: false
    - locale:
        default: 'English, United States'
        required: false
    - create_shortcuts:
        default: 'true'
        required: false
    - debug_level:
        default: '2'
        required: false
    - debug_trace:
        default: ''
        required: false
    - extract_only:
        default: 'false'
        required: false
    - installer_language:
        default: 'en'
        required: false
    - install_runtimes:
        default: 'true'
        required: false
    - super_account:
        default: ''
        required: false
    - super_password:
        default: ''
        required: false

  workflow:
    - download_installer_module:
        do:
          scripts.powershell_script:
            - host: ${hostname}
            - port
            - protocol
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - operation_timeout: ${execution_timeout}
            - script: >
                ${'(New-Object Net.WebClient).DownloadFile(\"https://drive.google.com/uc?export=download&id=1RbJTU9-sg1hLjDz5B4p74vX8oF-oHhZH\",\"C:\Windows\Temp\Install-Postgres.zip\");(new-object -com shell.application).namespace(\"C:\Program Files\WindowsPowerShell\Modules\").CopyHere((new-object -com shell.application).namespace(\"C:\Windows\Temp\Install-Postgres.zip\").Items(),16)'}
        publish:
          -  return_code
          -  return_result
          -  stderr
          -  script_exit_code
          -  exception
        navigate:
          - SUCCESS: install_postgres
          - FAILURE: DOWNLOAD_INSTALLER_MODULE_FAILURE

    - install_postgres:
        do:
          scripts.powershell_script:
            - host: ${hostname}
            - port
            - protocol
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - operation_timeout: '600'
            - script: >
                ${'Import-Module Install-Postgres; Install-Postgres -User \"' + service_account + '\" -Password \"' + service_password + '\" -InstallerUrl \"' + installation_file + '\" -InstallPath \"' + installation_location + '\" -DataPath \"' + data_dir + '\" -Locale \"' + locale + '\" -Port ' + server_port + ' -ServiceName \"' + service_name + '\" -CreateShortcuts ' + '1' if (create_shortcuts) else '0' + ' -DebugLevel \"' + debug_level + '\" -DebugTrace \"' + debug_trace + '\" -ExtractOnly ' + '1' if (extract_only) else '0' + ' -InstallerLanguage \"' + installer_language + '\" -InstallerRuntimes ' + '1' if (install_runtimes) else '0' + ' -SuperAccount \"' + super_account + '\" -SuperPassword \"' + super_password + '\"'}
        publish:
          -  return_code
          -  return_result
          -  stderr
          -  script_exit_code
          -  exception
        navigate:
          - SUCCESS: check_postgres_install_is_successful
          - FAILURE: print_install_error

    - print_install_error:
        do:
          print.print_text:
            - text: ${stderr}
        navigate:
          - SUCCESS: POSTGRES_INSTALL_PACKAGE_FAILURE

    - check_postgres_install_is_successful:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${return_result}
            - string_to_find: 'Postgres has been installed'
        publish:
          - return_result: 'The PostgreSQL server was successfully installed'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: POSTGRES_INSTALL_PACKAGE_FAILURE

  outputs:
    -  return_code
    -  return_result
    -  stderr

  results:
    - SUCCESS
    - DOWNLOAD_INSTALLER_MODULE_FAILURE
    - POSTGRES_INSTALL_PACKAGE_FAILURE
