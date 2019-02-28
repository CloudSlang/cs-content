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
#! @description: Removes a set of Chef roles and/or recipes from a node's run list.
#!
#! @input run_list_items: a list of roles and/or recipes to be removed
#!                        see https://docs.chef.io/knife_node.html#run-list-remove
#! @input node_name: name of the node to assign cookbooks to
#! @input knife_host: IP of server with configured knife accessible via SSH, can be main Chef server
#! @input knife_username: SSH username to access server with knife
#! @input knife_privkey: Optional - path to local SSH keyfile for accessing server with knife
#! @input knife_password: Optional - password to access server with knife
#! @input knife_config: Optional - location of knife.rb config file
#!
#! @output knife_result: filtered output of knife command
#! @output raw_result: full STDOUT
#! @output standard_err: Any STDERR
#!
#! @result SUCCESS: cookbooks were added to the run list
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.chef

imports:
  chef: io.cloudslang.chef

flow:
  name: run_list_remove

  inputs:
    - run_list_items
    - node_name
    - knife_host
    - knife_username
    - knife_privkey:
        required: false
    - knife_password:
        required: false
        sensitive: true
    - knife_config:
        required: false

  workflow:
    - remove_from_run_list:
        do:
          chef.knife_command:
            - knife_cmd: ${'node run_list remove ' + node_name + ' \\'' + run_list_items + '\\''}
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
    - knife_result: ${knife_result}
    - raw_result
    - standard_err: ${standard_err}
