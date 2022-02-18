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
  containers: io.cloudslang.docker.containers
  images: io.cloudslang.docker.images
  maintenance: io.cloudslang.docker.maintenance
  strings: io.cloudslang.base.strings

flow:
  name: test_run_container

  inputs:
    - host
    - port:
        required: false
    - username
    - password
    - image_name
    - container_name

  workflow:
    - clear_docker_host_prerequest:
        do:
          maintenance.clear_host:
            - docker_host: ${host}
            - port
            - docker_username: ${username}
            - docker_password: ${password}
        navigate:
          - SUCCESS: pull_image
          - FAILURE: PREREQUST_MACHINE_IS_NOT_CLEAN

    - pull_image:
        do:
          images.pull_image:
            - host
            - port
            - username
            - password
            - image_name
        navigate:
          - SUCCESS: run_container
          - FAILURE: FAIL_PULL_IMAGE

    - run_container:
        do:
          containers.run_container:
            - host
            - port
            - username
            - password
            - container_name: 'test_container'
            - image_name
        navigate:
          - SUCCESS: get_list
          - FAILURE: FAIL_RUN_IMAGE

    - get_list:
        do:
          images.get_used_images:
            - host
            - port
            - username
            - password
        publish:
          - list: ${image_list}

    - verify_output:
        do:
          strings.string_equals:
            - first_string: ${ image_name + " " }
            - second_string: ${list}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: VEFIFYFAILURE

  results:
    - SUCCESS
    - PREREQUST_MACHINE_IS_NOT_CLEAN
    - FAIL_PULL_IMAGE
    - FAILURE
    - FAIL_RUN_IMAGE
    - VEFIFYFAILURE
