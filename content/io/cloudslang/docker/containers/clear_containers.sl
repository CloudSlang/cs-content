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
#! @description: Deletes all Docker images and containers from a Docker Host.
#!
#! @input docker_host: Docker machine host
#! @input docker_username: Docker machine username
#! @input docker_password: Docker machine password
#! @input private_key_file: Optional - path to private key file
#! @input timeout: Optional - time in milliseconds to wait for the command to complete - Default: '6000000'
#! @input port: Optional - SSH port
#!
#! @result SUCCESS: Docker images deleted successfully
#! @result FAILURE: There was an error while trying to delete Docker containers
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.containers

imports:
 containers: io.cloudslang.docker.containers

flow:
  name: clear_containers

  inputs:
    - docker_host
    - docker_username
    - docker_password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - timeout: '6000000'
    - port:
        required: false

  workflow:
    - get_all_containers:
        do:
          containers.get_all_containers:
            - host: ${docker_host}
            - username: ${docker_username}
            - password: ${docker_password}
            - all_containers: 'true'
            - private_key_file
            - timeout
            - port
        publish:
          - all_containers: ${container_list}

    - clear_all_containers:
        do:
          containers.clear_container:
            - container_id: ${all_containers}
            - docker_host
            - docker_username
            - docker_password
            - private_key_file
            - timeout
            - port
