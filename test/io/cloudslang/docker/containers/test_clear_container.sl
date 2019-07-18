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
  images: io.cloudslang.docker.images
  strings: io.cloudslang.base.strings

flow:
  name: test_clear_container

  inputs:
    - host
    - port:
        required: false
    - username
    - password
    - first_image_name
    - second_image_name

  workflow:
    - clear_docker_host_prerequest:
        do:
          containers.clear_containers:
             - docker_host: ${host}
             - port
             - docker_username: ${username}
             - docker_password: ${password}
        navigate:
          - SUCCESS: pull_image
          - FAILURE: PREREQUEST_MACHINE_IS_NOT_CLEAN

    - pull_image:
        do:
          images.pull_image:
            - host
            - port
            - username
            - password
            - image_name: ${first_image_name}
        navigate:
          - SUCCESS: pull_second
          - FAILURE: FAIL_PULL_IMAGE

    - pull_second:
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
            - container_name: 'first'
            - image_name: ${first_image_name}
        navigate:
          - SUCCESS: run_second_container
          - FAILURE: FAIL_RUN_IMAGE

    - run_second_container:
        do:
          containers.run_container:
            - host
            - port
            - username
            - password
            - container_name: 'second'
            - image_name: ${second_image_name}
            - container_params: '-p 49165:22'
        navigate:
          - SUCCESS: get_all_containers
          - FAILURE: FAIL_RUN_IMAGE

    - get_all_containers:
        do:
          containers.get_all_containers:
            - host
            - username
            - password
            - all_containers: 'true'
            - port
        publish:
          - all_containers: ${container_list}
        navigate:
          - SUCCESS: clear_all_containers
          - FAILURE: FAILURE

    - clear_all_containers:
        do:
          containers.clear_container:
            - docker_host: ${host}
            - port
            - docker_username: ${username}
            - docker_password: ${password}
            - container_id: ${all_containers}
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
    - PREREQUEST_MACHINE_IS_NOT_CLEAN
    - FAIL_PULL_IMAGE
    - FAILURE
    - FAIL_RUN_IMAGE
