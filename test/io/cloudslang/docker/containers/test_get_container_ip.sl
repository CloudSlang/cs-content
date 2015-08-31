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
  maintenance: io.cloudslang.docker.maintenance
  images: io.cloudslang.docker.images
  print: io.cloudslang.base.print
  strings: io.cloudslang.base.strings

flow:
  name: test_get_container_ip
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
         clear_containers:
           - docker_host: host
           - port:
               required: false
           - docker_username: username
           - docker_password: password
       navigate:
         SUCCESS: pull_image
         FAILURE: MACHINE_IS_NOT_CLEAN

    - pull_image:
        do:
          images.pull_image:
            - host
            - port:
                required: false
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
            - port:
                required: false
            - username
            - password
            - container_name
            - container_command: >
                  '/bin/sh -c "while true; do echo hello world; sleep 1; done"'
            - image_name
        navigate:
          SUCCESS: get_ip
          FAILURE: FAIL_RUN_IMAGE

    - get_ip:
        do:
          get_container_ip:
           - host
           - port:
              required: false
           - username
           - password
           - container_name
        publish:
          - ip: container_ip
        navigate:
          SUCCESS: validate
          FAILURE: FAIL_GET_IP

    - validate:
        do:
          strings.match_regex:
            - regex: "'^\\d{1,3}.\\d{1,3}.\\d{1,3}.\\d{1,3}$'"
            - text: ip
        navigate:
          MATCH: clear_docker_host
          NO_MATCH: VEFIFYFAILURE

    - clear_docker_host:
        do:
          clear_containers:
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
    - FAILURE
    - MACHINE_IS_NOT_CLEAN
    - FAIL_PULL_IMAGE
    - FAIL_RUN_IMAGE
    - FAIL_GET_IP
    - VEFIFYFAILURE
