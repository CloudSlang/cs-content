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
#! @description: Retrieves the public IP address of a machine (based on its ID) deployed in a CoreOS cluster.
#!
#! @input machine_id: ID of the machine.
#! @input host: CoreOS machine host.
#!              Can be any machine from the cluster.
#! @input port: Optional - SSH port.
#! @input username: CoreOS machine username.
#! @input password: Optional - CoreOS machine password.
#!                  Can be empty since CoreOS machines use private key file authentication.
#! @input private_key_file: Optional - Path to the private key file.
#! @input arguments: Optional - Arguments to pass to the command.
#! @input character_set: Optional - character encoding used for input stream encoding from target machine.
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#! @input pty: Optional - whether to use PTY.
#!             Valid: 'true', 'false'
#! @input timeout: Optional - Time in milliseconds to wait for the command to complete.
#! @input close_session: Optional - If false SSH session will be cached for future calls of this operation during life
#!                       of the flow, if true SSH session used by this operation will be closed.
#!                       Valid: 'true', 'false'
#!
#! @output public_ip: Public IP address of the machine based on its ID.
#!
#! @result SUCCESS: The action was executed successfully and no error message is found in the STDERR.
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.coreos

imports:
  ssh: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings

flow:
  name: get_machine_public_ip

  inputs:
    - machine_id
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
        default: 'true'
        private: true
    - command:
        default: "${'fleetctl --strict-host-key-checking=false  ssh ' + machine_id + ' cat /etc/environment'}"
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
          - public_ip: ${return_result[return_result.find('COREOS_PUBLIC_IPV4') + len('COREOS_PUBLIC_IPV4') + 1 :-1]}
          - standard_err

    - check_ssh_agent_in_stderr:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${standard_err}
            - string_to_find: 'ssh-agent'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: check_unable_in_stderr

    - check_unable_in_stderr:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${standard_err}
            - string_to_find: 'Unable'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: SUCCESS

  outputs:
    - public_ip
