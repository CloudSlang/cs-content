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
  images: io.cloudslang.docker.images
  containers: io.cloudslang.docker.containers
  maintenance: io.cloudslang.docker.maintenance
  strings: io.cloudslang.base.strings

flow:
  name: test_get_all_containers
  inputs:
    - host
    - port:
        required: false
    - username
    - password
    - first_image_name
    - second_image_name

  workflow:
    - clear_docker_host_prereqeust:
       do:
         containers.clear_docker_containers:
           - docker_host: host
           - port:
               required: false
           - docker_username: username
           - docker_password: password
       navigate:
         SUCCESS: pull_first_image
         FAILURE: PREREQUISITE_MACHINE_IS_NOT_CLEAN

    - pull_first_image:
        do:
          images.pull_image:
            - host
            - port:
                required: false
            - username
            - password
            - image_name: first_image_name
        navigate:
          SUCCESS: pull_second_image
          FAILURE: FAIL_PULL_IMAGE

    - pull_second_image:
        do:
          images.pull_image:
            - host
            - port:
                required: false
            - username
            - password
            - image_name: second_image_name
        navigate:
          SUCCESS: run_first_container
          FAILURE: FAIL_PULL_IMAGE


    - run_first_container:
        do:
          containers.run_container:
            - host
            - port:
                required: false
            - username
            - password
            - container_name: "'first_test_container'"
            - image_name: first_image_name
        publish:
          - standard_out
        navigate:
          SUCCESS: run_second_container
          FAILURE: FAIL_RUN_IMAGE

    - run_second_container:
        do:
          containers.run_container:
            - host
            - port:
                required: false
            - username
            - password
            - container_name: "'second_test_container'"
            - image_name: second_image_name
        publish:
          - standard_out
        navigate:
          SUCCESS: get_all_containers
          FAILURE: FAIL_RUN_IMAGE

    - get_all_containers:
        do:
          containers.get_all_containers:
            - host
            - port:
                required: false
            - username
            - password
            - all_containers: true
        publish:
          - list: container_list

    - verify_list:
        do:
          strings.string_equals:
            - first_string: >
                len(list.rstrip().split(" "))
            - second_string: 2
        navigate:
          SUCCESS: clear_docker_host
          FAILURE: FAILURE

    - clear_docker_host:
        do:
         containers.clear_docker_containers:
           - docker_host: host
           - port:
               required: false
           - docker_username: username
           - docker_password: password
        navigate:
         SUCCESS: SUCCESS
         FAILURE: MACHINE_IS_NOT_CLEAN

  results:
    - SUCCESS
    - FAIL_VALIDATE_SSH
    - FAIL_GET_ALL_IMAGES_BEFORE
    - PREREQUISITE_MACHINE_IS_NOT_CLEAN
    - MACHINE_IS_NOT_CLEAN
    - FAIL_PULL_IMAGE
    - FAIL_GET_ALL_IMAGES
    - FAILURE
    - FAIL_CLEAR_IMAGE
    - FAIL_RUN_IMAGE
    - VEFIFYFAILURE