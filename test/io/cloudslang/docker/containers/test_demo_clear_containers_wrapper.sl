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

namespace: io.cloudslang.docker.containers

imports:
  containers: io.cloudslang.docker.containers
  examples: io.cloudslang.docker.containers.examples
  images: io.cloudslang.docker.images
  maintenance: io.cloudslang.docker.maintenance
  strings: io.cloudslang.base.strings
  print: io.cloudslang.base.print

flow:
  name: test_demo_clear_containers_wrapper
  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - private_key_file:
        required: false
    - linked_image: 'meirwa/spring-boot-tomcat-mysql-app'
    - linked_container_cmd:
        required: false
    - linked_container_name: 'spring-boot-tomcat-mysql-app'

  workflow:
    - pre_test_cleanup:
         do:
           maintenance.clear_host:
             - docker_host: ${host}
             - port
             - docker_username: ${username}
             - docker_password: ${password}
             - private_key_file
         navigate:
           - SUCCESS: start_mysql_container
           - FAILURE: MACHINE_IS_NOT_CLEAN

    - start_mysql_container:
        do:
          examples.create_db_container:
            - host
            - port
            - username
            - password
            - private_key_file
        publish:
          - db_IP
        navigate:
          - SUCCESS: pull_linked_image
          - FAILURE: FAIL_TO_START_MYSQL_CONTAINER

    - pull_linked_image:
        do:
          images.pull_image:
            - image_name: ${linked_image}
            - host
            - port
            - username
            - password
            - private_key_file
        publish:
          - error_message
        navigate:
          - SUCCESS: start_linked_container
          - FAILURE: print_pull_linked_image_error

    - print_pull_linked_image_error:
        do:
          print.print_text:
            - text: error_message
        navigate:
          - SUCCESS: FAIL_TO_PULL_LINKED_CONTAINER

    - start_linked_container:
        do:
          containers.start_linked_container:
            - image_name: ${linked_image}
            - container_name: ${linked_container_name}
            - link_params: 'mysqldb:mysql'
            - cmd_params: ${'-e DB_URL=' + db_IP + ' -p ' + '8080' + ':8080'}
            - container_cmd: ${linked_container_cmd}
            - host
            - port
            - username
            - password
            - private_key_file
            - timeout: '30000000'
        publish:
          - container_id
          - error_message

    - demo_clear_containers_wrapper:
        do:
          examples.demo_clear_containers_wrapper:
            - db_container_id: 'mysqldb'
            - linked_container_id: ${linked_container_name}
            - docker_host: ${host}
            - port
            - docker_username: ${username}
            - docker_password: ${password}
            - private_key_file
        navigate:
          - SUCCESS: verify
          - FAILURE: FAILURE

    - verify:
        do:
          containers.get_all_containers:
            - host
            - port
            - username
            - password
            - private_key_file
            - all_containers: 'true'
        publish:
          - all_containers: ${container_list}

    - compare:
        do:
          strings.string_equals:
            - first_string: ${all_containers}
            - second_string: ''
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  results:
    - SUCCESS
    - FAILURE
    - MACHINE_IS_NOT_CLEAN
    - FAIL_TO_START_MYSQL_CONTAINER
    - FAIL_TO_PULL_LINKED_CONTAINER
