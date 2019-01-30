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
#! @description: Deletes a Docker container.
#!
#! @input container_id: ID of the container to be deleted
#! @input docker_options: Optional - options for the Docker environment
#!                        from the construct: docker [OPTIONS] COMMAND [arg...]
#! @input docker_host: Docker machine host
#! @input docker_username: Docker machine username
#! @input docker_password: Optional - Docker machine password
#! @input private_key_file: Optional - path to private key file
#! @input port: Optional - SSH port
#!
#! @output error_message: error message of the operation that failed
#!
#! @result SUCCESS: Docker container deleted successfully
#! @result FAILURE: There was an error while trying to delete the Docker container
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.containers

imports:
  containers: io.cloudslang.docker.containers

flow:
  name: clear_container

  inputs:
    - container_id:
        required: false
    - docker_options:
        required: false
    - docker_host
    - docker_username
    - docker_password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - port:
        required: false

  workflow:
    - stop_container:
        do:
          containers.stop_container:
            - container_id
            - docker_options
            - host: ${docker_host}
            - username: ${docker_username}
            - password: ${docker_password}
            - private_key_file
            - port
        publish:
          - error_message

    - delete_container:
        do:
          containers.delete_container:
            - container_id
            - docker_options
            - host: ${docker_host}
            - username: ${docker_username}
            - password: ${docker_password}
            - private_key_file
            - port
        publish:
          - error_message

  outputs:
    - error_message
