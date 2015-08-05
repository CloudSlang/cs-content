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
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils

flow:
  name: test_add_node_to_cluster
  inputs:
    - manager_machine_ip
    - manager_machine_username
    - manager_machine_password:
        required: false
    - manager_machine_private_key_file:
        required: false
    - swarm_manager_port
    - agent_machine_ip
    - agent_machine_username
    - agent_machine_password:
        required: false
    - agent_machine_private_key_file:
        required: false

  workflow:
    - create_swarm_cluster:
        do:
          swarm.create_cluster:
            - host: manager_machine_ip
            - username: manager_machine_username
            - password:
                default: manager_machine_password
                required: false
            - private_key_file:
                default: manager_machine_private_key_file
                required: false
        publish:
           - cluster_id
        navigate:
          SUCCESS: pre_clear_manager_machine
          FAILURE: CREATE_SWARM_CLUSTER_PROBLEM

    - pre_clear_manager_machine:
        do:
          maintenance.clear_host:
            - docker_host: manager_machine_ip
            - docker_username: manager_machine_username
            - docker_password:
                default: manager_machine_password
                required: false
            - private_key_file:
                default: manager_machine_private_key_file
                required: false
        navigate:
          SUCCESS: pre_clear_agent_machine
          FAILURE: PRE_CLEAR_MANAGER_MACHINE_PROBLEM

    - pre_clear_agent_machine:
        do:
          maintenance.clear_host:
            - docker_host: agent_machine_ip
            - docker_username: agent_machine_username
            - docker_password:
                default: agent_machine_password
                required: false
            - private_key_file:
                default: agent_machine_private_key_file
                required: false
        navigate:
          SUCCESS: start_manager_container
          FAILURE: PRE_CLEAR_AGENT_MACHINE_PROBLEM

    - start_manager_container:
        do:
          swarm.start_manager:
            - swarm_port: swarm_manager_port
            - cluster_id
            - host: manager_machine_ip
            - username: manager_machine_username
            - password:
                default: manager_machine_password
                required: false
            - private_key_file:
                default: manager_machine_private_key_file
                required: false
        navigate:
          SUCCESS: get_number_of_nodes_in_cluster_before
          FAILURE: START_MANAGER_CONTAINER_PROBLEM

    - get_number_of_nodes_in_cluster_before:
        do:
          swarm.get_cluster_info:
            - swarm_manager_ip: manager_machine_ip
            - swarm_manager_port: swarm_port
            - host: manager_machine_ip
            - username: manager_machine_username
            - password:
                default: manager_machine_password
                required: false
            - private_key_file:
                default: manager_machine_private_key_file
                required: false
        publish:
          - number_of_nodes_in_cluster_before: number_of_nodes_in_cluster
        navigate:
          SUCCESS: add_node_to_the_cluster
          FAILURE: GET_NUMBER_OF_NODES_IN_CLUSTER_BEFORE_PROBLEM

    - add_node_to_the_cluster:
        do:
          swarm.register_agent:
            - node_ip: agent_machine_ip
            - cluster_id
            - host: agent_machine_ip
            - username: agent_machine_username
            - password:
                default: agent_machine_password
                required: false
            - private_key_file:
                default: agent_machine_private_key_file
                required: false
        navigate:
          SUCCESS: wait_for_node_to_join
          FAILURE: ADD_NODE_TO_THE_CLUSTER_PROBLEM

    - wait_for_node_to_join:
        do:
          utils.sleep:
            - seconds: 20
        navigate:
          SUCCESS: get_number_of_nodes_in_cluster_after

    - get_number_of_nodes_in_cluster_after:
        do:
          swarm.get_cluster_info:
            - swarm_manager_ip: manager_machine_ip
            - swarm_manager_port: swarm_port
            - host: manager_machine_ip
            - username: manager_machine_username
            - password:
                default: manager_machine_password
                required: false
            - private_key_file:
                default: manager_machine_private_key_file
                required: false
        publish:
          - number_of_nodes_in_cluster_after: number_of_nodes_in_cluster
        navigate:
          SUCCESS: verify_node_is_added
          FAILURE: GET_NUMBER_OF_NODES_IN_CLUSTER_AFTER_PROBLEM

    - verify_node_is_added:
        do:
          strings.string_equals:
            - first_string: str(int(number_of_nodes_in_cluster_before) + 1)
            - second_string: number_of_nodes_in_cluster_after
        navigate:
          SUCCESS: post_clear_manager_machine
          FAILURE: VERIFY_NODE_IS_ADDED_PROBLEM

    - post_clear_manager_machine:
        do:
          maintenance.clear_host:
            - docker_host: manager_machine_ip
            - docker_username: manager_machine_username
            - docker_password:
                default: manager_machine_password
                required: false
            - private_key_file:
                default: manager_machine_private_key_file
                required: false
        navigate:
          SUCCESS: post_clear_agent_machine
          FAILURE: POST_CLEAR_MANAGER_MACHINE_PROBLEM

    - post_clear_agent_machine:
        do:
          maintenance.clear_host:
            - docker_host: agent_machine_ip
            - docker_username: agent_machine_username
            - docker_password:
                default: agent_machine_password
                required: false
            - private_key_file:
                default: agent_machine_private_key_file
                required: false
        navigate:
          SUCCESS: SUCCESS
          FAILURE: POST_CLEAR_AGENT_MACHINE_PROBLEM

  results:
    - SUCCESS
    - CREATE_SWARM_CLUSTER_PROBLEM
    - PRE_CLEAR_MANAGER_MACHINE_PROBLEM
    - PRE_CLEAR_AGENT_MACHINE_PROBLEM
    - START_MANAGER_CONTAINER_PROBLEM
    - GET_NUMBER_OF_NODES_IN_CLUSTER_BEFORE_PROBLEM
    - ADD_NODE_TO_THE_CLUSTER_PROBLEM
    - GET_NUMBER_OF_NODES_IN_CLUSTER_AFTER_PROBLEM
    - VERIFY_NODE_IS_ADDED_PROBLEM
    - POST_CLEAR_MANAGER_MACHINE_PROBLEM
    - POST_CLEAR_AGENT_MACHINE_PROBLEM
