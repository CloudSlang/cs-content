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
#! @description: Starts the Swarm manager.
#!
#! @input swarm_port: port of the host used by the Swarm manager
#! @input cluster_id: ID of the Swarm cluster
#! @input swarm_image: Optional - Docker image the Swarm agent container is created from - Default: swarm (latest)
#! @input host: Docker machine host
#! @input port: Optional - SSH port
#! @input username: Docker machine username
#! @input password: Optional - Docker machine password
#! @input private_key_file: Optional - path to private key file
#! @input character_set: Optional - character encoding used for input stream encoding from target machine
#!                       Valid: SJIS, EUC-JP, UTF-8
#! @input pty: Optional - whether to use PTY - Valid: true, false
#! @input timeout: Optional - time in milliseconds to wait for the command to complete
#! @input close_session: Optional - if false SSH session will be cached for future calls during the life of the flow,
#!                       if true the SSH session used will be closed;
#!                       Valid: true, false
#! @input agent_forwarding: Optional - whether to forward the user authentication agent
#!
#! @output manager_container_id: ID of the created manager container
#!
#! @result SUCCESS: successful
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.swarm

imports:
  containers: io.cloudslang.docker.containers

flow:
  name: start_manager

  inputs:
    - swarm_port
    - cluster_id
    - swarm_image: 'swarm'
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
    - timeout:
        required: false
    - close_session:
        required: false
    - agent_forwarding:
        required: false

  workflow:
    - run_manager_container:
        do:
          containers.run_container:
            - container_params: ${'-p ' + swarm_port + ':2375'}
            - container_command: ${'manage token://' + cluster_id}
            - image_name: ${swarm_image}
            - host
            - port
            - username
            - password
            - private_key_file
            - character_set
            - pty
            - timeout
            - close_session
            - agent_forwarding
        publish:
          - manager_container_id: ${container_id}

  outputs:
    - manager_container_id
