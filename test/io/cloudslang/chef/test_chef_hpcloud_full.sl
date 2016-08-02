#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description: CHEF AND HP CLOUD FULL TEST DEPLOYMENT FLOW
#!               This flow tests both HP Cloud and Chef content
#!               - Deploy server in HP Cloud with floating IP
#!               - Wait until server is active and booted up (SSH connect)
#!               - Chef bootstrap the server
#!               - Assign Chef cookbooks (e.g. Tomcat or Apache)
#!               - Run Chef client
#!               - Check deployed app is installed and running (port 8080 or 80 test)
#!!#
####################################################

namespace: io.cloudslang.chef

imports:
  hpcloud: io.cloudslang.cloud.hp_cloud
  print: io.cloudslang.base.print
  chef: io.cloudslang.chef
  ssh: io.cloudslang.base.ssh
  net: io.cloudslang.base.network

flow:
  name: test_chef_hpcloud_full

  inputs:
    # General inputs
    - server_name
    - app_port
    # HP Cloud details
    - img_ref
    - flavor_ref
    - cloud_user
    - cloud_pwd
    - region
    - keypair
    - tenant_name
    # Chef details
    - run_list_items
    - knife_host
    - knife_username
    - knife_password:
        default: ''
        required: false
    - knife_privkey:
        default: ''
        required: false
    - node_username
    - node_privkey_remote:
        default: ''
        required: false
    - node_privkey_local:
        default: ''
        required: false
    - node_password:
        default: ''
        required: false
    - knife_config:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - build_hpcloud_instance:
        do:
          hpcloud.create_server_flow:
            - img_ref
            - flavor_ref
            - keypair
            - username: ${cloud_user}
            - password: ${cloud_pwd}
            - region
            - tenant_name
            - server_name
            - assign_floating: True
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - ip_address

    - wait_for_server_up:
        do:
          net.wait_port_open:
            - host: ${ip_address}
            - port: '22'
            - timeout: '15'
            - tries: '20'

    - chef_bootstrap:
        do:
          chef.bootstrap_node:
            - node_host: ${ip_address}
            - node_name: ${server_name + '_' + ip_address}
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
            - node_username
            - node_password
            - node_privkey: ${node_privkey_remote}
            - knife_config
        publish:
          - return_result: ${knife_result}
          - standard_err

    - chef_run_client:
        do:
          ssh.ssh_command:
            - host: ${ip_address}
            - username: ${node_username}
            - password: ${node_password}
            - private_key_file: ${node_privkey_local}
            - command: 'sudo chef-client'
            - timeout: '600000'
            - knife_config
        publish:
          - return_result
          - standard_err

    - check_app:
        do:
          net.verify_url_is_accessible:
            - url: ${'http://' + ip_address + ":" + app_port}
            - attempts: 300
        publish:
          - return_result: ${output_message}

    - print_result:
        do:
          print.print_text:
            - text: ${'### Done! Server is active and app installed; ' + ip_address + ':' + app_port}

    - on_failure:
      - ERROR:
          do:
            print.print_text:
              - text: >
                  ${'! Error in HP Cloud and Chef deployment flow:  ' + return_result}
