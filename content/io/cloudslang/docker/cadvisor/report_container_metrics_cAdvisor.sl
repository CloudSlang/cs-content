#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Retrieves cAdvisor status of a Docker container.
#
# Inputs:
#   - container - name or ID of Docker container that runs MySQL
#   - host - Docker machine host
#   - cadvisor_port - optional - port used for cAdvisor - Default: 8080
# Outputs:
#   - decoded - parsed response
#   - timestamp - time used to calculate stat
#   - memory_usage- calculated memory usage of the container; if machine_memory_limit is given lower of container memory limit and machine memory limit used to calculate
#   - cpu_usage - calculated CPU usage of the container
#   - throughput_rx - calculated network Throughput Rx bytes
#   - throughput_tx - calculated network Throughput Tx bytes
#   - error_rx- calculated network error Rx
#   - error_tx- calculated network error Tx
#   - errorMessage - returnResult if there was an error
# Results:
#   - SUCCESS - parsing was successful (returnCode == '0')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.docker.cadvisor

imports:
  docker_cadvisor: io.cloudslang.docker.cadvisor

flow:
  name: report_container_metrics_cAdvisor
  inputs:
    - container
    - host
    - cadvisor_port:
        default: "'8080'"
        required: false
  workflow:
    - retrieve_container_metrics_cAdvisor:
        do:
          docker_cadvisor.get_container_metrics_cAdvisor:
              - container
              - host
              - cadvisor_port
        publish:
          - response_body: returnResult
          - returnCode
          - errorMessage
    - retrieve_machine_memory:
        do:
          docker_cadvisor.report_machine_metrics_cAdvisor:
            - host
            - cadvisor_port
        publish:
          - memory_capacity
    - parse_container_metrics_cAdvisor:
        do:
          docker_cadvisor.parse_cadvisor_container:
            - json_response: response_body
            - machine_memory_limit: memory_capacity
        publish:
          - decoded
          - timestamp
          - memory_usage
          - cpu_usage
          - throughput_rx
          - throughput_tx
          - error_rx
          - error_tx
          - errorMessage
  outputs:
    - decoded
    - timestamp
    - memory_usage
    - cpu_usage
    - throughput_rx
    - throughput_tx
    - error_rx
    - error_tx
    - errorMessage
  results:
    - SUCCESS
    - FAILURE