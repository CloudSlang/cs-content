#   Copyright 2023 Open Text
#   This program and the accompanying materials
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
#! @description: Retrieves a list of all the dangling Docker images.
#!
#! @input docker_options: Optional - options for the docker environment
#!                        from the construct: docker [OPTIONS] COMMAND [arg...]
#! @input host: Docker machine host
#! @input port: Optional - SSH port
#! @input username: Docker machine username
#! @input password: Docker machine password
#! @input private_key_file: Optional - path to the private key file
#! @input arguments: Optional - arguments to pass to the command
#! @input character_set: Optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#! @input pty: Optional - whether to use PTY - Valid: true, false
#! @input timeout: Optional - time in milliseconds to wait for command to complete - Default: 30000000
#! @input close_session: Optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#!                       if 'true' the SSH session used will be closed; Valid: true, false
#! @input agent_forwarding: Optional - whether to forward the user authentication agent
#!
#! @output dangling_image_list: list of names of dangling Docker images
#!
#! @result SUCCESS: List of all the dangling processes retrieved successfully.
#! @result FAILURE: There was an error while trying to retrieve the list of dangling processes.
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.images

imports:
  ssh: io.cloudslang.base.ssh

flow:
  name: get_dangling_images

  inputs:
    - docker_options:
        required: false
    - docker_options_expression:
        default: ${ docker_options + ' ' if bool(docker_options) else '' }
        required: false
        private: true
    - host
    - port:
        required: false
    - username
    - password:
        required: false
        sensitive: true
    - private_key_file:
         required: false
    - command:
        default: >
          ${ "docker " + docker_options_expression + "images -f \"dangling=true\"" }
        required: false
        private: true
    - arguments:
        required: false
    - character_set:
        required: false
    - pty:
        required: false
    - timeout:
        default: "30000000"
        required: false
    - close_session:
        required: false
    - agent_forwarding:
        required: false

  workflow:
    - get_images:
        do:
          ssh.ssh_flow:
            - host
            - port
            - username
            - password
            - private_key_file
            - command
            - arguments
            - character_set
            - pty
            - timeout
            - close_session
            - agent_forwarding
        publish:
          - dangling_image_list: >
              ${ ' '.join(map(lambda line : line.split()[0] + ':' +
              line.split()[1], filter(lambda line : line != '', return_result.split('\n')[1:]))).replace(":latest", "") }

  outputs:
    - dangling_image_list
