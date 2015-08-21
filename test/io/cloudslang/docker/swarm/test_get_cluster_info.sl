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
  strings: io.cloudslang.base.strings

flow:
  name: test_get_cluster_info
  inputs:
    - swarm_manager_ip
    - swarm_manager_port
    - number_of_agent_containers_in_cluster
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
    - agent_machine_ip

  workflow:
    - setup_cluster:
        do:
          test_add_nodes_to_cluster:
            - manager_machine_ip: swarm_manager_ip
            - manager_machine_username: username
            - manager_machine_password:
                default: password
                required: false
            - manager_machine_private_key_file:
                default: private_key_file
                required: false
            - swarm_manager_port
            - agent_machine_ip
            - agent_machine_username: username
            - agent_machine_password:
                default: password
                required: false
            - agent_machine_private_key_file:
                default: private_key_file
                required: false
        navigate:
          SUCCESS: get_cluster_info
          CREATE_SWARM_CLUSTER_PROBLEM: SETUP_CLUSTER_PROBLEM
          PRE_CLEAR_MANAGER_MACHINE_PROBLEM: SETUP_CLUSTER_PROBLEM
          PRE_CLEAR_AGENT_MACHINE_PROBLEM_1: SETUP_CLUSTER_PROBLEM
          PRE_CLEAR_AGENT_MACHINE_PROBLEM_2: SETUP_CLUSTER_PROBLEM
          START_MANAGER_CONTAINER_PROBLEM: SETUP_CLUSTER_PROBLEM
          GET_NUMBER_OF_NODES_IN_CLUSTER_BEFORE_PROBLEM: SETUP_CLUSTER_PROBLEM
          ADD_NODE_TO_THE_CLUSTER_PROBLEM_1: SETUP_CLUSTER_PROBLEM
          ADD_NODE_TO_THE_CLUSTER_PROBLEM_2: SETUP_CLUSTER_PROBLEM
          GET_NUMBER_OF_NODES_IN_CLUSTER_AFTER_PROBLEM: SETUP_CLUSTER_PROBLEM
          VERIFY_NODE_IS_ADDED_PROBLEM: SETUP_CLUSTER_PROBLEM

    - get_cluster_info:
        do:
          get_cluster_info:
            - swarm_manager_ip
            - swarm_manager_port
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
          - number_of_containers_in_cluster

    - verify_number_of_containers_in_cluster:
        do:
          strings.string_equals:
            - first_string: str(number_of_agent_containers_in_cluster)
            - second_string: number_of_containers_in_cluster
        navigate:
          SUCCESS: SUCCESS
          FAILURE: VERIFY_NUMBER_OF_CONTAINERS_IN_CLUSTER_PROBLEM
  results:
    - SUCCESS
    - SETUP_CLUSTER_PROBLEM
    - FAILURE
    - VERIFY_NUMBER_OF_CONTAINERS_IN_CLUSTER_PROBLEM
