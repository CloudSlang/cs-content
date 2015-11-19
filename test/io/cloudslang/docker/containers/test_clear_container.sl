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
  name: test_clear_container
  inputs:
    - host
    - port:
        required: false
    - username
    - password
    - first_image_name
    - second_image_name

  workflow:
    - clear_docker_host_prerequest:
       do:
         clear_containers:
           - docker_host: ${host}
           - port
           - docker_username: ${username}
           - docker_password: ${password}
       navigate:
         SUCCESS: pull_image
         FAILURE: PREREQUEST_MACHINE_IS_NOT_CLEAN

    - pull_image:
        do:
          images.pull_image:
            - host
            - port
            - username
            - password
            - image_name: ${first_image_name}
        navigate:
          SUCCESS: pull_second
          FAILURE: FAIL_PULL_IMAGE

    - pull_second:
        do:
          images.pull_image:
            - host
            - port
            - username
            - password
            - image_name: ${second_image_name}
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAIL_PULL_IMAGE

    - run_first_container:
        do:
          run_container:
            - host
            - port
            - username
            - password
            - container_name: 'first'
            - image_name: ${first_image_name}
        navigate:
          SUCCESS: run_second_container
          FAILURE: FAIL_RUN_IMAGE

    - run_second_container:
        do:
          run_container:
            - host
            - port
            - username
            - password
            - container_name: 'second'
            - image_name: ${second_image_name}
            - container_params: '-p 49165:22'
        navigate:
          SUCCESS: get_all_containers
          FAILURE: FAIL_RUN_IMAGE

    - clear_container:
        do:
          clear_container:
            - docker_host: ${host}
            - port
            - docker_username: ${username}
            - docker_password: ${password}
            - container_id: ${list}
        navigate:
          SUCCESS: verify
          FAILURE: FAILURE

    - verify:
        do:
          get_all_containers:
            - host
            - port
            - username
            - password
            - all_containers: true
        publish:
          - all_containers: ${container_list}
    - compare:
        do:
          strings.string_equals:
            - first_string: ${all_containers}
            - second_string: ''
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
    - PREREQUEST_MACHINE_IS_NOT_CLEAN
    - MACHINE_IS_NOT_CLEAN
    - FAIL_PULL_IMAGE
    - FAILURE
    - FAIL_RUN_IMAGE