#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.docker.cadvisor

imports:
  cadvisor: io.cloudslang.docker.cadvisor
  containers: io.cloudslang.docker.containers

flow:
  name: test_get_container_metrics_cAdvisor

  inputs:
    - host
    - ssh_port:
        required: false
    - username
    - password
    - timeout:
        default: "'3000000'"
    - cadvisor_port:
        default: "'32951'"
    - cadvisor_container_name:
        default: "'cadvisor'"

  workflow:
    - create_cAdvisor_container:
        do:
          containers.create_container:
            - imageID: "'google/cadvisor:latest'"
            - containerName: cadvisor_container_name
            - cmdParams: >
                '--volume=/:/rootfs:ro ' +
                '--volume=/var/run:/var/run:rw ' +
                '--volume=/sys:/sys:ro ' +
                '--volume=/var/lib/docker/:/var/lib/docker:ro ' +
                '--publish=' + cadvisor_port + ':8080'
            - host
            - port:
                default: ssh_port
                required: false
            - username
            - password
            - timeout
        navigate:
          SUCCESS: validate_success_get_container_metrics_cAdvisor
          FAILURE: C_ADVISOR_CONTAINER_STARTUP_PROBLEM

    - validate_success_get_container_metrics_cAdvisor:
        do:
          cadvisor.get_container_metrics_cAdvisor:
            - host
            - cadvisor_port
            - container: cadvisor_container_name
        navigate:
          SUCCESS: delete_cadvisor_container
          FAILURE: FAILURE

    - delete_cadvisor_container:
        do:
          containers.clear_container:
            - container_ID: cadvisor_container_name
            - docker_host: host
            - docker_username: username
            - docker_password: password
        navigate:
          SUCCESS: SUCCESS
          FAILURE: C_ADVISOR_CONTAINER_REMOVAL_PROBLEM

  results:
    - SUCCESS
    - C_ADVISOR_CONTAINER_STARTUP_PROBLEM
    - C_ADVISOR_CONTAINER_REMOVAL_PROBLEM
    - FAILURE
