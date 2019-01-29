#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################

namespace: io.cloudslang.docker.swarm

imports:
  swarm: io.cloudslang.docker.swarm
  examples: io.cloudslang.docker.swarm.examples
  strings: io.cloudslang.base.strings

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
    - agent_ip_addresses
    - attempts:
        required: false
    - time_to_sleep:
        required: false

  workflow:
    - setup_cluster:
        do:
          swarm.create_cluster_with_nodes:
            - manager_machine_ip: ${swarm_manager_ip}
            - manager_machine_username: ${username}
            - manager_machine_password: ${password}
            - manager_machine_private_key_file: ${private_key_file}
            - manager_machine_port: ${swarm_manager_port}
            - agent_ip_addresses
            - agent_usernames: ${username + "," + username}
            - agent_passwords: ${get(password,"") + "," + get(password,"")}
            - agent_private_key_files: ${private_key_file + "," + private_key_file}
            - attempts
            - time_to_sleep
        navigate:
          - SUCCESS: get_number_of_containers_in_cluster_before
          - CREATE_SWARM_CLUSTER_PROBLEM: SETUP_CLUSTER_PROBLEM
          - PRE_CLEAR_MANAGER_MACHINE_PROBLEM: SETUP_CLUSTER_PROBLEM
          - PRE_CLEAR_AGENT_MACHINES_PROBLEM: SETUP_CLUSTER_PROBLEM
          - START_MANAGER_CONTAINER_PROBLEM: SETUP_CLUSTER_PROBLEM
          - ADD_NODES_TO_THE_CLUSTER_PROBLEM: SETUP_CLUSTER_PROBLEM
          - GET_NUMBER_OF_NODES_IN_CLUSTER_PROBLEM: SETUP_CLUSTER_PROBLEM
          - NODES_NOT_ADDED: SETUP_CLUSTER_PROBLEM

    - get_number_of_containers_in_cluster_before:
        do:
          swarm.get_cluster_info:
            - swarm_manager_ip
            - swarm_manager_port
            - host
            - port
            - username
            - password
            - private_key_file
            - timeout
        publish:
          - number_of_containers_in_cluster_before: ${number_of_containers_in_cluster}
        navigate:
          - SUCCESS: run_demo_containers
          - FAILURE: GET_NUMBER_OF_CONTAINERS_IN_CLUSTER_BEFORE_PROBLEM

    - run_demo_containers:
        do:
          examples.demo_containers:
            - swarm_manager_ip
            - swarm_manager_port
            - host
            - port
            - username
            - password
            - private_key_file
            - timeout

    - get_number_of_containers_in_cluster_after:
        do:
          swarm.get_cluster_info:
            - swarm_manager_ip
            - swarm_manager_port
            - host
            - port
            - username
            - password
            - private_key_file
            - timeout
        publish:
          - number_of_containers_in_cluster_after: ${number_of_containers_in_cluster}
        navigate:
          - SUCCESS: verify_containers_created_in_cluster
          - FAILURE: GET_NUMBER_OF_CONTAINERS_IN_CLUSTER_AFTER_PROBLEM

    - verify_containers_created_in_cluster:
        do:
          strings.string_equals:
            - first_string: ${str(int(number_of_containers_in_cluster_before) + 2)}
            - second_string: ${str(number_of_containers_in_cluster_after)}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: VERIFY_CONTAINERS_CREATED_IN_CLUSTER_PROBLEM
  results:
    - SUCCESS
    - SETUP_CLUSTER_PROBLEM
    - FAILURE
    - GET_NUMBER_OF_CONTAINERS_IN_CLUSTER_BEFORE_PROBLEM
    - GET_NUMBER_OF_CONTAINERS_IN_CLUSTER_AFTER_PROBLEM
    - VERIFY_CONTAINERS_CREATED_IN_CLUSTER_PROBLEM
