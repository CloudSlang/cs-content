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

namespace: io.cloudslang.docker.images

imports:
  images: io.cloudslang.docker.images
  maintenance: io.cloudslang.docker.maintenance
  ssh: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings

flow:
  name: test_build_image

  inputs:
    - docker_image
    - base_image:
        default: "busybox:latest"
    - workdir:
        default: "."
    - dockerfile_name:
        default: "Dockerfile"
    - host
    - port:
        required: false
    - username
    - password:
        required: false
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
    - pre_clear_docker_host:
        do:
          maintenance.clear_host:
            - docker_host: ${ host }
            - port
            - docker_username: ${ username }
            - docker_password: ${ password }
            - private_key_file
        navigate:
          - SUCCESS: create_dockerfile
          - FAILURE: PRE_CLEAR_DOCKER_HOST_PROBLEM

    - create_dockerfile:
        do:
          ssh.ssh_flow:
            - host
            - port
            - command: >
                ${ "mkdir -p " + workdir + " && echo -e 'FROM " + base_image + "' > " + workdir + "/" + dockerfile_name }
            - username
            - password
            - private_key_file
            - timeout
        navigate:
          - SUCCESS: build_image
          - FAILURE: CREATE_DOCKERFILE_PROBLEM

    - build_image:
        do:
          images.build_image:
            - docker_image
            - workdir
            - dockerfile_name
            - host
            - port
            - username
            - password
            - private_key_file
            - timeout
        navigate:
          - SUCCESS: get_all_images
          - FAILURE: FAILURE

    - get_all_images:
        do:
          images.get_all_images:
            - host
            - port
            - username
            - password
            - private_key_file
            - timeout
        publish:
          - image_list
        navigate:
          - SUCCESS: verify_image_exists
          - FAILURE: GET_ALL_IMAGES_PROBLEM

    - verify_image_exists:
        loop:
          for: image in image_list.split()
          do:
            strings.string_equals:
              - first_string: ${ docker_image }
              - second_string: ${ image }
          break:
            - SUCCESS
        navigate:
          - SUCCESS: remove_dockerfile
          - FAILURE: VERIFY_IMAGE_EXISTS_PROBLEM

    - remove_dockerfile:
        do:
          ssh.ssh_flow:
            - host
            - port
            - command: >
                ${ "rm " + workdir + "/" + dockerfile_name }
            - username
            - password
            - private_key_file
            - timeout
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: REMOVE_DOCKERFILE_PROBLEM
  results:
    - SUCCESS
    - FAILURE
    - PRE_CLEAR_DOCKER_HOST_PROBLEM
    - CREATE_DOCKERFILE_PROBLEM
    - GET_ALL_IMAGES_PROBLEM
    - VERIFY_IMAGE_EXISTS_PROBLEM
    - REMOVE_DOCKERFILE_PROBLEM
