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
#! @description: Deletes all Docker images and containers from a Docker Swarm cluster.
#!
#! @input swarm_manager_ip: IP address of the machine with the Swarm manager container
#! @input swarm_manager_port: Port used by the Swarm manager container
#! @input excluded_images: Optional - Containers based on these images will not be deleted
#!                         used for filtering out containers used by Swarm e.g. agent containers
#!                         Default: swarm:latest
#! @input host: Docker machine host
#! @input port: Optional - SSH port
#! @input username: Docker machine username
#! @input password: Optional - Docker machine password
#! @input private_key_file: Optional - Path to private key file
#! @input character_set: Optional - Character encoding used for input stream encoding from target machine
#!                       Valid: SJIS, EUC-JP, UTF-8
#! @input pty: Optional - whether to use PTY
#!             Valid: true, false
#! @input timeout: Optional - Time in milliseconds to wait for the command to complete
#! @input close_session: Optional - If false SSH session will be cached for future calls during the life of the flow,
#!                       if true the SSH session used will be closed;
#!                       Valid: true, false
#! @input agent_forwarding: Optional - Whether to forward the user authentication agent
#!
#! @output amount_of_images_deleted: how many images (not including dangling) were deleted
#! @output amount_of_dangling_images_deleted: how many dangling images were deleted
#! @output total_amount_of_images_deleted: how many images (including dangling) were deleted
#!
#! @result SUCCESS: successful
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.swarm

imports:
  containers: io.cloudslang.docker.containers
  images: io.cloudslang.docker.images

flow:
  name: clear_cluster

  inputs:
    - swarm_manager_ip
    - swarm_manager_port
    - excluded_images: 'swarm:latest'
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
    - docker_options:
        default: ${'-H tcp://' + swarm_manager_ip + ':' + swarm_manager_port}
        private: true

  workflow:
    - get_containers_in_cluster:
        do:
          containers.get_filtered_containers:
            - docker_options
            - all_containers: 'true'
            - excluded_images
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
          - container_ids

    - clear_containers:
        do:
          containers.clear_container:
            - container_id: ${container_ids.replace(",", " ")}
            - docker_options
            - docker_host: ${host}
            - port
            - docker_username: ${username}
            - docker_password: ${password}
            - private_key_file
            - timeout

    - clear_unused_images:
        do:
          images.clear_unused_and_dangling_images:
            - docker_options
            - docker_host: ${host}
            - docker_username: ${username}
            - docker_password: ${password}
            - private_key_file
            - timeout
            - port
        publish:
          - amount_of_images_deleted
          - amount_of_dangling_images_deleted
          - total_amount_of_images_deleted: ${str(int(amount_of_images_deleted) + int(amount_of_dangling_images_deleted))}

  outputs:
    - amount_of_images_deleted
    - amount_of_dangling_images_deleted
    - total_amount_of_images_deleted
