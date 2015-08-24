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
  name: test_run_container_in_cluster
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
    - container_name: "'tomi'"
    - image_name: "'tomcat'"
    - agent_machine_ip_1
    - agent_machine_ip_2

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
            - agent_ip_addresses
            - agent_usernames: [username, username]
            - agent_passwords:
                default: [password, password]
                required: false
            - agent_private_key_files:
                default: [private_key_file, private_key_file]
                required: false
        navigate:
          SUCCESS: get_number_of_containers_in_cluster_before
          CREATE_SWARM_CLUSTER_PROBLEM: SETUP_CLUSTER_PROBLEM
          PRE_CLEAR_MANAGER_MACHINE_PROBLEM: SETUP_CLUSTER_PROBLEM
          PRE_CLEAR_AGENT_MACHINES_PROBLEM: SETUP_CLUSTER_PROBLEM
          START_MANAGER_CONTAINER_PROBLEM: SETUP_CLUSTER_PROBLEM
          GET_NUMBER_OF_NODES_IN_CLUSTER_BEFORE_PROBLEM: SETUP_CLUSTER_PROBLEM
          ADD_NODES_TO_THE_CLUSTER_PROBLEM: SETUP_CLUSTER_PROBLEM
          GET_NUMBER_OF_NODES_IN_CLUSTER_AFTER_PROBLEM: SETUP_CLUSTER_PROBLEM
          VERIFY_NODE_IS_ADDED_PROBLEM: SETUP_CLUSTER_PROBLEM

    - get_number_of_containers_in_cluster_before:
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
          - number_of_containers_in_cluster_before: number_of_containers_in_cluster
        navigate:
          SUCCESS: run_container_in_cluster
          FAILURE: GET_NUMBER_OF_CONTAINERS_IN_CLUSTER_BEFORE_PROBLEM

    - run_container_in_cluster:
        do:
          run_container_in_cluster:
            - swarm_manager_ip
            - swarm_manager_port
            - container_name
            - image_name
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
          - number_of_containers_in_cluster_after: number_of_containers_in_cluster
        navigate:
          SUCCESS: verify_container_created_in_cluster
          FAILURE: GET_NUMBER_OF_CONTAINERS_IN_CLUSTER_AFTER_PROBLEM

    - verify_container_created_in_cluster:
        do:
          strings.string_equals:
            - first_string: str(int(number_of_containers_in_cluster_before) + 1)
            - second_string: str(number_of_containers_in_cluster_after)
        navigate:
          SUCCESS: SUCCESS
          FAILURE: VERIFY_CONTAINER_CREATED_IN_CLUSTER_PROBLEM
  results:
    - SUCCESS
    - SETUP_CLUSTER_PROBLEM
    - FAILURE
    - GET_NUMBER_OF_CONTAINERS_IN_CLUSTER_BEFORE_PROBLEM
    - GET_NUMBER_OF_CONTAINERS_IN_CLUSTER_AFTER_PROBLEM
    - VERIFY_CONTAINER_CREATED_IN_CLUSTER_PROBLEM
