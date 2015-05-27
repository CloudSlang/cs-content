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
  name: test_get_machine_metrics_cAdvisor

  inputs:
    - host:
        default: "'localhost'"
        overridable: false
    - cadvisor_port:
        default: "'32951'"
    - cadvisor_container_name:
        default: "'cadvisor'"
    - cadvisor_image:
        default: "'google/cadvisor:latest'"
        overridable: false

  workflow:
    - create_cAdvisor_container:
        do:
          cmd.run_command:
            - command: >
                'docker run --privileged -d --name ' + cadvisor_container_name + ' ' +
                '--volume=/:/rootfs:ro ' +
                '--volume=/var/run:/var/run:rw ' +
                '--volume=/sys:/sys:ro ' +
                '--volume=/var/lib/docker/:/var/lib/docker:ro ' +
                '--volume=/cgroup:/cgroup ' +
                '--publish=' + cadvisor_port + ':8080 ' +
                cadvisor_image
            - overridable: false
        navigate:
          SUCCESS: validate_success_get_machine_metrics_cAdvisor
          FAILURE: C_ADVISOR_CONTAINER_STARTUP_PROBLEM

    - validate_success_get_machine_metrics_cAdvisor:
        do:
          cadvisor.get_machine_metrics_cAdvisor:
            - host
            - cadvisor_port
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE

  results:
    - SUCCESS
    - C_ADVISOR_CONTAINER_STARTUP_PROBLEM
    - FAILURE
