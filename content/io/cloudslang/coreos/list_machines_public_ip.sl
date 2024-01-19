#   Copyright 2024 Open Text
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
#! @description: Retrieves the public IPs of machines in a CoreOS cluster.
#!
#! @input coreos_host: CoreOS machine host.
#!                     Can be any machine from the cluster.
#! @input coreos_username: CoreOS machine username.
#! @input coreos_password: Optional - CoreOS machine password.
#!                         Can be empty since CoreOS machines use private key file authentication.
#! @input private_key_file: Optional - Path to the private key file.
#! @input timeout: Optional - Time in milliseconds to wait for the command to complete.
#!
#! @output machines_public_ip_list: List of public IP addresses of the machines in the cluster (delimiter: space).
#!
#! @result SUCCESS: Public IPs retrieved successfully.
#! @result FAILURE: There was an error while trying to retrieve the public IPs from the servers.
#!!#
########################################################################################################################

namespace: io.cloudslang.coreos

imports:
  coreos: io.cloudslang.coreos

flow:
  name: list_machines_public_ip

  inputs:
    - coreos_host
    - coreos_username
    - coreos_password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - timeout:
        required: false
    - machines_public_ip_list_var:
        default: ''
        required: false
        private: true

  workflow:
    - list_ids_of_the_machines:
        do:
          coreos.list_machines_id:
            - host: ${coreos_host}
            - username: ${coreos_username}
            - password: ${coreos_password}
            - private_key_file
            - timeout
        publish:
          - machines_id_list

    - get_machine_public_ip:
        loop:
          for: machine_id in machines_id_list.split()
          do:
            coreos.get_machine_public_ip:
              - machine_id
              - host: ${coreos_host}
              - username: ${coreos_username}
              - password: ${coreos_password}
              - private_key_file
              - timeout
              - machines_public_ip_list_var
          publish:
            - machines_public_ip_list_var: ${machines_public_ip_list_var + public_ip + ' '}

  outputs:
    - machines_public_ip_list: ${machines_public_ip_list_var.strip()}
