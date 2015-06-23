#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.consul

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh
  consul: io.cloudslang.consul
  base_utils: io.cloudslang.base.utils
  maintenance: io.cloudslang.docker.maintenance

flow:
  name: test_consul_keys
  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - private_key_file:
        required: false
    - key_name

  workflow:
    - clear_docker_host_prerequest:
       do:
         maintenance.clear_docker_host:
           - docker_host: host
           - port:
               required: false
           - docker_username: username
           - docker_password:
               default: password
               required: false
           - private_key_file:
               required: false
       navigate:
         SUCCESS: start_consul_container
         FAILURE: PREREQUEST_MACHINE_IS_NOT_CLEAN
    - start_consul_container:
        do:
          ssh.ssh_flow:
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - privateKeyFile:
                default: private_key_file
                required: false
            - command: "'docker run -d -p 8500:8500 -p 8600:8600/udp fhalim/consul'"
        navigate:
          SUCCESS: wait_for_container_startup
          FAILURE: FAIL_STARTING_CONTAINER
    - wait_for_container_startup:
        do:
          base_utils.sleep:
            - seconds: "'5'"
        navigate:
          SUCCESS: create_key
    - create_key:
        do:
          consul.create_kv:
            - host
            - key_name
        navigate:
          SUCCESS: get_key
          FAILURE: FAIL_CREATING_KEY
    - get_key:
        do:
          consul.report_kv:
            - host
            - key_name
        publish:
          - create_index
          - update_index
          - lock_index
          - key
          - flags
          - value
        navigate:
          SUCCESS: delete_key
          FAILURE: FAIL_GETTING_KEY
    - delete_key:
        do:
          consul.delete_kv:
            - host
            - key_name
        navigate:
          SUCCESS: clear_docker_host
          FAILURE: FAIL_DELETING_KEY
    - clear_docker_host:
        do:
         maintenance.clear_docker_host:
           - docker_host: host
           - port:
               required: false
           - docker_username: username
           - docker_password:
               default: password
               required: false
           - private_key_file:
               required: false
        navigate:
         SUCCESS: SUCCESS
         FAILURE: MACHINE_IS_NOT_CLEAN

  outputs:
    - create_index
    - update_index
    - lock_index
    - key
    - flags
    - value
  results:
    - SUCCESS
    - FAIL_STARTING_CONTAINER
    - FAIL_CREATING_KEY
    - FAIL_DELETING_KEY
    - FAIL_GETTING_KEY
    - PREREQUEST_MACHINE_IS_NOT_CLEAN
    - MACHINE_IS_NOT_CLEAN