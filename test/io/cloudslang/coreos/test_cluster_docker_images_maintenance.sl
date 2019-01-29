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
#!!
#! @description: Wrapper flow - logic steps:
#!               - retrieves the ip addresses of the machines in the cluster
#!               - cleanup on the machines (so they will not contain any images)
#!               - prepares a used and an unused Docker image
#!               - runs the flow
#!               - verifies only one image remained in the cluster
#!               - delete the used image
#!!#
####################################################

namespace: io.cloudslang.coreos

imports:
  coreos: io.cloudslang.coreos
  maintenance: io.cloudslang.docker.maintenance
  images: io.cloudslang.docker.images
  containers: io.cloudslang.docker.containers
  strings: io.cloudslang.base.strings

flow:
  name: test_cluster_docker_images_maintenance

  inputs:
    - coreos_host
    - coreos_username
    - coreos_password:
        required: false
    - private_key_file:
        required: false
    - percentage:
        required: false
    - timeout:
        required: false
    - unused_image_name: 'alpine'
    - used_image_name: 'busybox'
    - number_of_images_in_cluster:
        default: "0"
        private: true

  workflow:
    - list_machines_public_ip:
        do:
          coreos.list_machines_public_ip:
            - coreos_host
            - coreos_username
            - coreos_password
            - private_key_file
            - timeout
        publish:
            - machines_public_ip_list
        navigate:
          - SUCCESS: clear_docker_hosts_in_cluster
          - FAILURE: LIST_MACHINES_PROBLEM

    - clear_docker_hosts_in_cluster:
          loop:
              for: machine_public_ip in machines_public_ip_list.split(' ')
              do:
                  maintenance.clear_host:
                     - docker_host: ${machine_public_ip}
                     - port
                     - docker_username: ${coreos_username}
                     - docker_password: ${coreos_password}
                     - private_key_file
              navigate:
                - SUCCESS: pull_unused_image
                - FAILURE: CLEAR_DOCKER_HOSTS_IN_CLUSTER_PROBLEM

    - pull_unused_image:
        do:
          images.pull_image:
            - image_name: ${unused_image_name}
            - host: ${coreos_host}
            - port
            - username: ${coreos_username}
            - password: ${coreos_password}
            - private_key_file
            - timeout
        navigate:
          - SUCCESS: run_container
          - FAILURE: PULL_UNUSED_IMAGE_PROBLEM

    - run_container:
        do:
          containers.run_container:
            - image_name: ${used_image_name}
            - host: ${coreos_host}
            - port
            - username: ${coreos_username}
            - password
            - private_key_file
            - timeout
        navigate:
           - SUCCESS: delete_unused_images
           - FAILURE: RUN_CONTAINER_PROBLEM

    - delete_unused_images:
        do:
          coreos.cluster_docker_images_maintenance:
            - coreos_host
            - coreos_username
            - coreos_password
            - private_key_file
            - percentage
            - timeout
        navigate:
          - SUCCESS: count_images_in_cluster
          - FAILURE: FAILURE

    - count_images_in_cluster:
          loop:
              for: machine_public_ip in machines_public_ip_list.split(' ')
              do:
                  images.get_all_images:
                     - host: ${machine_public_ip}
                     - port
                     - username: ${coreos_username}
                     - password: ${coreos_password}
                     - private_key_file
                     - timeout
                     - number_of_images_in_cluster
              publish:
                - number_of_images_in_cluster: ${str(int(number_of_images_in_cluster) + len(image_list.split()))}
              navigate:
                - SUCCESS: verify_number_of_remaining_images
                - FAILURE: COUNT_IMAGES_IN_CLUSTER_PROBLEM

    - verify_number_of_remaining_images:
        do:
          strings.string_equals:
            - first_string: '1'
            - second_string: ${str(number_of_images_in_cluster)}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: NUMBER_OF_REMAINING_IMAGES_MISMATCH

  results:
    - SUCCESS
    - FAILURE
    - LIST_MACHINES_PROBLEM
    - CLEAR_DOCKER_HOSTS_IN_CLUSTER_PROBLEM
    - PULL_UNUSED_IMAGE_PROBLEM
    - RUN_CONTAINER_PROBLEM
    - COUNT_IMAGES_IN_CLUSTER_PROBLEM
    - NUMBER_OF_REMAINING_IMAGES_MISMATCH
