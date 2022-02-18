#   (c) Copyright 2022 Micro Focus, L.P.
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
  images: io.cloudslang.docker.images
  containers: io.cloudslang.docker.containers
  maintenance: io.cloudslang.docker.maintenance
  strings: io.cloudslang.base.strings

flow:
  name: test_find_containers_with_process
  inputs:
    - host
    - port:
        default: '22'
        required: false
    - username
    - password:
        sensitive: true
    - first_image_name
    - second_image_name
    - process_name

  workflow:
    - clear_docker_host_prereqeust:
       do:
         containers.clear_containers:
           - docker_host: ${host}
           - port
           - docker_username: ${username}
           - docker_password: ${password}

       navigate:
         - SUCCESS: pull_first_image
         - FAILURE: PREREQUISITE_MACHINE_IS_NOT_CLEAN

    - pull_first_image:
        do:
          images.pull_image:
            - host
            - port
            - username
            - password
            - image_name: ${first_image_name}

        navigate:
          - SUCCESS: pull_second_image
          - FAILURE: FAIL_PULL_IMAGE

    - pull_second_image:
        do:
          images.pull_image:
            - host
            - port
            - username
            - password
            - image_name: ${second_image_name}

        navigate:
          - SUCCESS: run_first_container
          - FAILURE: FAIL_PULL_IMAGE

    - run_first_container:
        do:
          containers.run_container:
            - host
            - port
            - username
            - password
            - container_params: '-t'
            - container_name: 'first_test_container'
            - image_name: ${first_image_name}

        publish:
          - error_message

        navigate:
          - SUCCESS: run_second_container
          - FAILURE: FAIL_RUN_IMAGE

    - run_second_container:
        do:
          containers.run_container:
            - host
            - port
            - username
            - container_params: '-t'
            - password
            - container_name: 'second_test_container'
            - image_name: ${second_image_name}

        publish:
          - error_message

        navigate:
          - SUCCESS: find_containers_with_process
          - FAILURE: FAIL_RUN_IMAGE

    - find_containers_with_process:
        do:
          containers.find_containers_with_process:
            - host
            - port
            - username
            - password
            - process_name

        publish:
          - list: ${containers_found}

    - verify_list:
        do:
          strings.string_equals:
            - first_string: ${str(len(list.rstrip().split()))}
            - second_string: '2'

        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  results:
    - SUCCESS
    - PREREQUISITE_MACHINE_IS_NOT_CLEAN
    - FAIL_PULL_IMAGE
    - FAILURE
    - FAIL_RUN_IMAGE
