#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################

namespace: io.cloudslang.docker.cadvisor

imports:
  cadvisor: io.cloudslang.docker.cadvisor
  maintenance: io.cloudslang.docker.maintenance
  containers: io.cloudslang.docker.containers
  utils: io.cloudslang.base.utils


flow:
  name: test_restart_container_base_on_usage

  inputs:
    - cadvisor_port
    - cadvisor_container_name
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
    - pre_clear_machine:
        do:
          maintenance.clear_docker_host:
            - docker_host: host
            - docker_username: username
            - docker_password:
                default: password
                required: false
            - private_key_file:
                required: false
            - timeout:
                required: false
            - port:
                required: false
        navigate:
          SUCCESS: create_cAdvisor_container
          FAILURE: PRE_CLEAR_MACHINE_PROBLEM

    - create_cAdvisor_container:
        do:
          containers.run_container:
            - container_name: cadvisor_container_name
            - container_params: >
                '--privileged --publish=' + cadvisor_port + ':8080 ' +
                '--volume=/:/rootfs:ro ' +
                '--volume=/var/run:/var/run:rw ' +
                '--volume=/sys:/sys:ro ' +
                '--volume=/var/lib/docker/:/var/lib/docker:ro ' +
                '--volume=/sys/fs/cgroup/cpu:/cgroup/cpu ' +
                '--volume=/sys/fs/cgroup/cpuacct:/cgroup/cpuacct ' +
                '--volume=/sys/fs/cgroup/cpuset:/cgroup/cpuset ' +
                '--volume=/sys/fs/cgroup/memory:/cgroup/memory ' +
                '--volume=/sys/fs/cgroup/blkio:/cgroup/blkio '
            - image_name: "'google/cadvisor:latest'"
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
        navigate:
          SUCCESS: sleep
          FAILURE: C_ADVISOR_CONTAINER_STARTUP_PROBLEM

    - sleep:
        do:
          utils.sleep:
            - seconds: 5
        navigate:
          SUCCESS: call_restart_container_base_on_usage
          FAILURE: FAILED_TO_SLEEP

    - call_restart_container_base_on_usage:
        do:
          cadvisor.restart_container_base_on_usage:
            - container: cadvisor_container_name
            - host
            - cadvisor_port
            - machine_connect_port:
                default: port
                required: false
            - username
            - password:
                required: false
            - privateKeyFile:
                default: private_key_file
                required: false
        navigate:
          SUCCESS: post_clear_machine
          FAILURE: CALL_RESTART_CONTAINER_BASE_ON_USAGE_PROBLEM

    - post_clear_machine:
        do:
          maintenance.clear_docker_host:
            - docker_host: host
            - docker_username: username
            - docker_password:
                default: password
                required: false
            - private_key_file:
                required: false
            - timeout:
                required: false
            - port:
                required: false
        navigate:
          SUCCESS: SUCCESS
          FAILURE: POST_CLEAR_MACHINE_PROBLEM
  results:
    - SUCCESS
    - FAILURE
    - PRE_CLEAR_MACHINE_PROBLEM
    - C_ADVISOR_CONTAINER_STARTUP_PROBLEM
    - CALL_RESTART_CONTAINER_BASE_ON_USAGE_PROBLEM
    - POST_CLEAR_MACHINE_PROBLEM
    - FAILED_TO_SLEEP
