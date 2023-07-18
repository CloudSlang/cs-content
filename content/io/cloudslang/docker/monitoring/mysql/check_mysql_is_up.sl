#   Copyright 2023 Open Text
#   This program and the accompanying materials
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
#! @description: Checks if the MySQL server is up, meaning its state is alive.
#!
#! @input container: name or ID of the Docker container that runs MySQL
#! @input host: Docker machine host
#! @input port: Optional - SSH port
#! @input username: Docker machine username
#! @input password: Optional - Docker machine password
#! @input arguments: Optional - arguments to pass to the command
#! @input mysql_username: MySQL instance username
#! @input mysql_password: MySQL instance password
#! @input private_key_file: Optional - absolute path to private key file
#! @input character_set: Optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#! @input pty: Optional - whether to use PTY - Valid: true, false
#! @input timeout: Optional - time in milliseconds to wait for command to complete
#! @input close_session: Optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#!                       if 'true' the SSH session used will be closed; Valid: true, false
#! @input agent_forwarding: Optional - whether to forward the user authentication agent
#!
#! @output return_result: The return result of the command
#! @output error_message: contains the STDERR of the machine if the SSH action was executed successfully,
#!                        the cause of the exception otherwise
#!
#! @result SUCCESS: action was executed successfully and MySQL server state is alive
#! @result FAILURE: some problem occurred, more information in errorMessage output
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.monitoring.mysql

imports:
  ssh: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings

flow:
  name: check_mysql_is_up

  inputs:
    - container
    - host
    - port:
        required: false
    - username
    - password:
        required: false
        sensitive: true
    - arguments:
        required: false
    - mysql_username
    - mysql_password:
        sensitive: true
    - private_key_file:
        required: false
    - exec_cmd:
        default: ${ 'mysqladmin -u' + mysql_username + ' -p' + mysql_password + ' --protocol=tcp ping' }
        private: true
    - command:
        default: ${ 'docker exec ' + container + ' ' + exec_cmd }
        private: true
    - character_set:
        required: false
    - pty:
        required: false
    - timeout:
        required: false
    - close_session:
        required: false
    - agent_forwarding:
        required: false

  workflow:
    - check_mysql_is_up:
        do:
          ssh.ssh_flow:
            - host
            - port
            - username
            - password
            - private_key_file
            - command
            - arguments
            - character_set
            - pty
            - timeout
            - close_session
            - agent_forwarding
        publish:
          - return_result
          - error_message:  ${ standard_err if return_code == '0' else return_result }

    - verify:
        do:
          strings.string_equals:
            - first_string: ${ return_result.replace("\n","") }
            - second_string: "mysqld is alive"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
      - return_result
      - error_message

  results:
    - SUCCESS
    - FAILURE
