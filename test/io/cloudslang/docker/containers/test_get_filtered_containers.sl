#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
# Wrapper test flow - runs two Docker containers, retrieves and verifies their names and IDs
# filtering out one of them based on the image it is created from.
########################################################################################################

namespace: io.cloudslang.docker.containers

imports:
  containers: io.cloudslang.docker.containers
  maintenance: io.cloudslang.docker.maintenance
  strings: io.cloudslang.base.strings
  print: io.cloudslang.base.print

flow:
  name: test_get_filtered_containers
  inputs:
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
    - excluded_images:
        default: "'busybox:latest'"
        overridable: false
    - image_name_busybox:
        default: "'busybox:latest'"
        overridable: false
    - container_name_busybox:
        default: "'busybox'"
        overridable: false
    - image_name_tomcat:
        default: "'tomcat:latest'"
        overridable: false
    - container_name_tomcat:
        default: "'tomcat'"
        overridable: false
    - expected_container_names:
        default: container_name_tomcat
        overridable: false

  workflow:
    - pre_clear_machine:
        do:
          maintenance.clear_docker_host:
            - docker_host: host
            - docker_username: username
            - docker_password:
                default: password
                required: false
            - private_key_file:
                default: private_key_file
                required: false
            - timeout:
                required: false
            - port:
                required: false
        navigate:
          SUCCESS: run_container_busybox
          FAILURE: PRE_CLEAR_MACHINE_PROBLEM

    - run_container_busybox:
       do:
         containers.run_container:
            - container_name: container_name_busybox
            - container_command: >
                '/bin/sh -c "while true; do echo hello world; sleep 1; done"'
            - image_name: image_name_busybox
            - host
            - port:
                required: false
            - username
            - password:
                default: password
                required: false
            - private_key_file:
                default: private_key_file
                required: false
            - timeout:
                required: false
       navigate:
         SUCCESS: run_container_tomcat
         FAILURE: RUN_CONTAINER_BUSYBOX_PROBLEM

    - run_container_tomcat:
       do:
         containers.run_container:
            - container_name: container_name_tomcat
            - image_name: image_name_tomcat
            - host
            - port:
                required: false
            - username
            - password:
                default: password
                required: false
            - private_key_file:
                default: private_key_file
                required: false
            - timeout:
                required: false
       publish:
          - expected_container_ids:  container_ID
          - standard_err
       navigate:
         SUCCESS: execute_get_filtered_containers
         FAILURE: print_error

    - print_error:
        do:
          print.print_text:
            - text: standard_err
        navigate:
          SUCCESS: RUN_CONTAINER_TOMCAT_PROBLEM

    - execute_get_filtered_containers:
       do:
         containers.get_filtered_containers:
            - all_containers: true
            - excluded_images
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
         - actual_container_names: container_names
         - actual_container_ids: container_ids
       navigate:
         SUCCESS: check_container_names
         FAILURE: FAILURE

    - check_container_names:
        do:
          strings.string_equals:
            - first_string: expected_container_names
            - second_string: actual_container_names
        navigate:
          SUCCESS: check_container_ids
          FAILURE: CHECK_CONTAINER_NAMES_PROBLEM

    - check_container_ids:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: expected_container_ids # e.g. 086a88b556b61cc8e84a923f81ea077462f9e195136f48713d4dc021011b43ec
            - string_to_find: actual_container_ids # e.g. 086a88b556b6
        navigate:
          SUCCESS: post_clear_machine
          FAILURE: CHECK_CONTAINER_IDS_PROBLEM

    - post_clear_machine:
        do:
          containers.clear_docker_containers:
            - docker_host: host
            - docker_username: username
            - docker_password:
                default: password
                required: false
            - private_key_file:
                default: private_key_file
                required: false
            - timeout:
                required: false
            - port:
                required: false
        navigate:
          SUCCESS: SUCCESS
          FAILURE: POST_CLEAR_MACHINE_PROBLEM
  results:
    - SUCCESS
    - FAILURE
    - PRE_CLEAR_MACHINE_PROBLEM
    - RUN_CONTAINER_BUSYBOX_PROBLEM
    - RUN_CONTAINER_TOMCAT_PROBLEM
    - CHECK_CONTAINER_NAMES_PROBLEM
    - CHECK_CONTAINER_IDS_PROBLEM
    - POST_CLEAR_MACHINE_PROBLEM
