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

  workflow:
    - clear_swarm_cluster:
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
         SUCCESS: get_cluster_info
         FAILURE: CLEAR_SWARM_CLUSTER_PROBLEM

    - get_cluster_info:
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
    - FAILURE
    - CLEAR_SWARM_CLUSTER_PROBLEM
    - VERIFY_NUMBER_OF_CONTAINERS_IN_CLUSTER_PROBLEM
