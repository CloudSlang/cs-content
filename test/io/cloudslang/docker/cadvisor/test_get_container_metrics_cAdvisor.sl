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
        default: "'127.0.0.1'"
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
                'docker run --privileged -d --name ' + cadvisor_container_name + ' ' +
                '--volume=/:/rootfs:ro ' +
                '--volume=/var/run:/var/run:rw ' +
                '--volume=/sys:/sys:ro ' +
                '--volume=/var/lib/docker/:/var/lib/docker:ro ' +
                '--publish=' + host + ':' + cadvisor_port + ':8080 ' +
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

    - curl_test:
        do:
          cmd.run_command:
            - command: >
                'curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://' + host + ':32951/api/v1.2/docker/cadvisor'
            - overridable: false
        navigate:
          SUCCESS: inspect_container
          FAILURE: inspect_container

    - inspect_container:
        do:
          cmd.run_command:
            - command: >
                'docker inspect ' + cadvisor_container_name
            - overridable: false
        navigate:
          SUCCESS: validate_success_get_container_metrics_cAdvisor
          FAILURE: validate_success_get_container_metrics_cAdvisor

    - validate_success_get_container_metrics_cAdvisor:
        do:
          cadvisor.get_container_metrics_cAdvisor:
            - host:
                default:  "'localhost'"
                overridable: false
            - cadvisor_port
            - container: cadvisor_container_name
        publish:
          - returnResult
          - statusCode
        navigate:
          SUCCESS: delete_cadvisor_container
          FAILURE: print_details

    - print_details:
        do:
          cmd.run_command:
            - command: >
                "echo 'returnResult= " + returnResult + " statusCode= " + statusCode + "'"
            - overridable: false
        navigate:
          SUCCESS: FAILURE
          FAILURE: PRINT_DETAILS_PROBLEM

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
    - PRINT_DETAILS_PROBLEM
