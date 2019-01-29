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
#! @description: Stops the specified Docker container.
#!
#! @input container_id: ID of the container to be stopped.
#! @input docker_options: Optional - Options for the docker environment
#!                        from the construct: docker [OPTIONS] COMMAND [arg...]
#! @input time: Optional - Time to wait before stopping the container gracefully.
#!              Note: By default, Docker has a 10 second timeout.
#! @input cmd_params: Optional - Command parameters.
#! @input host: Docker machine host.
#! @input port: Optional - SSH port.
#! @input username: Docker machine username.
#! @input password: Optional - Docker machine password.
#! @input private_key_file: Optional - Absolute path to private key file.
#! @input arguments: Optional - arguments to pass to command.
#! @input character_set: Optional - character encoding used for input stream encoding from target machine.
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#! @input pty: Optional - whether to use PTY.
#!             Valid: 'true', 'false'
#! @input timeout: Optional - Time in milliseconds to wait for command to complete.
#! @input close_session: Optional - If false SSH session will be cached for future calls during the life of the flow,
#!                       if true the SSH session used will be closed.
#!                       Valid: 'true', 'false'
#! @input agent_forwarding: Optional - The sessionObject that holds the connection if the close session is false.
#!
#! @output result: ID of the container that was stopped.
#! @output standard_err: STDERR of the command.
#!
#! @result SUCCESS: Docker container stopped successfully.
#! @result FAILURE: There was an error while trying to stop the Docker container.
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.containers

imports:
  ssh: io.cloudslang.base.ssh

flow:
  name: stop_container
  inputs:
    - container_id:
        required: false
    - docker_options:
        required: false
    - docker_options_expression:
        default: ${docker_options + ' ' if bool(docker_options) else ''}
        required: false
        private: true
    - time:
        required: false
    - time_option:
        default: ${'-t ' + time + ' ' if bool(time) else ''}
        required: false
        private: true
    - cmd_params:
        required: false
    - params:
        default: ${cmd_params + ' ' if bool(cmd_params) else ''}
        required: false
        private: true
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
    - command:
        default: ${'docker ' + docker_options_expression + 'stop ' + time_option + params + container_id}
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
    - delete_container:
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
          - result: ${return_result.replace("\n","")}
          - standard_out
          - standard_err
          - exception
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - result
    - standard_err

  results:
    - SUCCESS
    - FAILURE
