#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Wrapper flow - logic steps:
# - retrieves the ip addresses of the machines in the cluster
# - cleanup on the machines (so they will not contain any images)
# - prepares a used and an unused Docker image
# - runs the flow
# - verifies only one image remained in the cluster
# - delete the used image
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
    - unused_image_name:
        default: "'tomcat:7'"
    - used_image_name:
        default: "'busybox'"
    - number_of_images_in_cluster:
        default: 0
        overridable: false

  workflow:
    - list_machines_public_ip:
        do:
          coreos.list_machines_public_ip:
            - coreos_host
            - coreos_username
            - coreos_password:
                required: false
            - private_key_file:
                required: false
            - timeout:
                required: false
        publish:
            - machines_public_ip_list
        navigate:
          SUCCESS: clear_docker_hosts_in_cluster
          FAILURE: LIST_MACHINES_PROBLEM

    - clear_docker_hosts_in_cluster:
          loop:
              for: machine_public_ip in machines_public_ip_list.split(' ')
              do:
                  maintenance.clear_docker_host:
                     - docker_host: machine_public_ip
                     - port:
                         required: false
                     - docker_username: coreos_username
                     - docker_password:
                        default: coreos_password
                        required: false
                     - private_key_file:
                        required: false
              navigate:
                SUCCESS: pull_unused_image
                FAILURE: CLEAR_DOCKER_HOSTS_IN_CLUSTER_PROBLEM

    - pull_unused_image:
        do:
          images.pull_image:
            - image_name: unused_image_name
            - host: coreos_host
            - port:
                required: false
            - username: coreos_username
            - password:
                default: coreos_password
                required: false
            - privateKeyFile:
                default: private_key_file
                required: false
            - timeout:
                default: timeout
                required: false
        navigate:
          SUCCESS: run_container
          FAILURE: PULL_UNUSED_IMAGE_PROBLEM

    - run_container:
        do:
          containers.run_container:
            - image_name: used_image_name
            - host: coreos_host
            - port:
                required: false
            - username: coreos_username
            - password:
                required: false
            - private_key_file:
                required: false
            - timeout:
                required: false
        navigate:
           SUCCESS: delete_unused_images
           FAILURE: RUN_CONTAINER_PROBLEM

    - delete_unused_images:
        do:
          coreos.cluster_docker_images_maintenance:
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
        navigate:
          SUCCESS: count_images_in_cluster
          FAILURE: FAILURE

    - count_images_in_cluster:
          loop:
              for: machine_public_ip in machines_public_ip_list.split(' ')
              do:
                  images.get_all_images:
                     - host: machine_public_ip
                     - port:
                         required: false
                     - username: coreos_username
                     - password:
                         default: coreos_password
                         required: false
                     - privateKeyFile:
                         default: private_key_file
                         required: false
                     - timeout:
                         required: false
              publish:
                - number_of_images_in_cluster: >
                    fromInputs['number_of_images_in_cluster'] + len(image_list.split())
              navigate:
                SUCCESS: verify_number_of_remaining_images
                FAILURE: COUNT_IMAGES_IN_CLUSTER_PROBLEM

    - verify_number_of_remaining_images:
        do:
          strings.string_equals:
            - first_string: "'1'"
            - second_string: str(number_of_images_in_cluster)
        navigate:
          SUCCESS: clear_docker_host
          FAILURE: NUMBER_OF_REMAINING_IMAGES_MISMATCH

    - clear_docker_host: # at this stage only one machine from the cluster is not clean
        do:
          maintenance.clear_docker_host:
            - docker_host: coreos_host
            - port:
                required: false
            - docker_username: coreos_username
            - docker_password:
               default: coreos_password
               required: false
            - private_key_file:
                required: false
        navigate:
          SUCCESS: SUCCESS
          FAILURE: CLEAR_DOCKER_HOST_PROBLEM

  results:
    - SUCCESS
    - FAILURE
    - LIST_MACHINES_PROBLEM
    - CLEAR_DOCKER_HOSTS_IN_CLUSTER_PROBLEM
    - PULL_UNUSED_IMAGE_PROBLEM
    - RUN_CONTAINER_PROBLEM
    - COUNT_IMAGES_IN_CLUSTER_PROBLEM
    - NUMBER_OF_REMAINING_IMAGES_MISMATCH
    - CLEAR_DOCKER_HOST_PROBLEM
