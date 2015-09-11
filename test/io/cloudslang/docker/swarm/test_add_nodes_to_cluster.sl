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
    - agent_ip_addresses
    - agent_usernames
    - agent_passwords:
        required: false
    - agent_private_key_files:
        required: false
  workflow:
    - create_swarm_cluster:
        do:
          create_cluster:
            - host: manager_machine_ip
            - username: manager_machine_username
            - password: manager_machine_password
            - private_key_file: manager_machine_private_key_file
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
           - private_key_file: manager_machine_private_key_file
       navigate:
         SUCCESS: pre_clear_agent_machines
         FAILURE: PRE_CLEAR_MANAGER_MACHINE_PROBLEM

    - pre_clear_agent_machines:
        async_loop:
          for: ip in agent_ip_addresses
          do:
            containers.clear_containers:
              - docker_host: ip
              - docker_username: agent_usernames[0]
              - private_key_file: agent_private_key_files[0]
        navigate:
          SUCCESS: start_manager_container
          FAILURE: PRE_CLEAR_AGENT_MACHINES_PROBLEM
         
    - start_manager_container:
        do:
          start_manager:
            - swarm_port: swarm_manager_port
            - cluster_id
            - host: manager_machine_ip
            - username: manager_machine_username
            - password: manager_machine_password
            - private_key_file: manager_machine_private_key_file
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
            - password: manager_machine_password
            - private_key_file: manager_machine_private_key_file
        publish:
          - number_of_nodes_in_cluster_before: number_of_nodes_in_cluster
        navigate:
          SUCCESS: add_nodes_to_the_cluster
          FAILURE: GET_NUMBER_OF_NODES_IN_CLUSTER_BEFORE_PROBLEM

    - add_nodes_to_the_cluster:
        async_loop:
          for: ip in agent_ip_addresses
          do:
            register_agent:
              - node_ip: ip
              - cluster_id
              - host: ip
              - username: agent_usernames[0]
              - private_key_file: agent_private_key_files[0]
        navigate:
          SUCCESS: wait_for_nodes_to_join
          FAILURE: ADD_NODES_TO_THE_CLUSTER_PROBLEM

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
            - password: manager_machine_password
            - private_key_file: manager_machine_private_key_file
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
    - PRE_CLEAR_AGENT_MACHINES_PROBLEM
    - START_MANAGER_CONTAINER_PROBLEM
    - GET_NUMBER_OF_NODES_IN_CLUSTER_BEFORE_PROBLEM
    - ADD_NODES_TO_THE_CLUSTER_PROBLEM
    - GET_NUMBER_OF_NODES_IN_CLUSTER_AFTER_PROBLEM
    - VERIFY_NODE_IS_ADDED_PROBLEM
