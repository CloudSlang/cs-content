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
  containers: io.cloudslang.docker.containers
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils

flow:
  name: test_add_nodes_to_cluster
  inputs:
    - manager_machine_ip
    - manager_machine_username
    - manager_machine_password:
        required: false
    - manager_machine_private_key_file:
        required: false
    - swarm_manager_port
    - agent_machine_ip_1
    - agent_machine_username_1
    - agent_machine_password_1:
        required: false
    - agent_machine_private_key_file_1:
        required: false
    - agent_machine_ip_2
    - agent_machine_username_2
    - agent_machine_password_2:
        required: false
    - agent_machine_private_key_file_2:
        required: false
        
  workflow:
    - create_swarm_cluster:
        do:
          create_cluster:
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
         containers.clear_containers:
           - docker_host: manager_machine_ip
           - docker_username: manager_machine_username
           - private_key_file:
              default: manager_machine_private_key_file
              required: false
       navigate:
         SUCCESS: pre_clear_agent_machine_1
         FAILURE: PRE_CLEAR_MANAGER_MACHINE_PROBLEM

    - pre_clear_agent_machine_1:
       do:
         containers.clear_containers:
           - docker_host: agent_machine_ip_1
           - docker_username: agent_machine_username_1
           - private_key_file:
              default: agent_machine_private_key_file_1
              required: false
       navigate:
         SUCCESS: pre_clear_agent_machine_2
         FAILURE: PRE_CLEAR_AGENT_MACHINE_PROBLEM_1

    - pre_clear_agent_machine_2:
       do:
         containers.clear_containers:
           - docker_host: agent_machine_ip_2
           - docker_username: agent_machine_username_2
           - private_key_file:
              default: agent_machine_private_key_file_2
              required: false
       navigate:
         SUCCESS: start_manager_container
         FAILURE: PRE_CLEAR_AGENT_MACHINE_PROBLEM_2
         
    - start_manager_container:
        do:
          start_manager:
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
          get_cluster_info:
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
          SUCCESS: add_node_to_the_cluster_1
          FAILURE: GET_NUMBER_OF_NODES_IN_CLUSTER_BEFORE_PROBLEM

    - add_node_to_the_cluster_1:
        do:
          register_agent:
            - node_ip: agent_machine_ip_1
            - cluster_id
            - host: agent_machine_ip_1
            - username: agent_machine_username_1
            - password:
                default: agent_machine_password_1
                required: false
            - private_key_file:
                default: agent_machine_private_key_file_1
                required: false
        navigate:
          SUCCESS: wait_for_nodes_to_join
          FAILURE: ADD_NODE_TO_THE_CLUSTER_PROBLEM_1

    - add_node_to_the_cluster_2:
        do:
          register_agent:
            - node_ip: agent_machine_ip_2
            - cluster_id
            - host: agent_machine_ip_2
            - username: agent_machine_username_2
            - password:
                default: agent_machine_password_2
                required: false
            - private_key_file:
                default: agent_machine_private_key_file_2
                required: false
        navigate:
          SUCCESS: wait_for_nodes_to_join
          FAILURE: ADD_NODE_TO_THE_CLUSTER_PROBLEM_2
          
    - wait_for_nodes_to_join:
        do:
          utils.sleep:
            - seconds: 20
        navigate:
          SUCCESS: get_number_of_nodes_in_cluster_after

    - get_number_of_nodes_in_cluster_after:
        do:
          get_cluster_info:
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
            - first_string: str(int(number_of_nodes_in_cluster_before) + 2)
            - second_string: number_of_nodes_in_cluster_after
        navigate:
          SUCCESS: SUCCESS
          FAILURE: VERIFY_NODE_IS_ADDED_PROBLEM

  results:
    - SUCCESS
    - CREATE_SWARM_CLUSTER_PROBLEM
    - PRE_CLEAR_MANAGER_MACHINE_PROBLEM
    - PRE_CLEAR_AGENT_MACHINE_PROBLEM_1
    - PRE_CLEAR_AGENT_MACHINE_PROBLEM_2
    - START_MANAGER_CONTAINER_PROBLEM
    - GET_NUMBER_OF_NODES_IN_CLUSTER_BEFORE_PROBLEM
    - ADD_NODE_TO_THE_CLUSTER_PROBLEM_1
    - ADD_NODE_TO_THE_CLUSTER_PROBLEM_2
    - GET_NUMBER_OF_NODES_IN_CLUSTER_AFTER_PROBLEM
    - VERIFY_NODE_IS_ADDED_PROBLEM
