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
    - host
    - cadvisor_port
    - cadvisor_container_name

  workflow:

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
                'curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://' + host + ':' + cadvisor_port + '/api/v1.2/docker/' + cadvisor_container_name
            - overridable: false
        navigate:
          SUCCESS: curl_test2
          FAILURE: curl_test2

    - curl_test2:
        do:
          cmd.run_command:
            - command: >
                'curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://' + host + ':' + cadvisor_port + '/api/v1.2/docker/'
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
          SUCCESS: logs_container
          FAILURE: logs_container

    - logs_container:
        do:
          cmd.run_command:
            - command: >
                'docker logs ' + cadvisor_container_name
            - overridable: false
        navigate:
          SUCCESS: validate_success_get_container_metrics_cAdvisor
          FAILURE: validate_success_get_container_metrics_cAdvisor

    - validate_success_get_container_metrics_cAdvisor:
        do:
          cadvisor.get_container_metrics_cAdvisor:
            - host
            - cadvisor_port
            - container: cadvisor_container_name
        publish:
          - returnResult
          - statusCode
        navigate:
          SUCCESS: SUCCESS
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

  results:
    - SUCCESS
    - FAILURE
    - PRINT_DETAILS_PROBLEM
