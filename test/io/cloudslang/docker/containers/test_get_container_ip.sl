#   (c) Copyright 2014-2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
namespace: io.cloudslang.docker.containers

imports:
  containers: io.cloudslang.docker.containers
  images: io.cloudslang.docker.images
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
          containers.clear_containers:
            - docker_host: ${host}
            - port
            - docker_username: ${username}
            - docker_password: ${password}
       navigate:
         - SUCCESS: pull_image
         - FAILURE: MACHINE_IS_NOT_CLEAN

    - pull_image:
        do:
          images.pull_image:
            - host
            - port
            - username
            - password
            - image_name
        navigate:
          - SUCCESS: run_container
          - FAILURE: FAIL_PULL_IMAGE

    - run_container:
        do:
          containers.run_container:
            - host
            - port
            - username
            - password
            - container_name
            - container_command: ${'/bin/sh -c "while true; do echo hello world; sleep 1; done"'}
            - image_name
        navigate:
          - SUCCESS: get_ip
          - FAILURE: FAIL_RUN_IMAGE

    - get_ip:
        do:
          containers.get_container_ip:
            - host
            - port
            - username
            - password
            - container_name
        publish:
          - ip: ${container_ip}
        navigate:
          - SUCCESS: validate
          - FAILURE: FAIL_GET_IP

    - validate:
        do:
          strings.match_regex:
            - regex: ${'^\\d{1,3}.\\d{1,3}.\\d{1,3}.\\d{1,3}$'}
            - text: ${ip}
        navigate:
          - MATCH: SUCCESS
          - NO_MATCH: VEFIFYFAILURE

  results:
    - SUCCESS
    - MACHINE_IS_NOT_CLEAN
    - FAIL_PULL_IMAGE
    - FAIL_RUN_IMAGE
    - FAIL_GET_IP
    - VEFIFYFAILURE
