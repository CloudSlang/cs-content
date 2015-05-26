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
  print: io.cloudslang.base.print

flow:
  name: test_get_all_containers
  inputs:
    - host
    - port:
        required: false
    - username
    - password
    - image_name

  workflow:
    - clear_docker_host_prereqeust:
       do:
         maintenance.clear_docker_host:
           - docker_host: host
           - port:
               required: false
           - docker_username: username
           - docker_password: password
       navigate:
         SUCCESS: pull_image
         FAILURE: PREREQUISITE_MACHINE_IS_NOT_CLEAN

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
          containers.run_container:
            - host
            - port:
                required: false
            - username
            - password
            - container_name: "'test_container'"
            - image_name
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
          strings.match_regex:
            - regex: "'^.............$'"
            - text: list
        navigate:
          MATCH: clear_docker_host
          NO_MATCH: FAILURE

    - clear_docker_host:
        do:
         maintenance.clear_docker_host:
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