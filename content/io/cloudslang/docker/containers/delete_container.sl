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
#! @description: Deletes the specified Docker container.
#!
#! @input container_id: ID of the container to be deleted
#! @input docker_options: Optional - options for the docker environment
#!                        from the construct: docker [OPTIONS] COMMAND [arg...]
#! @input cmd_params: Optional - command parameters
#! @input host: Docker machine host
#! @input port: Optional - SSH port
#! @input username: Docker machine username
#! @input password: Optional - Docker machine password
#! @input private_key_file: Optional - absolute path to private key file
#! @input arguments: Optional - arguments to pass to command
#! @input character_set: Optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#! @input pty: Optional - whether to use PTY
#!             Valid: true, false
#! @input timeout: Optional - time in milliseconds to wait for the command to complete
#! @input close_session: Optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#!                       if 'true' the SSH session used will be closed;
#!                       Valid: true, false
#! @input agent_forwarding: Optional - the sessionObject that holds the connection if the close session is false
#!
#! @output result: ID of the container that was deleted
#! @output error_message: something went wrong while trying to delete the container
#!
#! @result SUCCESS: specified Docker container deleted successfully
#! @result FAILURE: There was an error while trying to delete the specified Docker container
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.containers

imports:
  ssh: io.cloudslang.base.ssh

flow:
  name: delete_container

  inputs:
    - container_id:
        required: false
    - docker_options:
        required: false
    - docker_options_expression:
        default: ${docker_options + ' ' if bool(docker_options) else ''}
        required: false
        private: true
    - cmd_params:
        required: false
    - params:
        default: ${cmd_params + ' ' if bool(cmd_params) else ''}
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
    - arguments:
        required: false
    - command:
        default: ${'docker ' + docker_options_expression + 'rm ' + params + container_id}
        required: false
        private: true
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
    - delete_container:
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
          - result: ${return_result.replace("\n","")}
          - exception
          - standard_out
          - standard_err
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - result
    - error_message: ${standard_err}
