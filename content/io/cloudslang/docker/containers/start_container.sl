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
#! @description: Starts a specified Docker container.
#!
#! @input start_container_id: ID of the container to be started
#! @input container_params: Optional - command parameters - Default: none
#! @input host: Docker machine host
#! @input port: Optional - SSH port
#! @input username: Docker machine username
#! @input password: Optional - Docker machine password
#! @input private_key_file: Optional - absolute path to private key file
#! @input arguments: Optional - arguments to pass to command
#! @input character_set: Optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#! @input pty: Optional - whether to use PTY - Valid: true, false
#! @input timeout: Optional - time in milliseconds to wait for the command to complete
#! @input close_session: Optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#!                       if 'true' the SSH session used will be closed; Valid: true, false
#!
#! @output container_id_output: ID of the container that was started
#! @output error_message: error message
#!
#! @result SUCCESS: Docker container sucessfully started
#! @result FAILURE: There was an error while trying to start the Docker container
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.containers

imports:
  ssh: io.cloudslang.base.ssh

flow:
  name: start_container

  inputs:
    - start_container_id
    - container_params:
        required: false
    - host
    - port:
        required: false
    - username
    - password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - arguments:
        required: false
    - container_params_cmd:
        default: ${container_params + ' ' if bool(container_params) else ''}
        required: false
        private: true
    - command:
        default: ${'docker start ' + container_params_cmd + ' ' + start_container_id}
        private: true
    - character_set:
        required: false
    - pty:
        required: false
    - timeout:
        required: false
    - close_session:
        required: false

  workflow:
    - start_container:
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
            - agentForwarding
        publish:
          - return_result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - container_id_output: ${return_result}
    - error_message: ${'' if 'STDERR' not in locals() else STDERR if return_code == '0' else return_result}
