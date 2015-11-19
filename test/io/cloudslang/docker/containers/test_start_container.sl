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
  maintenance: io.cloudslang.docker.maintenance
  strings: io.cloudslang.base.strings
  print: io.cloudslang.base.print

flow:
  name: test_start_container
  inputs:
    - host
    - port:
        required: false
    - username
    - password
    - image_name
    - container_name

  workflow:
    - clear_docker_host_prereqeust:
       do:
         maintenance.clear_host:
           - docker_host: ${host}
           - port
           - docker_username: ${username}
           - docker_password: ${password}
       navigate:
         SUCCESS: pull_image
         FAILURE: MACHINE_IS_NOT_CLEAN

    - pull_image:
        do:
          images.pull_image:
            - host
            - port
            - username
            - password
            - image_name
        navigate:
          SUCCESS: run_container
          FAILURE: FAIL_PULL_IMAGE

    - run_container:
        do:
          run_container:
            - host
            - port
            - username
            - password
            - container_name
            - image_name
            - container_command: ${'/bin/sh -c "while true; do echo hello world; sleep 1; done"'}
        navigate:
          SUCCESS: stop_container
          FAILURE: FAIL_RUN_IMAGE

    - stop_container:
        do:
          stop_container:
            - host
            - port
            - username
            - password
            - container_id: ${container_name}
        navigate:
          SUCCESS: get_container_names
          FAILURE: FAIL_STOP_CONTAINERS

    - get_container_names:
        do:
          get_container_names:
            - host
            - port
            - username
            - password
        publish:
          - list: ${container_names}

    - verify_all_stoped:
        do:
          strings.string_equals:
            - first_string: ''
            - second_string: ${list}
        navigate:
          SUCCESS: start_container
          FAILURE: VEFIFYFAILURE

    - start_container:
        do:
          start_container:
            - host
            - port
            - username
            - password
            - container_id: ${container_name}
        navigate:
          SUCCESS: get_running_container_names
          FAILURE: FAILURE

    - get_running_container_names:
        do:
          get_container_names:
            - host
            - port
            - username
            - password
        publish:
          - list: ${container_names}

    - verify_running:
        do:
          strings.string_equals:
            - first_string: ${container_name}
            - second_string: ${list}
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE


    - clear_docker_host:
        do:
         clear_containers:
           - docker_host: ${host}
           - port
           - docker_username: ${username}
           - docker_password: ${password}
        navigate:
         SUCCESS: SUCCESS
         FAILURE: MACHINE_IS_NOT_CLEAN

  results:
    - SUCCESS
    - FAIL_VALIDATE_SSH
    - FAIL_GET_ALL_IMAGES_BEFORE
    - MACHINE_IS_NOT_CLEAN
    - FAIL_STOP_CONTAINERS
    - FAIL_PULL_IMAGE
    - FAIL_GET_ALL_IMAGES
    - FAILURE
    - FAIL_CLEAR_IMAGE
    - FAIL_RUN_IMAGE
    - VEFIFYFAILURE