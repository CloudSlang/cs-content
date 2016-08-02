#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Retrieves cAdvisor status and performs restart to the container if the resource usage is too high.
#! @input container: name or ID of Docker container that runs cAdvisor
#! @input host: Docker machine host
#! @input cadvisor_port: optional - port used for cAdvisor - Default: '8080'
#! @input machine_connect_port: optional - port to use to connect to machine running Docker - Default: '22'
#! @input username: Docker machine username
#! @input password: optional - Docker machine password
#! @input private_key_file: optional - path to the private key file
#! @input rule: optional - Python query to determine if the resource usages is high
#! @result SUCCESS: successful
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.docker.cadvisor

imports:
  cadvisor: io.cloudslang.docker.cadvisor
  containers: io.cloudslang.docker.containers
  print: io.cloudslang.base.print

flow:
  name: restart_container_base_on_usage
  inputs:
    - container
    - host
    - cadvisor_port:
        default: '8080'
        required: false
    - machine_connect_port:
        default: '22'
        required: false
    - username
    - password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - rule:
        default: ''
        required: false
  workflow:
    - retrieve_container_usage:
        do:
          cadvisor.report_container_metrics:
            - container
            - host
            - cadvisor_port
        publish:
          - memory_usage
          - cpu_usage
          - throughput_rx
          - throughput_tx
          - error_rx
          - error_tx
          - return_code
          - error_message
    - evaluate_resource_usage:
        do:
          cadvisor.evaluate_resource_usage:
            - rule
            - memory_usage
            - cpu_usage
            - throughput_rx
            - throughput_tx
            - error_rx
            - error_tx
        navigate:
            - MORE: stop_container
            - LESS: SUCCESS
            - FAILURE: FAILURE
    - stop_container:
        do:
          containers.stop_container:
            - container_id: ${container}
            - host
            - username
            - password
            - port: ${machine_connect_port}
            - private_key_file
        publish:
          - error_message
        navigate:
            - SUCCESS: start_container
            - FAILURE: FAILURE
    - start_container:
        do:
          containers.start_container:
            - private_key_file
            - start_container_id: ${container}
            - host
            - username
            - password
            - port: ${machine_connect_port}
        publish:
          - error_message
    - on_failure:
        - print_error:
            do:
              print.print_text:
                - text: ${'cAdvisor ended with the following error message ' + error_message}
  results:
    - SUCCESS
    - FAILURE
