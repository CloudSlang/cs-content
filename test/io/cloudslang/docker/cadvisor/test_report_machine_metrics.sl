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
  strings: io.cloudslang.base.strings
  containers: io.cloudslang.docker.containers
  utils: io.cloudslang.base.flow_control


flow:
  name: test_report_machine_metrics

  inputs:
    - host
    - username
    - private_key_file
    - cadvisor_port
    - cadvisor_container_name
    - timeout: '600000'

  workflow:
    - clear_docker_containers:
       do:
         containers.clear_containers:
           - docker_host: ${host}
           - docker_username: ${username}
           - private_key_file
       navigate:
         - SUCCESS: create_cAdvisor_container
         - FAILURE: CLEAR_DOCKER_CONTAINERS_PROBLEM

    - create_cAdvisor_container:
        do:
          containers.run_container:
            - container_name: ${cadvisor_container_name}
            - container_params: >
                ${'--privileged --publish=' + cadvisor_port + ':8080 ' +
                '--volume=/:/rootfs:ro ' +
                '--volume=/var/run:/var/run:rw ' +
                '--volume=/sys:/sys:ro ' +
                '--volume=/var/lib/docker/:/var/lib/docker:ro ' +
                '--volume=/sys/fs/cgroup/cpu:/cgroup/cpu ' +
                '--volume=/sys/fs/cgroup/cpuacct:/cgroup/cpuacct ' +
                '--volume=/sys/fs/cgroup/cpuset:/cgroup/cpuset ' +
                '--volume=/sys/fs/cgroup/memory:/cgroup/memory ' +
                '--volume=/sys/fs/cgroup/blkio:/cgroup/blkio'}
            - image_name: 'google/cadvisor:latest'
            - host
            - username
            - private_key_file
            - timeout
        navigate:
          - SUCCESS: sleep
          - FAILURE: C_ADVISOR_CONTAINER_STARTUP_PROBLEM

    - sleep:
        do:
          utils.sleep:
            - seconds: 5
        navigate:
          - SUCCESS: call_report_machine_metrics
          - FAILURE: C_ADVISOR_CONTAINER_STARTUP_PROBLEM

    - call_report_machine_metrics:
        do:
          cadvisor.report_machine_metrics:
            - host
            - cadvisor_port
        publish:
          - memory_capacity
        navigate:
          - SUCCESS: validate_response_is_not_empty
          - FAILURE: CALL_GET_CONTAINER_METRICS_PROBLEM

    - validate_response_is_not_empty:
        do:
          strings.string_equals:
              - first_string: ${str(memory_capacity)}
              - second_string: '0'
        navigate:
          - SUCCESS: VALIDATE_RESPONSE_IS_NOT_EMPTY_PROBLEM
          - FAILURE: SUCCESS

  results:
    - SUCCESS
    - CLEAR_DOCKER_CONTAINERS_PROBLEM
    - C_ADVISOR_CONTAINER_STARTUP_PROBLEM
    - CALL_GET_CONTAINER_METRICS_PROBLEM
    - VALIDATE_RESPONSE_IS_NOT_EMPTY_PROBLEM
