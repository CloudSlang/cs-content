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
#! @description: Remove node and client from Chef, delete /etc/chef folder on node.
#!
#! @input node_name: name of node in Chef to be deleted
#! @input knife_host: IP of server with configured knife accessible via SSH, can be main Chef server
#! @input knife_username: SSH username to access server with knife
#! @input knife_password: Optional - password to access server with knife
#! @input knife_privkey: Optional - path to local SSH keyfile for accessing server with knife
#! @input knife_config: Optional - location of knife.rb config file
#!
#! @output knife_result: filtered output of knife command
#! @output raw_result: full STDOUT
#! @output standard_err: Any STDERR
#!
#! @result SUCCESS: node deleted OK
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.chef

imports:
  ssh: io.cloudslang.base.ssh
  chef: io.cloudslang.chef

flow:
  name: delete_node

  inputs:
    - node_name
    - knife_host
    - knife_username
    - knife_password:
        required: false
        sensitive: true
    - knife_privkey:
        required: false
    - knife_config:
        required: false

  workflow:
    - remove_client:
        do:
          chef.knife_command:
            - knife_cmd: ${'client delete ' + node_name + ' -y'}
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - raw_result
          - standard_err
          - knife_result

    - remove_node:
        do:
          chef.knife_command:
            - knife_cmd: ${'node delete ' + node_name + ' -y'}
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - raw_result
          - standard_err
          - knife_result

  outputs:
    - knife_result
    - raw_result
    - standard_err
