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
  cmd: io.cloudslang.base.cmd

flow:
  name: test_get_container_metrics_cAdvisor

  inputs:
    - host:
        default: "'localhost'"
        overridable: false
    - cadvisor_port:
        default: "'32951'"
    - cadvisor_container_name:
        default: "'cadvisor'"

  workflow:
    - create_cAdvisor_container:
        do:
          cmd.run_command:
            - command: >
                'docker run -d --name ' + cadvisor_container_name + ' ' +
                '--volume=/:/rootfs:ro ' +
                '--volume=/var/run:/var/run:rw ' +
                '--volume=/sys:/sys:ro ' +
                '--volume=/var/lib/docker/:/var/lib/docker:ro ' +
                '--publish=' + cadvisor_port + ':8080 ' +
                'google/cadvisor:latest'
            - overridable: false
        navigate:
          SUCCESS: docker_ps
          FAILURE: C_ADVISOR_CONTAINER_STARTUP_PROBLEM

    - docker_ps:
        do:
          cmd.run_command:
            - command: >
                'docker ps -a'
            - overridable: false

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
          cmd.run_command:
            - command: >
                'docker stop ' + cadvisor_container_name + ' && ' + 'docker rm ' + cadvisor_container_name
            - overridable: false
        navigate:
          SUCCESS: SUCCESS
          FAILURE: C_ADVISOR_CONTAINER_REMOVAL_PROBLEM

  results:
    - SUCCESS
    - C_ADVISOR_CONTAINER_STARTUP_PROBLEM
    - C_ADVISOR_CONTAINER_REMOVAL_PROBLEM
    - FAILURE
