#   (c) Copyright 2019 Micro Focus, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: Performs several powershell commands in order to deploy install postgresql application on machines that are running
#!               windows Server 2016
#!
#! @input hostname: Hostname or IP address of the target machine
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
#! @output exception: contains the stack trace in case of an exception
#!
#! @result SUCCESS: Postgresql install and/or startup was successful
#! @result DOWNLOAD_INSTALLER_MODULE_FAILURE: There was an error downloading or extracting the installer module
#! @result INSTALL_INSTALLER_MODULE_FAILURE: There was an error downloading or extracting the installer module
#! @result POSTGRES_INSTALL_PACKAGE_FAILURE: error installing postgres
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.windows

imports:
  scripts: io.cloudslang.base.powershell
  strings: io.cloudslang.base.strings

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
        required: true
        sensitive: true
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
                ${'[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;(New-Object Net.WebClient).DownloadFile(\"https://github.com/CloudSlang/cs-actions/raw/master/cs-postgres/src/main/resources/Install-Postgres.zip\",\"C:\Windows\Temp\Install-Postgres.zip\")'}
        publish:
          -  return_code
          -  return_result
          -  stderr
          -  script_exit_code
          -  exception
        navigate:
          - SUCCESS: install_installer_module
          - FAILURE: DOWNLOAD_INSTALLER_MODULE_FAILURE

    - install_installer_module:
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
                ${'(new-object -com shell.application).namespace(\"C:\Program Files\WindowsPowerShell\Modules\").CopyHere((new-object -com shell.application).namespace(\"C:\Windows\Temp\Install-Postgres.zip\").Items(),16)'}
        publish:
          -  return_code
          -  return_result
          -  stderr
          -  script_exit_code
          -  exception
        navigate:
          - SUCCESS: install_postgres
          - FAILURE: INSTALL_INSTALLER_MODULE_FAILURE

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
                ${'Import-Module Install-Postgres; Install-Postgres -User \"' + service_account + '\" -Password \"' + service_password + '\" -SuperAccount \"' + service_account + '\" -SuperPassword \"' + service_password + '\" -InstallerUrl \"' + installation_file + '\" -InstallPath \"' + installation_location + '\" -DataPath \"' + data_dir + '\" -Locale \"' + locale + '\" -Port ' + server_port + ' -ServiceName \"' + service_name + '\" -CreateShortcuts ' + '1' if (create_shortcuts) else '0' + ' -DebugLevel \"' + debug_level + '\" -DebugTrace \"' + debug_trace + '\" -ExtractOnly ' + '1' if (extract_only) else '0' + ' -InstallerLanguage \"' + installer_language + '\" -InstallerRuntimes ' + '1' if (install_runtimes) else '0'}
        publish:
          -  return_code
          -  return_result
          -  stderr
          -  script_exit_code
          -  exception
        navigate:
          - SUCCESS: check_postgres_install_is_successful
          - FAILURE: POSTGRES_INSTALL_PACKAGE_FAILURE

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
    -  exception: ${stderr}

  results:
    - SUCCESS
    - DOWNLOAD_INSTALLER_MODULE_FAILURE
    - INSTALL_INSTALLER_MODULE_FAILURE
    - POSTGRES_INSTALL_PACKAGE_FAILURE
