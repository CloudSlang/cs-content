#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: TEST HP CLOUD FLOW
#!               This flow tests HP Cloud server content
#!               - Deploy server in HP Cloud with floating IP
#!               - Wait until server is active and booted up (SSH connect)
#!               - Terminate and delete the server
#!!#
####################################################

namespace: io.cloudslang.hp_cloud

imports:
  hpcloud: io.cloudslang.hp_cloud
  print: io.cloudslang.base.print
  net: io.cloudslang.base.network

flow:
  name: test_hpcloud_deploy_terminate
  inputs:
    # Main inputs
    - server_name
    # HP Cloud details
    - img_ref:     '43804523-7e3b-4adf-b6df-9d11d451c463'
    - flavor_ref:  '100'
    - keypair
    - username
    - password
    - region
    - tenant_name
    - proxy_host:
        required: false
    - proxy_port:
        required: false
  workflow:
    - build_instance:
        do:
          hpcloud.create_server_flow:
            - img_ref
            - flavor_ref
            - keypair
            - username
            - password
            - region
            - tenant_name
            - server_name
            - assign_floating: 'True'
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - ip_address
          - server_id

    - wait_for_server_up:
        do:
          net.wait_port_open:
            - host: ${ip_address}
            - port: '22'
            - timeout: '15'
            - tries: '50'

    - print_server_build:
        do:
          print.print_text:
            - text: ${'### Server (' + server_id + ') is active and booted. IP is ' + ip_address}
        navigate:
          - SUCCESS: terminate_server

    - terminate_server:
        do:
          hpcloud.delete_server_flow:
            - server_id
            - username
            - password
            - tenant_name
            - region
            - release_ip_address: "True"
            - ip_address
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - standard_err

    - on_failure:
      - test_flow_error:
          do:
            print.print_text:
              - text: ${'! Error in HP Cloud server deploy/terminate test flow' + return_result}
