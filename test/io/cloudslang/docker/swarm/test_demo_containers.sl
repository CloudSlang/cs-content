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
  swarm: io.cloudslang.docker.swarm
  strings: io.cloudslang.base.strings
  swarm_examples: io.cloudslang.docker.swarm.examples

flow:
  name: test_demo_containers
  inputs:
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
    - agent_machine_ip

  workflow:
    - setup_cluster:
        do:
          test_add_node_to_cluster:
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
          SUCCESS: pre_clear_swarm_cluster
          CREATE_SWARM_CLUSTER_PROBLEM: SETUP_CLUSTER_PROBLEM
          PRE_CLEAR_MANAGER_MACHINE_PROBLEM: SETUP_CLUSTER_PROBLEM
          PRE_CLEAR_AGENT_MACHINE_PROBLEM: SETUP_CLUSTER_PROBLEM
          START_MANAGER_CONTAINER_PROBLEM: SETUP_CLUSTER_PROBLEM
          GET_NUMBER_OF_NODES_IN_CLUSTER_BEFORE_PROBLEM: SETUP_CLUSTER_PROBLEM
          ADD_NODE_TO_THE_CLUSTER_PROBLEM: SETUP_CLUSTER_PROBLEM
          GET_NUMBER_OF_NODES_IN_CLUSTER_AFTER_PROBLEM: SETUP_CLUSTER_PROBLEM
          VERIFY_NODE_IS_ADDED_PROBLEM: SETUP_CLUSTER_PROBLEM

    - pre_clear_swarm_cluster:
       do:
         swarm.clear_cluster:
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
       navigate:
         SUCCESS: get_number_of_containers_in_cluster_before
         FAILURE: PRE_CLEAR_SWARM_CLUSTER_PROBLEM

    - get_number_of_containers_in_cluster_before:
        do:
          swarm.get_cluster_info:
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
          - number_of_containers_in_cluster_before: number_of_containers_in_cluster
        navigate:
          SUCCESS: run_demo_containers
          FAILURE: GET_NUMBER_OF_CONTAINERS_IN_CLUSTER_BEFORE_PROBLEM

    - run_demo_containers:
        do:
          swarm_examples.demo_containers:
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

    - get_number_of_containers_in_cluster_after:
        do:
          swarm.get_cluster_info:
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
          - number_of_containers_in_cluster_after: number_of_containers_in_cluster
        navigate:
          SUCCESS: verify_containers_created_in_cluster
          FAILURE: GET_NUMBER_OF_CONTAINERS_IN_CLUSTER_AFTER_PROBLEM

    - verify_containers_created_in_cluster:
        do:
          strings.string_equals:
            - first_string: str(int(number_of_containers_in_cluster_before) + 2)
            - second_string: str(number_of_containers_in_cluster_after)
        navigate:
          SUCCESS: post_clear_swarm_cluster
          FAILURE: VERIFY_CONTAINERS_CREATED_IN_CLUSTER_PROBLEM

    - post_clear_swarm_cluster:
       do:
         swarm.clear_cluster:
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
       navigate:
         SUCCESS: SUCCESS
         FAILURE: POST_CLEAR_SWARM_CLUSTER_PROBLEM
  results:
    - SUCCESS
    - SETUP_CLUSTER_PROBLEM
    - FAILURE
    - PRE_CLEAR_SWARM_CLUSTER_PROBLEM
    - GET_NUMBER_OF_CONTAINERS_IN_CLUSTER_BEFORE_PROBLEM
    - GET_NUMBER_OF_CONTAINERS_IN_CLUSTER_AFTER_PROBLEM
    - VERIFY_CONTAINERS_CREATED_IN_CLUSTER_PROBLEM
    - POST_CLEAR_SWARM_CLUSTER_PROBLEM
