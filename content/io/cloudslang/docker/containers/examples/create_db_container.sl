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
#! @description: Creates a Docker DB container.
#!
#! @input host: Docker machine host
#! @input port: Optional - SSH port
#! @input username: Docker machine username
#! @input password: Docker machine password
#! @input port: Optional - SSH port
#! @input password: Optional - Docker machine password
#! @input private_key_file: Optional - path to private key file
#! @input container_name: Optional - name of the DB container - Default: 'mysqldb'
#! @input timeout: Optional - time in milliseconds to wait for command to complete
#!
#! @output db_IP: IP of newly created container
#! @output error_message: error message of failed operation
#!
#! @result SUCCESS: Docker container DB created successfully
#! @result FAILURE: There was an error while trying to create Docker container DB
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.containers.examples

imports:
 images: io.cloudslang.docker.images
 containers: io.cloudslang.docker.containers

flow:
  name: create_db_container

  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - container_name: 'mysqldb'
    - timeout:
        required: false

  workflow:
    - pull_mysql_image:
        do:
          images.pull_image:
            - image_name: 'mysql'
            - host
            - port
            - username
            - passworde
            - private_key_file
            - timeout
        publish:
          - error_message

    - create_mysql_container:
        do:
          containers.run_container:
            - image_name: 'mysql'
            - container_name
            - container_params: ${'-e MYSQL_ROOT_PASSWORD=pass -e MYSQL_DATABASE=boot -e MYSQL_USER=user -e MYSQL_PASSWORD=pass'}
            - host
            - port
            - username
            - password
            - private_key_file
            - timeout

    - get_db_ip:
        do:
          containers.get_container_ip:
            - container_name
            - host
            - port
            - username
            - password
            - private_key_file
            - timeout
        publish:
          - container_ip: ${container_ip}
          - error_message

  outputs:
    - db_IP: ${'' if 'container_ip' not in locals() else container_ip}
    - error_message
