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
#! @description: Display information (image name) and pulls a Docker image. Wrapper over `pull_image`.
#!
#! @input image_name: image name to be pulled
#! @input host: Docker machine host
#! @input port: Optional - SSH port
#! @input username: Docker machine username
#! @input password: Optional - Docker machine password
#! @input private_key_file: Optional - absolute path to private key file
#! @input arguments: Optional - arguments to pass to the command
#! @input character_set: Optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#! @input pty: whether to use PTY - Valid: true, false
#! @input timeout: time in milliseconds to wait for command to complete - Default: 30000000
#! @input close_session: Optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#!                       if 'true' the SSH session used will be closed; Valid: true, false
#! @input agent_forwarding: Optional - whether to forward the user authentication agent
#!
#! @output return_result: response of the operation
#! @output error_message: error message
#!
#! @result SUCCESS: successful
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.examples

imports:
  print: io.cloudslang.base.print
  images: io.cloudslang.docker.images

flow:
  name: pull_image_with_message

  inputs:
    - image_name
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
    - display_message:
        do:
          print.print_text:
            - text: >
                ${ 'Pulling image: ' + image_name }
        navigate:
          - SUCCESS: pull_docker_image

    - pull_docker_image:
        do:
          images.pull_image:
            - image_name
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
          - return_result
          - error_message

  outputs:
    - return_result
    - error_message
