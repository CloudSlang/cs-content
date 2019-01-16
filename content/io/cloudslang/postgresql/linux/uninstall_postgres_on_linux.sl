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
#! @description: Performs uninstall postgresql on machines that are running. It also remove 'data' on Linux
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
#! @input private_key_file: Absolute path to private key file
#!                          Optional
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output return_code: '0' if success, '-1' otherwise
#! @output exception: contains the stack trace in case of an exception
#! @output standard_err: STDERR of the machine in case of successful request, null otherwise
#!
#! @result SUCCESS: Postgresql uninstalled successfully
#! @result FAILURE: There was an error during uninstalling postgresql
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.linux

imports:
  ssh: io.cloudslang.base.ssh
  remote: io.cloudslang.base.remote_file_transfer
  folders: io.cloudslang.base.os.linux.folders
  strings: io.cloudslang.base.strings
  postgres: io.cloudslang.postgresql

flow:
  name: uninstall_postgres_on_linux

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
    - service_name:
        default: 'postgresql-10'
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
          - SUCCESS: uninstall_progres

    - uninstall_progres:
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
               ${'sudo systemctl stop ' + service_name+ '; sudo systemctl disable ' + service_name +  ' ; sudo rm -fR ' + initdb_dir + ' ; sudo rm -fR /usr/' + home_dir + '/data ; sudo rm /usr/lib/systemd/system/' + service_name + '.service ; sudo yum -y erase ' + pkg_name +'*'}
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - return_result
    - return_code
    - exception
    - standard_err

  results:
    - SUCCESS
    - FAILURE
