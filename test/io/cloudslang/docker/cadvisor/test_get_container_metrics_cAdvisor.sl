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
  ssh: io.cloudslang.base.remote_command_execution.ssh
  cadvisor: io.cloudslang.docker.cadvisor

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
        default: "'8080'"
    - cadvisor_container_name:
        default: "'cadvisor'"

  workflow:
    - start_cAdvisor_container:
        do:
          ssh.ssh_flow:
            - host
            - port:
                default: ssh_port
                required: false
            - command:
                default: >
                  'sudo docker run \
                      --volume=/:/rootfs:ro \
                      --volume=/var/run:/var/run:rw \
                      --volume=/sys:/sys:ro \
                      --volume=/var/lib/docker/:/var/lib/docker:ro \
                      --publish=' + cadvisor_port + ':8080 \
                      --detach=true \
                      --name=' + cadvisor_container_name + ' \
                      google/cadvisor:latest'
                overridable: false
            - username
            - password
            - arguments:
                default: "''"
                overridable: false
            - timeout
        navigate:
          SUCCESS: validate_success_get_container_metrics_cAdvisor
          FAILURE: C_ADVISOR_CONTAINER_DOWN

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
          ssh.ssh_flow:
            - host
            - port:
                default: ssh_port
                required: false
            - command:
                default: >
                  'sudo docker stop ' + cadvisor_container_name + ' && sudo docker rm ' + cadvisor_container_name
                overridable: false
            - username
            - password
            - arguments:
                default: "''"
                overridable: false
            - timeout
        navigate:
          SUCCESS: SUCCESS
          FAILURE: C_ADVISOR_CONTAINER_REMOVAL_PROBLEM

  results:
    - SUCCESS
    - C_ADVISOR_CONTAINER_DOWN
    - C_ADVISOR_CONTAINER_REMOVAL_PROBLEM
    - FAILURE
