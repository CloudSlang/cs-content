#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.base.os.linux

imports:
  images: io.cloudslang.docker.images
  containers: io.cloudslang.docker.containers
  maintenance: io.cloudslang.docker.maintenance
  linux: io.cloudslang.base.os.linux

flow:
  name: test_restart_service
  inputs:
    - host
    - port:
        required: false
    - username
    - password
    - service_name

  workflow:

    - restart_service:
        do:
          linux.restart_service:
            - host
            - port:
               required: false
            - username
            - password
            - service_name: service_name
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE

  results:
    - SUCCESS
    - FAIL_PULL_IMAGE
    - FAIL_RUN_IMAGE
    - FAILURE
