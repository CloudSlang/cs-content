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
#! @description: Retrieves a list of all the Docker container names.
#!
#! @input docker_options: Optional - options for the docker environment
#!                        from the construct: docker [OPTIONS] COMMAND [arg...]
#! @input all_containers: Optional - show all containers (both running and stopped)
#!                        Default: false, only running containers
#!                        any input that is different than empty string or false
#!                        (as boolean type) changes its value to True
#! @input host: Docker machine host
#! @input port: Optional - SSH port
#! @input username: Docker machine username
#! @input password: Optional - Docker machine password
#! @input private_key_file: Optional - path to private key file
#! @input character_set: Optional - character encoding used for input stream encoding from target machine;
#!                       Valid: SJIS, EUC-JP, UTF-8
#! @input pty: Optional - whether to use PTY - Valid: true, false
#! @input timeout: Optional - time in milliseconds to wait for command to complete - Default: 600000 ms (10 min)
#! @input close_session: Optional - if false SSH session will be cached for future calls during the life of the flow,
#!                       if true the SSH session used will be closed;
#!                       Valid: true, false
#! @input agent_forwarding: Optional - enables or disables the forwarding of the authentication agent connection
#!
#! @output container_names: list of container names separated by space
#! @output raw_output: unparsed return result from the machine
#!
#! @result SUCCESS: The list of the running Docker container names retrieved successfully
#! @result FAILURE: There was an error while trying to retrieve the list of all the running Docker container names
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.containers

imports:
  ssh: io.cloudslang.base.ssh

flow:
  name: get_container_names

  inputs:
    - docker_options:
        required: false
    - all_containers: 'false'
    - ps_parameters:
        default: ${'-a' if all_containers.lower() == 'true' else ''}
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
    - character_set:
        required: false
    - pty:
        required: false
    - timeout: '600000'
    - close_session:
        required: false
    - agent_forwarding:
        required: false

  workflow:
    - get_containers:
        do:
          ssh.ssh_flow:
            - host
            - port
            - command: ${'docker ' + (docker_options + ' ' if bool(docker_options) else '') + 'ps ' + ps_parameters}
            - pty: 'false'
            - username
            - password
            - private_key_file
            - timeout
            - character_set
            - close_session
            - agent_forwarding
        publish:
          - container_names: >
              ${' '.join(map(lambda line : line.split()[-1], filter(lambda line : line != '', return_result.split('\n')[1:])))}
          - raw_output: ${return_result}

  outputs:
    - container_names
    - raw_output
