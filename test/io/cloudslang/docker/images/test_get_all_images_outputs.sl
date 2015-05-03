# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Workflow to test docker get_all_images operation.
#
# Inputs:
#   - host - Docker machine host
#   - username - Docker machine username
#   - password - Docker machine password
#
# Results:
#   - SUCCESS - get_all_images performed successfully
#   - FAILURE - get_all_images finished with an error
#   - DOWNLOADFAIL - prerequest error - could not download dockerimage
#
####################################################
namespace: io.cloudslang.docker.images

imports:
  images: io.cloudslang.docker.images
  strings: io.cloudslang.base.strings
  linux: io.cloudslang.base.os.linux

flow:
  name: test_get_all_images_outputs
  inputs:
    - host
    - port:
        required: false
    - username
    - password
    - image_name
  workflow:
    - validate_ssh:
        do:
          linux.validate_linux_machine_ssh_access:
            - host: host
            - port: port
            - username: username
            - password: password
        navigate:
          SUCCESS: hello_world_image_download
          FAILURE: FAIL_VALIDATE_SSH

    - hello_world_image_download:
        do:
          images.pull_image:
            - host: host
            - port: port
            - username: username
            - password: password
            - imageName: image_name
        navigate:
          SUCCESS: get_all_images
          FAILURE: DOWNLOADFAIL

    - get_all_images:
        do:
          images.get_all_images:
            - host: host
            - port: port
            - username: username
            - password: password
        publish:
            - list: image_list
        navigate:
          SUCCESS: verify_output
          FAILURE: FAILURE

    - verify_output:
        do:
          strings.match_regex:
            - regex: "'hello-world'"
            - text: list
        navigate:
          MATCH: delete_downloaded_image
          NO_MATCH: VEFIFYFAILURE

    - delete_downloaded_image:
        do:
          images.clear_docker_images:
            - host: host
            - port: port
            - username: username
            - password: password
            - images: "'hello-world'"
        navigate:
          SUCCESS: SUCCESS
          FAILURE: DELETEFAIL

  results:
    - SUCCESS
    - FAILURE
    - DOWNLOADFAIL
    - VEFIFYFAILURE
    - DELETEFAIL
    - FAIL_VALIDATE_SSH