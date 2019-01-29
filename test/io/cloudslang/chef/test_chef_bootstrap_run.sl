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
#! @description: CHEF TEST FLOW
#!               This flow tests Chef content
#!               - Chef bootstrap existing Linux host
#!               - Assign Chef cookbook(s)
#!               - Run Chef client
#!!#
########################################################################################################################

namespace: io.cloudslang.chef

imports:
  chef: io.cloudslang.chef
  ssh: io.cloudslang.base.ssh
  print: io.cloudslang.base.print

flow:
  name: test_chef_bootstrap_run

  inputs:
    # General inputs
    - node_host
    - node_name
    # Chef details
    - run_list_items
    - knife_host
    - knife_username
    - knife_password:
        required: false
    - knife_privkey:
        required: false
    - node_username
    - node_privkey_remote:
        required: false
    - node_privkey_local:
        required: false
    - node_password:
        required: false
    - knife_config:
        required: false

  workflow:
    - chef_bootstrap:
        do:
          chef.bootstrap_node:
            - node_host
            - node_name
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - node_username
            - node_password
            - node_privkey: ${node_privkey_remote}
            - knife_config
        publish:
          - return_result: ${knife_result}
          - standard_err
          - node_name: ${new_node_name}

    - chef_assign_cookbooks:
        do:
          chef.run_list_add:
            - run_list_items
            - node_name
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - return_result: ${knife_result}
          - standard_err

    - chef_run_client:
        do:
          ssh.ssh_command:
            - host: ${node_host}
            - username: ${node_username}
            - password: ${node_password}
            - private_key_file: ${node_privkey_local}
            - command: 'sudo chef-client'
            - timeout: '600000'
        publish:
          - return_result: ${returnResult}
          - standard_err

    - chef_remove_cookbooks:
        do:
          chef.run_list_remove:
            - run_list_items
            - node_name
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - return_result: ${knife_result}
          - standard_err

    - chef_remove_node_and_uninstall:
        do:
          chef.delete_node_uninstall:
            - node_name
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - node_host
            - node_username
            - node_privkey: ${node_privkey_local}
            - node_password
            - knife_config
        publish:
          - return_result: ${knife_result}
          - standard_err
          - node_name

    - chef_get_nodes:
        do:
          chef.get_nodes:
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - return_result: ${knife_result}
          - standard_err

    - chef_get_roles:
        do:
          chef.get_roles:
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - return_result: ${knife_result}
          - standard_err

    - chef_get_users:
        do:
          chef.get_users:
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - return_result: ${knife_result}
          - standard_err

    - chef_ssl_check:
        do:
          chef.ssl_check:
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - return_result: ${knife_result}
          - standard_err

    - on_failure:
      - ERROR:
          do:
            print.print_text:
              - text: ${'! Error in Chef test flow ' + return_result}
