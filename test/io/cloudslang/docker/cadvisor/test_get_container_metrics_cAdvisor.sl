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

    - create_cAdvisor_container:
        do:
          cmd.run_command:
            - command: >
                'docker run --privileged -d --name ' + cadvisor_container_name + ' ' +
                '--volume=/:/rootfs:ro ' +
                '--volume=/var/run:/var/run:rw ' +
                '--volume=/sys:/sys:ro ' +
                '--volume=/var/lib/docker/:/var/lib/docker:ro ' +
                '--volume=/sys/fs/cgroup/cpu:/cgroup/cpu ' +
                '--volume=/sys/fs/cgroup/cpuacct:/cgroup/cpuacct ' +
                '--volume=/sys/fs/cgroup/cpuset:/cgroup/cpuset ' +
                '--volume=/sys/fs/cgroup/memory:/cgroup/memory ' +
                '--volume=/sys/fs/cgroup/blkio:/cgroup/blkio ' +
                '--publish=' + cadvisor_port + ':8080 ' +
                'google/cadvisor:latest --logtostderr'
            - overridable: false
        navigate:
          SUCCESS: validate_success_get_container_metrics_cAdvisor
          FAILURE: C_ADVISOR_CONTAINER_STARTUP_PROBLEM

    - validate_success_get_container_metrics_cAdvisor:
        do:
          cadvisor.get_container_metrics_cAdvisor:
            - host
            - cadvisor_port
            - container: cadvisor_container_name

  results:
    - SUCCESS
    - FAILURE
    - C_ADVISOR_CONTAINER_STARTUP_PROBLEM
