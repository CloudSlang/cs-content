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
#! @description: Wrapper flow for testing pull images.
#! @input images_to_pull: format is 'busybox,alpine'
#! @input host: Docker machine host
#! @input port: Optional - SSH port
#! @input username: Docker machine username
#! @input password: Optional - Docker machine password
#! @input private_key_file: Optional - absolute path to private key file
#! @input arguments: Optional - arguments to pass to the command
#! @input character_set: Optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#! @input pty: whether to use PTY - Valid: true, false
#! @input timeout: time in milliseconds to wait for command to complete
#! @input close_session: Optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#!                       if 'true' the SSH session used will be closed; Valid: true, false
#! @input agent_forwarding: Optional - whether to forward the user authentication agent
#! @result SUCCESS: self explanative
#! @result CLEAR_DOCKER_HOST_FAILURE: self explanative
#! @result PULL_IMAGES_FAILURE: self explanative
#! @result GET_ALL_IMAGES_FAILURE: self explanative
#! @result VERIFY_IMAGES_EXIST_FAILURE: self explanative
#!!#
####################################################

namespace: io.cloudslang.docker.examples

imports:
  maintenance: io.cloudslang.docker.maintenance
  examples: io.cloudslang.docker.examples
  images: io.cloudslang.docker.images
  lists: io.cloudslang.base.lists

flow:
  name: test_pull_images

  inputs:
    - images_to_pull
    - host
    - port:
        required: false
    - username
    - password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - arguments:
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
    - clear_docker_host:
        do:
          maintenance.clear_host:
            - docker_host: ${host}
            - docker_username: ${username}
            - docker_password: ${password}
            - private_key_file
            - timeout
            - port
        navigate:
          - SUCCESS: pull_images
          - FAILURE: CLEAR_DOCKER_HOST_FAILURE

    - pull_images:
        do:
          examples.pull_images:
            - images_to_pull
            - host
            - port
            - username
            - password
            - private_key_file
            - arguments
            - character_set
            - pty
            - timeout
            - close_session
            - agent_forwarding
        navigate:
          - SUCCESS: get_all_images
          - FAILURE: PULL_IMAGES_FAILURE

    - get_all_images:
        do:
          images.get_all_images:
            - host
            - port
            - username
            - password
            - private_key_file
            - arguments
            - character_set
            - pty
            - timeout
            - close_session
            - agent_forwarding
        publish:
          - image_list
        navigate:
          - SUCCESS: verify_images_exist
          - FAILURE: GET_ALL_IMAGES_FAILURE

    - verify_images_exist:
        do:
          lists.set_equals:
            - raw_set_1: ${image_list}
            - delimiter_1: ' '
            - raw_set_2: ${images_to_pull}
            - delimiter_2: ','
        navigate:
          - EQUAL: SUCCESS
          - NOT_EQUAL: VERIFY_IMAGES_EXIST_FAILURE

  results:
    - SUCCESS
    - CLEAR_DOCKER_HOST_FAILURE
    - PULL_IMAGES_FAILURE
    - GET_ALL_IMAGES_FAILURE
    - VERIFY_IMAGES_EXIST_FAILURE
