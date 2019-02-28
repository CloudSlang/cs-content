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
#! @description: Retrieves a list of all the Docker container names.
#!
#! @input container_id: container id
#! @input containers_with_process: The string where the container id will be appended
#!                                 Default: ''
#! @input host: Docker machine host
#! @input port: Optional - SSH port
#!              Default: '22'
#! @input username: Docker machine username
#! @input password: Docker machine password
#!                  Default: ''
#! @input private_key_file: Optional - absolute path to private key file
#!                          Default: ''
#! @input arguments: Optional - arguments to pass to the command
#!                   Default ''
#! @input character_set: Optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#!                       Default 'UTF-8'
#! @input pty: Optional - whether to use PTY
#!             Valid: true, false
#!             Default: false
#! @input timeout: Optional - time in milliseconds to wait for command to complete
#!                 Default: 90000
#! @input close_session: Optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#!                       if 'true' the SSH session used will be closed;
#!                       Valid: true, false
#!                       Default: false
#! @input agent_forwarding: Optional - the sessionObject that holds the connection if the close session is false
#!                          Default: ''
#!
#! @output containers_with_process_found: container names
#! @output standard_err: error message
#!
#! @result SUCCESS: running containers found
#! @result FAILURE: something went wrong
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.containers

imports:
  ssh: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings
  containers: io.cloudslang.docker.containers

flow:
  name: get_container_names_with_ids

  inputs:
    - container_id
    - host
    - port:
        default: '22'
        required: false
    - username
    - password:
        sensitive: true
        default: ''
        required: false
    - private_key_file:
        default: ''
        required: false
    - arguments:
        default: ''
        required: false
    - character_set:
        default: 'UTF-8'
        required: false
    - pty:
        default: 'false'
        required: false
    - timeout:
        default: '90000'
        required: false
    - close_session:
        default: 'false'
        required: false
    - agent_forwarding:
        default: ''
        required: false
    - containers_with_process:
        default: ''
        required: false

  workflow:
    - get_container_name:
        do:
          containers.get_container_name:
            - container_id
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
          - container_name
        navigate:
          - SUCCESS: append_to_list
          - FAILURE: FAILURE

    - append_to_list:
        do:
          strings.append:
            - origin_string: ${containers_with_process}
            - text: ${container_name + ' '}
        publish:
          - containers_with_process_found: ${new_string}
        navigate:
          - SUCCESS: SUCCESS

  outputs:
    - containers_with_process_found
    - standard_err

  results:
    - SUCCESS
    - FAILURE