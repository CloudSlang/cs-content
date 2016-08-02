#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
#!!
#! @description: Creates a new Swarm cluster, clears the machines, starts a Swarm manager, registers the Swarm agents
#!               and validates the agents were added.
#! @input manager_machine_ip: IP address of the machine with the Swarm manager container
#! @input manager_machine_username: username of the machine with the Swarm manager
#! @input manager_machine_password: optional - password of the machine with the Swarm manager
#! @input manager_machine_private_key_file: optional - path to private key file of the machine with the Swarm manager
#! @input manager_machine_port: port used by the Swarm manager container
#! @input agent_ip_addresses: list of IP addresses - the corresponding machines will be used as Swarm agents
#!                            Example: ['111.111.111.111', '111.111.111.222']
#! @input agent_usernames: list of usernames for agent machines - Example: [core, core]
#! @input agent_passwords: optional - list of password for agent machines - Example: [pass, pass]
#! @input agent_private_key_files: optional - list of paths to private key files for agent machines
#!                                 Example: ['foo/key_rsa', 'bar/key_rsa']
#! @input attempt: number of attempts to check whether nodes were added to the cluster
#!                 total waiting time ~ attempt * time_to_sleep
#!                 Default: '60'
#! @input time_to_sleep: time in seconds to sleep between successive checks of whether nodes were added to the cluster
#!                       total waiting time ~ attempt * time_to_sleep
#!                       Default: 5
#! @result SUCCESS: nodes were successfully added
#! @result CREATE_SWARM_CLUSTER_PROBLEM: problem occurred while creating the swarm cluster
#! @result PRE_CLEAR_MANAGER_MACHINE_PROBLEM: problem occurred while clearing the manager machine
#! @result PRE_CLEAR_AGENT_MACHINES_PROBLEM: problem occurred while clearing the agent machine
#! @result START_MANAGER_CONTAINER_PROBLEM: problem occurred while starting the manager container
#! @result ADD_NODES_TO_THE_CLUSTER_PROBLEM: problem occurred while adding nodes to the cluster
#! @result GET_NUMBER_OF_NODES_IN_CLUSTER_PROBLEM: problem occurred while retrieving the number of nodes
#! @result NODES_NOT_ADDED: nodes were not added
#!!#
########################################################################################################

namespace: io.cloudslang.docker.swarm

imports:
  swarm: io.cloudslang.docker.swarm
  containers: io.cloudslang.docker.containers
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils
  math: io.cloudslang.base.math

flow:
  name: create_cluster_with_nodes
  inputs:
    - manager_machine_ip
    - manager_machine_username
    - manager_machine_password:
        required: false
        sensitive: true
    - manager_machine_private_key_file:
        required: false
    - manager_machine_port
    - agent_ip_addresses
    - agent_usernames
    - agent_passwords:
        required: false
        sensitive: true
    - agent_private_key_files:
        required: false
    - attempts: 60
    - time_to_sleep: 5
  workflow:
    - create_swarm_cluster:
        do:
          swarm.create_cluster:
            - host: ${manager_machine_ip}
            - username: ${manager_machine_username}
            - password: ${manager_machine_password}
            - private_key_file: ${manager_machine_private_key_file}
        publish:
           - cluster_id
        navigate:
          - SUCCESS: pre_clear_manager_machine
          - FAILURE: CREATE_SWARM_CLUSTER_PROBLEM

    - pre_clear_manager_machine:
       do:
         containers.clear_containers:
           - docker_host: ${manager_machine_ip}
           - docker_username: ${manager_machine_username}
           - private_key_file: ${manager_machine_private_key_file}
       navigate:
         - SUCCESS: pre_clear_agent_machines
         - FAILURE: PRE_CLEAR_MANAGER_MACHINE_PROBLEM

    - pre_clear_agent_machines:
        parallel_loop:
          for: ip in agent_ip_addresses
          do:
            containers.clear_containers:
              - docker_host: ${ip}
              - docker_username: ${agent_usernames[0]}
              - private_key_file: ${agent_private_key_files[0]}
        navigate:
          - SUCCESS: start_manager_container
          - FAILURE: PRE_CLEAR_AGENT_MACHINES_PROBLEM

    - start_manager_container:
        do:
          swarm.start_manager:
            - swarm_port: ${manager_machine_port}
            - cluster_id
            - host: ${manager_machine_ip}
            - username: ${manager_machine_username}
            - password: ${manager_machine_password}
            - private_key_file: ${manager_machine_private_key_file}
        navigate:
          - SUCCESS: add_nodes_to_the_cluster
          - FAILURE: START_MANAGER_CONTAINER_PROBLEM

    - add_nodes_to_the_cluster:
        parallel_loop:
          for: ip in agent_ip_addresses
          do:
            swarm.register_agent:
              - node_ip: ${ip}
              - cluster_id
              - host: ${ip}
              - username: ${agent_usernames[0]}
              - private_key_file: ${agent_private_key_files[0]}
        navigate:
          - SUCCESS: get_number_of_nodes_in_cluster
          - FAILURE: ADD_NODES_TO_THE_CLUSTER_PROBLEM

    - get_number_of_nodes_in_cluster:
        do:
          swarm.get_cluster_info:
            - swarm_manager_ip: ${manager_machine_ip}
            - swarm_manager_port: ${manager_machine_port}
            - host: ${manager_machine_ip}
            - username: ${manager_machine_username}
            - password: ${manager_machine_password}
            - private_key_file: ${manager_machine_private_key_file}
        publish:
          - number_of_nodes_in_cluster: ${number_of_nodes_in_cluster}
        navigate:
          - SUCCESS: verify_node_is_added
          - FAILURE: GET_NUMBER_OF_NODES_IN_CLUSTER_PROBLEM

    - verify_node_is_added:
        do:
          strings.string_equals:
            - first_string: ${str(len(agent_ip_addresses))}
            - second_string: ${number_of_nodes_in_cluster}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: check_attempts

    - check_attempts:
        do:
          math.compare_numbers:
            - value1: ${attempts}
            - value2: 0
            - attempts
        publish:
          - attempts: ${int(attempts) - 1}
        navigate:
          - GREATER_THAN: sleep
          - EQUALS: NODES_NOT_ADDED
          - LESS_THAN: NODES_NOT_ADDED

    - sleep:
        do:
          utils.sleep:
            - seconds: ${time_to_sleep}
        navigate:
          - SUCCESS: get_number_of_nodes_in_cluster
          - FAILURE: NODES_NOT_ADDED
  results:
    - SUCCESS
    - CREATE_SWARM_CLUSTER_PROBLEM
    - PRE_CLEAR_MANAGER_MACHINE_PROBLEM
    - PRE_CLEAR_AGENT_MACHINES_PROBLEM
    - START_MANAGER_CONTAINER_PROBLEM
    - ADD_NODES_TO_THE_CLUSTER_PROBLEM
    - GET_NUMBER_OF_NODES_IN_CLUSTER_PROBLEM
    - NODES_NOT_ADDED
