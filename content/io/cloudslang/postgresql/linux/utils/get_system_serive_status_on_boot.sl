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
#! @description: Get status of system service on boot
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
#!                           Default: '/var/lib/pgsql/10/data'
#! @input pg_ctl_location: Path of the pg_ctl binary
#!                         Default: '/usr/pgsql-10/bin'
#! @input private_key_file: Absolute path to private key file
#!                          Optional
#!
#! @output service_status: The status on boot
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
  name: get_system_serive_status_on_boot

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
    - private_key_file:
        required: false
  workflow:
    - get_system_serive_status_on_boot:
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
                  ${'systemctl list-unit-files --type=service | grep -i postgres| awk \'{print $2}\''}
         publish:
            - return_code
            - return_result
            - exception
            - standard_err
            - standard_out
         navigate:
            - SUCCESS: SUCCESS
            - FAILURE: FAILURE
  outputs:
    - return_code
    - exception
    - service_status: ${get('return_result','').strip()}
  results:
    - SUCCESS
    - FAILURE