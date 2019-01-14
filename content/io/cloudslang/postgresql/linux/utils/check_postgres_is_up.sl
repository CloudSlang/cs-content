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
#! @description: Check a postgresql database is up
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
#!                           Default: '/var/lib/pgsql/10'
#! @input pg_ctl_location: Path of the pg_ctl binary
#!                         Default: '/usr/pgsql-10/bin'
#! @input private_key_file: Absolute path to private key file
#!                          Optional
#!
#! @output process_id: The ID of the PostgreSQL process
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
  base: io.cloudslang.base.cmd
  ssh: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings
  postgres: io.cloudslang.postgresql
  utils: io.cloudslang.base.utils

flow:
  name: check_postgres_is_up

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
    - installation_location:
        required: true
    - pg_ctl_location:
        required: true
    - private_key_file:
        required: false
  workflow:
      - check_postgress_is_up:
          do:
             postgres.linux.utils.run_pg_ctl_command:
                - operation: 'status'
                - installation_location
                - pg_ctl_location
                - hostname
                - username
                - proxy_host
                - proxy_port
                - proxy_username
                - proxy_password
                - connection_timeout
                - execution_timeout
                - private_key_file
          publish:
              - return_result
              - error_message
              - exception
              - return_code
              - standard_err
              - standard_out
      - verify:
          do:
            strings.string_occurrence_counter:
              - string_in_which_to_search: ${standard_out}
              - string_to_find: 'server is running'
          navigate:
            - SUCCESS: SUCCESS
            - FAILURE: FAILURE
  # pg_ctl: server is running (PID: 30718)
  outputs:
      - process_id : ${standard_out.split('PID:')[1].split(')')[0] if standard_out is not None and 'server is running' in standard_out else ""}
      - return_result
      - exception : ${get('standard_err','').strip()}
      - return_code
  results:
    - SUCCESS
    - FAILURE
