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
#! @description: Retrieves the ID list of machines deployed in a CoreOS cluster.
#!
#! @input host: CoreOS machine host.
#!              Can be any machine from the cluster.
#! @input port: Optional - SSH port.
#! @input username: CoreOS machine username.
#! @input password: Optional - CoreOS machine password.
#!                  Can be empty since CoreOS machines use private key file authentication.
#! @input private_key_file: Optional - Path to the private key file.
#! @input arguments: Optional - Arguments to pass to the command.
#! @input character_set: Optional - Character encoding used for input stream encoding from target machine.
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#! @input pty: Optional - Whether to use PTY.
#!             Valid: 'true', 'false'
#! @input timeout: Optional - Time in milliseconds to wait for the command to complete.
#! @input close_session: Optional - If false SSH session will be cached for future calls of this operation during life
#!                       of the flow, if true SSH session used by this operation will be closed.
#!                       Valid: 'true', 'false'
#! @input agent_forwarding: Optional - Whether to forward the user authentication agent.
#!
#! @output machines_id_list: Space delimited list of IDs of machines deployed in the CoreOS cluster.
#!
#! @result SUCCESS: Action was executed successfully and no error message is found in the STDERR.
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.coreos

imports:
  ssh: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings

flow:
  name: list_machines_id

  inputs:
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
    - command:
        default: "fleetctl list-machines | awk '{print $1}'"
        private: true

  workflow:
    - get_machine_public_ip:
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
          - machines_id_list: >
              ${return_result.replace("\n"," ").replace("MACHINE ","",1).replace("...", "")[:-1]
              if (return_code == '0' and (not 'ERROR' in standard_err)) else ''}
          - standard_err

    - check_error_in_stderr:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${standard_err}
            - string_to_find: 'ERROR'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: SUCCESS

  outputs:
    - machines_id_list
