#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description: CHEF TEST FLOW
#!               This flow tests Chef content
#!               - Extract cookbook in repository
#!               - Get community cookbooks
#!               - Get cookbook recepies
#!               - Get cookbook version
#!               - Get cookbooks
#!               - Search cookbooks in the community
#!               - Upload cookbook to server
#!!#
####################################################

namespace: io.cloudslang.chef

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh
  print: io.cloudslang.base.print

flow:
  name: test_chef_cookbook_actions
  inputs:
    # General inputs
    - cookbook_name
    - cookbook_version
    # Chef details
    - knife_host
    - knife_username
    - knife_password:
        required: false
    - knife_privkey:
        required: false
    - knife_config:
        required: false

  workflow:
    - chef_extract_cookbook_in_ropository:
        do:
          extract_cookbook_in_repo:
            - cookbook_name
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - return_result: ${knife_result}
          - standard_err

    - chef_get_community_cookbooks:
        do:
          get_community_cookbooks:
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - return_result: ${knife_result}
          - standard_err

    - chef_get_cookbook_recipes:
        do:
          get_cookbook_recipes:
            - cookbook_name
            - cookbook_version
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - return_result: ${knife_result}
          - standard_err

    - chef_get_cookbook_version:
        do:
          get_cookbook_version:
            - cookbook_name
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - return_result: ${knife_result}
          - standard_err

    - chef_get_cookbooks:
        do:
          get_cookbooks:
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - return_result: ${knife_result}
          - standard_err

    - chef_search_cookbooks_in_community:
        do:
          search_cookbooks_in_community:
            - cookbook_name
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - return_result: ${knife_result}
          - standard_err

    - chef_upload_cookbook_to_server:
        do:
          upload_cookbook_to_server:
            - cookbook_name
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
