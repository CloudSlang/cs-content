#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.docker.swarm

imports:
  maintenance: io.cloudslang.docker.maintenance
  swarm: io.cloudslang.docker.swarm
  containers: io.cloudslang.docker.containers
  strings: io.cloudslang.base.strings

flow:
  name: test_register_swarm_agent
  inputs:
    - node_ip
    - cluster_id
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - private_key_file:
        required: false
    - timeout:
        required: false

  workflow:
    - pre_clear_machine:
        do:
          maintenance.clear_docker_host:
            - docker_host: host
            - docker_username: username
            - docker_password:
                default: password
                required: false
            - private_key_file:
                required: false
            - timeout:
                required: false
            - port:
                required: false
        navigate:
          SUCCESS: register_swarm_agent
          FAILURE: PRE_CLEAR_MACHINE_PROBLEM

    - register_swarm_agent:
        do:
          swarm.register_swarm_agent:
            - node_ip
            - cluster_id
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - private_key_file:
                required: false
            - timeout:
                required: false
        publish:
          - expected_container_id: agent_container_ID
        navigate:
          SUCCESS: get_running_container_ids
          FAILURE: FAILURE

    - get_running_container_ids:
        do:
          containers.get_all_containers:
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - private_key_file:
                required: false
            - timeout:
                required: false
        publish:
          - actual_container_id: container_list
        navigate:
          SUCCESS: verify_container_is_running
          FAILURE: GET_RUNNING_CONTAINER_IDS_PROBLEM

    - verify_container_is_running:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: expected_container_id
            - string_to_find: actual_container_id
        navigate:
          SUCCESS: post_clear_machine
          FAILURE: VERIFY_CONTAINER_IS_RUNNING_PROBLEM

    - post_clear_machine:
        do:
          maintenance.clear_docker_host:
            - docker_host: host
            - docker_username: username
            - docker_password:
                default: password
                required: false
            - private_key_file:
                required: false
            - timeout:
                required: false
            - port:
                required: false
        navigate:
          SUCCESS: SUCCESS
          FAILURE: POST_CLEAR_MACHINE_PROBLEM
  results:
    - SUCCESS
    - FAILURE
    - PRE_CLEAR_MACHINE_PROBLEM
    - GET_RUNNING_CONTAINER_IDS_PROBLEM
    - VERIFY_CONTAINER_IS_RUNNING_PROBLEM
    - POST_CLEAR_MACHINE_PROBLEM
