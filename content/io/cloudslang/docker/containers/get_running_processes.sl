#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: Returns the list of the running processes on a container.
#!
#! @input container_id: container id
#! @input host: Docker machine host
#! @input port: Optional - SSH port - Default: '22'
#! @input username: Docker machine username
#! @input password: Docker machine password - Default: ''
#! @input process_name: name of the process
#! @input private_key_file: Optional - absolute path to private key file - Default: ''
#! @input arguments: Optional - arguments to pass to the command - Default ''
#! @input character_set: Optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8' - Default 'UTF-8'
#! @input pty: Optional - whether to use PTY - Valid: true, false - Default: false
#! @input timeout: Optional - time in milliseconds to wait for command to complete - Default: 90000
#! @input close_session: Optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#!                       if 'true' the SSH session used will be closed;
#!                       Valid: true, false - Default: false
#! @input agent_forwarding: Optional - the sessionObject that holds the connection if the close session is false
#!                          Default: ''
#!
#! @output standard_err: error message
#! @output return_result: list of running processes on the container
#!
#! @result SUCCESS: The list of running processes on that specific container retrieved sucessfully
#! @result FAILURE: There was an error while trying to retrieve the list of running processes from the container
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.containers

imports:
  ssh: io.cloudslang.base.ssh

flow:
  name: get_running_processes

  inputs:
    - container_id
    - command:
        default: ${"docker exec " + container_id + " ps axco command"}
        private: true
    - host
    - port:
        default: '22'
        required: false
    - username
    - password:
        default: ''
        required: false
        sensitive: true
    - private_key_file:
        default: ''
        required: false
    - arguments:
        default: ''
        required: false
    - character_set:
        default: 'UTF-8'
        required: false
    - pty:
        default: 'false'
        required: false
    - timeout:
        default: '90000'
        required: false
    - close_session:
        default: 'false'
        required: false
    - agent_forwarding:
        default: ''
        required: false

  workflow:
    - get_running_processes:
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
          - standard_err
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - return_result
    - standard_err

  results:
    - SUCCESS
    - FAILURE
