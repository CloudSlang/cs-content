#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
# Wrapper test flow - checks whether the Swarm cluster is clean (in that case starts a container in the
# cluster so the cluster will contain at least one container that is not Swarm agent), clears the cluster
# and verifies that the number of containers in the cluster is the number of agent containers.
########################################################################################################

namespace: io.cloudslang.docker.swarm

imports:
  swarm: io.cloudslang.docker.swarm
  strings: io.cloudslang.base.strings

flow:
  name: test_clear_swarm_cluster
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
    - number_of_agent_containers_in_cluster

  workflow:
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
          SUCCESS: check_cluster_is_clean
          FAILURE: GET_NUMBER_OF_CONTAINERS_IN_CLUSTER_BEFORE_PROBLEM

    - check_cluster_is_clean:
        do:
          strings.string_equals:
            - first_string: str(number_of_containers_in_cluster_before)
            - second_string: str(number_of_agent_containers_in_cluster)
        navigate:
          SUCCESS: run_container_in_cluster
          FAILURE: clear_cluster

    - run_container_in_cluster:
        do:
          swarm.run_container_in_cluster:
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
        navigate:
          SUCCESS: clear_cluster
          FAILURE: RUN_CONTAINER_IN_CLUSTER_PROBLEM

    - clear_cluster:
       do:
         swarm.clear_swarm_cluster:
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
         SUCCESS: get_number_of_containers_in_cluster_after
         FAILURE: FAILURE

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
          SUCCESS: verify_cluster_is_cleared
          FAILURE: GET_NUMBER_OF_CONTAINERS_IN_CLUSTER_AFTER_PROBLEM

    - verify_cluster_is_cleared:
        do:
          strings.string_equals:
            - first_string: str(number_of_agent_containers_in_cluster)
            - second_string: str(number_of_containers_in_cluster_after)
        navigate:
          SUCCESS: SUCCESS
          FAILURE: VERIFY_CLUSTER_IS_CLEARED_PROBLEM
  results:
    - SUCCESS
    - FAILURE
    - GET_NUMBER_OF_CONTAINERS_IN_CLUSTER_BEFORE_PROBLEM
    - RUN_CONTAINER_IN_CLUSTER_PROBLEM
    - GET_NUMBER_OF_CONTAINERS_IN_CLUSTER_AFTER_PROBLEM
    - VERIFY_CLUSTER_IS_CLEARED_PROBLEM
