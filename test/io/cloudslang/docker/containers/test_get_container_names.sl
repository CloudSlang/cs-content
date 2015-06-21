#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.docker.containers

imports:
  containers: io.cloudslang.docker.containers
  maintenance: io.cloudslang.docker.maintenance
  strings: io.cloudslang.base.strings
  lists: io.cloudslang.base.lists

flow:
  name: test_get_container_names
  inputs:
    - host
    - port:
        default: "'22'"
    - username
    - password:
        required: false
    - private_key_file:
        required: false
    - image_name:
        default: "'busybox'"
        overridable: false
    - container_name1:
        default: "'busy1'"
        overridable: false
    - container_name2:
        default: "'busy2'"
        overridable: false
    - timeout:
        default: "'6000000'"

  workflow:
    - run_container1:
       do:
         containers.run_container:
            - container_name: container_name1
            - container_command: >
                '/bin/sh -c "while true; do echo hello world; sleep 1; done"'
            - image_name
            - host
            - port
            - username
            - password:
                default: password
                required: false
            - private_key_file:
                default: private_key_file
                required: false
            - timeout
       navigate:
         SUCCESS: run_container2
         FAILURE: RUN_CONTAINER1_PROBLEM

    - run_container2:
       do:
         containers.run_container:
            - container_name: container_name2
            - container_command: >
                '/bin/sh -c "while true; do echo hello world; sleep 1; done"'
            - image_name
            - host
            - port
            - username
            - password:
                default: password
                required: false
            - private_key_file:
                default: private_key_file
                required: false
            - timeout
       navigate:
         SUCCESS: get_container_names
         FAILURE: RUN_CONTAINER2_PROBLEM

    - get_container_names:
       do:
         containers.get_container_names:
            - host
            - port
            - username
            - password:
                default: password
                required: false
            - private_key_file:
                default: private_key_file
                required: false
            - timeout
       publish:
        - container_names
       navigate:
         SUCCESS: subtract_names
         FAILURE: FAILURE

    - subtract_names:
        do:
          lists.subtract_sets:
            - set_1: container_names
            - set_1_delimiter: "' '"
            - set_2: >
                container_name1 + ' ' + container_name2
            - set_2_delimiter: "' '"
            - result_set_delimiter: "' '"
        publish:
          - result_set

    - check_empty_set:
        do:
          strings.string_equals:
            - first_string: result_set
            - second_string: "''"
        navigate:
          SUCCESS: clear_machine
          FAILURE: CONTAINER_NAMES_VERIFY_PROBLEM

    - clear_machine:
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
            - timeout
            - port
        navigate:
          SUCCESS: SUCCESS
          FAILURE: CLEAR_DOCKER_HOST_PROBLEM

  results:
    - SUCCESS
    - FAILURE
    - RUN_CONTAINER1_PROBLEM
    - RUN_CONTAINER2_PROBLEM
    - CLEAR_DOCKER_HOST_PROBLEM
    - CONTAINER_NAMES_VERIFY_PROBLEM
