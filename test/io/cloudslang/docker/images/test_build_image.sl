#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.docker.images

imports:
  images: io.cloudslang.docker.images
  maintenance: io.cloudslang.docker.maintenance
  ssh: io.cloudslang.base.remote_command_execution.ssh
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings

flow:
  name: test_build_image
  inputs:
    - docker_user:
        default: "''"
    - image_name
    - tag:
        default: "'latest'"
    - workdir:
        default: "'.'"
    - dockerfile_name:
        default: "'Dockerfile'"
    - base_image:
        default: "'busybox:latest'"
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

  workflow:
    - pre_clear_docker_host:
        do:
          maintenance.clear_docker_host:
            - docker_host: host
            - port:
                required: false
            - docker_username: username
            - docker_password:
               default: password
               required: false
            - private_key_file:
                required: false
        navigate:
          SUCCESS: create_dockerfile
          FAILURE: PRE_CLEAR_DOCKER_HOST_PROBLEM

    - create_dockerfile:
        do:
          ssh.ssh_flow:
            - host
            - port:
                required: false
            - command: >
                "mkdir -p " + workdir + " && echo -e 'FROM " + base_image + "' > " + workdir + "/" + dockerfile_name
            - username
            - password:
                required: false
            - privateKeyFile:
                default: private_key_file
                required: false
            - timeout:
                required: false
        navigate:
          SUCCESS: build_image
          FAILURE: CREATE_DOCKERFILE_PROBLEM

    - build_image:
        do:
          images.build_image:
            - docker_user
            - image_name
            - tag
            - workdir
            - dockerfile_name
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - privateKeyFile:
                default: private_key_file
                required: false
            - timeout:
                required: false
        navigate:
          SUCCESS: get_all_images
          FAILURE: FAILURE

    - get_all_images:
        do:
          images.get_all_images:
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - privateKeyFile:
                default: private_key_file
                required: false
            - timeout:
                required: false
        publish:
          - image_list
        navigate:
          SUCCESS: subtract_image_set
          FAILURE: GET_ALL_IMAGES_PROBLEM

    - subtract_image_set:
        do:
          lists.subtract_sets:
            - set_1: image_list
            - set_1_delimiter: "' '"
            - set_2: >
                base_image + ' ' + ('' if docker_user == '' else docker_user + "/") + image_name + ':' + tag
            - set_2_delimiter: "' '"
            - result_set_delimiter: "' '"
        publish:
          - result_set
        navigate:
          SUCCESS: verify_empty_string
          FAILURE: SUBTRACT_IMAGE_SET_PROBLEM

    - verify_empty_string:
        do:
          strings.string_equals:
            - first_string: "''"
            - second_string: result_set
        navigate:
          SUCCESS: remove_dockerfile
          FAILURE: VERIFY_EMPTY_STRING_PROBLEM

    - remove_dockerfile:
        do:
          ssh.ssh_flow:
            - host
            - port:
                required: false
            - command: >
                "rm " + workdir + "/" + dockerfile_name
            - username
            - password:
                required: false
            - privateKeyFile:
                default: private_key_file
                required: false
            - timeout:
                required: false
        navigate:
          SUCCESS: post_clear_docker_host
          FAILURE: REMOVE_DOCKERFILE_PROBLEM

    - post_clear_docker_host:
        do:
          maintenance.clear_docker_host:
            - docker_host: host
            - port:
                required: false
            - docker_username: username
            - docker_password:
               default: password
               required: false
            - private_key_file:
                required: false
        navigate:
          SUCCESS: SUCCESS
          FAILURE: POST_CLEAR_DOCKER_HOST_PROBLEM

  results:
    - SUCCESS
    - FAILURE
    - PRE_CLEAR_DOCKER_HOST_PROBLEM
    - CREATE_DOCKERFILE_PROBLEM
    - GET_ALL_IMAGES_PROBLEM
    - SUBTRACT_IMAGE_SET_PROBLEM
    - VERIFY_EMPTY_STRING_PROBLEM
    - REMOVE_DOCKERFILE_PROBLEM
    - POST_CLEAR_DOCKER_HOST_PROBLEM
