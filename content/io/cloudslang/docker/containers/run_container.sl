#   Copyright 2024 Open Text
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
#! @description: Pulls and runs a Docker container.
#!
#! @input docker_options: Optional - options for the Docker environment
#!                        - from the construct: docker [OPTIONS] COMMAND [arg...]
#! @input detach: Optional - run container in background (detached / daemon mode) - Default: true
#! @input container_name: Optional - container name
#! @input container_params: Optional - command parameters
#! @input container_command: Optional - container command
#! @input image_name: Docker image that will be assigned to the container
#! @input host: Docker machine host
#! @input port: Optional - SSH port
#! @input username: Docker machine username
#! @input password: Optional - Docker machine password
#! @input private_key_file: Optional - path to private key file
#! @input arguments: Optional - arguments to pass to command
#! @input character_set: Optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#! @input pty: Optional - whether to use PTY - Valid: true, false
#! @input timeout: Optional - time in milliseconds to wait for the command to complete
#! @input close_session: Optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#!                       if 'true' the SSH session used will be closed; Valid: true, false
#! @input agent_forwarding: Optional - whether to forward the user authentication agent
#!
#! @output container_id: ID of the container
#! @output error_message: STDERR of the machine in case of successful request, null otherwise
#!
#! @result SUCCESS: Docker container pulled and executed successfully
#! @result FAILURE: There was an error while trying to pull and run the Docker container
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.containers

imports:
  ssh: io.cloudslang.base.ssh

flow:
  name: run_container

  inputs:
    - docker_options:
        required: false
    - detach: 'true'
    - container_name:
        required: false
    - container_params:
        required: false
    - container_command:
        required: false
    - image_name
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
    - character_set:
        required: false
    - pty:
        required: false
    - timeout:
        default: '300000'
        required: false
    - close_session:
        required: false
    - agent_forwarding:
        required: false
    - docker_options_expression:
        default: ${(docker_options + ' ') if bool(docker_options) else ''}
        required: false
        private: true
    - detach_expression:
        default: ${'-d ' if (detach.lower() == 'true') else ''}
        required: false
        private: true
    - container_name_param:
        default: ${'--name ' + container_name + ' ' if bool(container_name) else ''}
        required: false
        private: true
    - container_params_cmd:
        default: ${container_params + ' ' if bool(container_params) else ''}
        required: false
        private: true
    - container_command_cmd:
        default: ${' ' + container_command if bool(container_command) else ''}
        required: false
        private: true
    - command:
        default: >
            ${'docker ' + docker_options_expression + 'run ' + detach_expression + container_name_param +
            container_params_cmd + image_name + container_command_cmd}
        private: true

  workflow:
    - run_container:
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
          - container_id: ${standard_out.strip()}
          - standard_err

  outputs:
    - container_id
    - error_message: ${standard_err}
