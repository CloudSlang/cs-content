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
  print: io.cloudslang.base.print
  strings: io.cloudslang.base.strings

flow:
  name: test_get_machine_metrics_cAdvisor

  inputs:
    - host
    - cadvisor_container_name:
        default: "'cadvisor'"
    - cadvisor_port:
        default: "'8080'"

  workflow:

    - get_running_container_names:
        do:
          cmd.run_command:
            - command: >
                'docker ps'
            - overridable: false
        publish:
          - container_names: >
              ' '.join(map(lambda line : line.split()[-1], filter(lambda line : line != '', returnResult.split('\n')[1:])))
        navigate:
          SUCCESS: check_cadvisor_container_exists
          FAILURE: GET_CONTAINER_NAMES_PROBLEM

    - check_cadvisor_container_exists:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: >
                container_names + ' '
            - string_to_find: >
                cadvisor_container_name + ' ' # except only cadvisor not cadvisor1,cadvisor2 etc.
        publish:
          - nr_of_occurrences: return_result
        navigate:
          SUCCESS: check_cadvisor_container_needs_to_be_created
          FAILURE: STRING_OCCURRENCE_COUNTER_PROBLEM

    - check_cadvisor_container_needs_to_be_created:
        do:
          strings.string_equals:
            - first_string: >
                str(nr_of_occurrences)
            - second_string: "'1'"
        navigate:
          SUCCESS: validate_success_get_machine_metrics_cAdvisor # container is running
          FAILURE: create_cAdvisor_container

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
                'google/cadvisor:latest'
            - overridable: false
        navigate:
          SUCCESS: validate_success_get_machine_metrics_cAdvisor
          FAILURE: C_ADVISOR_CONTAINER_STARTUP_PROBLEM

    - validate_success_get_machine_metrics_cAdvisor:
        do:
          cadvisor.get_machine_metrics_cAdvisor:
            - host
            - cadvisor_port
        publish:
          - error_message: errorMessage
        navigate:
          SUCCESS: SUCCESS
          FAILURE: print_error_message

    - print_error_message:
        do:
          print.print_text:
            - text: >
                "Operation failed with message: " + error_message
        navigate:
          SUCCESS: FAILURE

  results:
    - SUCCESS
    - FAILURE
    - C_ADVISOR_CONTAINER_STARTUP_PROBLEM
    - GET_CONTAINER_NAMES_PROBLEM
    - STRING_OCCURRENCE_COUNTER_PROBLEM
