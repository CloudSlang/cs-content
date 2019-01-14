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
  ssh: io.cloudslang.base.ssh
  remote: io.cloudslang.base.remote_file_transfer
  folders: io.cloudslang.base.os.linux.folders
  groups: io.cloudslang.base.os.linux.groups
  users: io.cloudslang.base.os.linux.users
  strings: io.cloudslang.base.strings
  postgres: io.cloudslang.postgresql

flow:
  name: install_postgres_on_linux

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
    - installation_file:
        default: 'https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-redhat10-10-2.noarch.rpm'
        required: false
    - service_account:
        default: 'postgres'
    - service_name:
        default: 'postgresql-10'
    - service_password:
        required: true
        sensitive: true
    - private_key_file:
        required: false

  workflow:
    - derive_postgres_version:
        do:
          postgres.linux.utils.derive_postgres_version:
            - service_name
        publish:
          - pkg_name
          - home_dir
          - initdb_dir
          - setup_file
        navigate:
          - SUCCESS: verify_if_postgres_is_running

    - verify_if_postgres_is_running:
        do:
          ssh.ssh_flow:
            - host: ${hostname}
            - port: '22'
            - username
            - password
            - private_key_file
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - timeout: ${execution_timeout}
            - connect_timeout: ${connection_timeout}
            - command: >
                ${'systemctl status ' + service_name + '.service | tail -1'}
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          - SUCCESS: check_postgres_is_running
          - FAILURE: POSTGRES_PROCESS_CHECK_FAILURE

    - check_postgres_is_running:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${standard_out}
            - string_to_find: 'Started'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: verify_if_postgres_is_installed
          # - FAILURE: POSTGRES_PROCESS_CHECK_FAILURE

    - verify_if_postgres_is_installed:
        do:
          ssh.ssh_flow:
            - host: ${hostname}
            - port: '22'
            - username
            - password
            - private_key_file
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - timeout: ${execution_timeout}
            - connect_timeout: ${connection_timeout}
            - command: >
                ${'export LC_ALL=\"en_US.UTF-8\" && sudo yum list installed | grep ' + pkg_name + ' | cut -d \".\" -f1'}
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          - SUCCESS: check_postgres_is_installed_result
          - FAILURE: POSTGRES_VERIFY_INSTALL_FAILURE

    - check_postgres_is_installed_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${standard_out}
            - string_to_find: ${pkg_name + '-server'}
        navigate:
          - SUCCESS: start_postgres
          - FAILURE: verify_if_rpms_are_locally_available

    - verify_if_rpms_are_locally_available:
        do:
          ssh.ssh_flow:
            - host: ${hostname}
            - port: '22'
            - username
            - password
            - private_key_file
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - timeout: ${execution_timeout}
            - connect_timeout: ${connection_timeout}
            - command: >
                ${'rpm -qa | grep ' + pkg_name + ' | cut -d "." -f1'}
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          - SUCCESS: check_rpm_exist_result
          - FAILURE: POSTGRES_VERIFY_RPM_FAILURE

    - check_rpm_exist_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${standard_out}
            - string_to_find: ${pkg_name + '-server'}
        navigate:
          - SUCCESS: install_server_packages
          - FAILURE: install_repository_rpm

    - install_repository_rpm:
        do:
          ssh.ssh_flow:
            - host: ${hostname}
            - port: '22'
            - username
            - password
            - private_key_file
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - timeout: ${execution_timeout}
            - connect_timeout: ${connection_timeout}
            - command: >
                ${'export LC_ALL=\"en_US.UTF-8\" && sudo yum -y -q install ' + installation_file}
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
          - exception: ${standard_err}
        navigate:
          - SUCCESS: install_server_packages
          - FAILURE: check_rpm_install_error

    - check_rpm_install_error:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${standard_err}
            - string_to_find: 'Nothing to do'
        navigate:
          - SUCCESS: install_server_packages
          - FAILURE: POSTGRES_INSTALL_RPM_REPO_FAILURE

    - install_server_packages:
        do:
          ssh.ssh_flow:
            - host: ${hostname}
            - port: '22'
            - username
            - password
            - private_key_file
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - timeout: ${execution_timeout}
            - connect_timeout: ${connection_timeout}
            - command: >
                ${'export LC_ALL=\"en_US.UTF-8\" && sudo yum -y install ' + pkg_name + '-server ' + pkg_name + '-contrib'}
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          - SUCCESS: initialize_db
          - FAILURE: POSTGRES_INSTALL_PACKAGE_FAILURE

    - initialize_db:
        do:
          ssh.ssh_flow:
            - host: ${hostname}
            - port: '22'
            - username
            - password
            - private_key_file
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - timeout: ${execution_timeout}
            - connect_timeout: ${connection_timeout}
            - command: >
                ${'sudo rm -fR ' + initdb_dir + '/data && sudo /usr/' + home_dir + '/bin/' + setup_file + ' initdb'}
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          - SUCCESS: check_postgres_db_initialized
          - FAILURE: POSTGRES_INIT_DB_FAILURE

    - check_postgres_db_initialized:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${standard_out}
            - string_to_find: 'Initializing database ... OK'
        publish:
          - return_result
        navigate:
          - SUCCESS: start_postgres
          - FAILURE: POSTGRES_INIT_DB_FAILURE

    - start_postgres:
        do:
          ssh.ssh_flow:
            - host: ${hostname}
            - port: '22'
            - username
            - password
            - private_key_file
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - timeout: ${execution_timeout}
            - connect_timeout: ${connection_timeout}
            - command: >
                ${'sudo systemctl enable ' + service_name + ' && sudo systemctl start ' + service_name + ' && sleep 15s && sudo systemctl status ' + service_name + ' | tail -1'}
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          - SUCCESS: check_postgres_has_started
          - FAILURE: POSTGRES_START_FAILURE

    - check_postgres_has_started:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${standard_out}
            - string_to_find: 'Started'
        publish:
          - return_result: 'The PostgreSQL server was successfully installed'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: POSTGRES_START_FAILURE


  outputs:
    - return_result
    - return_code
    - exception

  results:
    - SUCCESS
    - POSTGRES_PROCESS_CHECK_FAILURE
    - POSTGRES_VERIFY_INSTALL_FAILURE
    - POSTGRES_VERIFY_RPM_FAILURE
    - POSTGRES_INSTALL_RPM_REPO_FAILURE
    - POSTGRES_INSTALL_PACKAGE_FAILURE
    - POSTGRES_INIT_DB_FAILURE
    - POSTGRES_START_FAILURE
