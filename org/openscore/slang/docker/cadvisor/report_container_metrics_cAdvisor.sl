#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
#   This flow retrieves cAdviser status of a container in docker 
#
#   Inputs:
#       - container - name or ID of the Docker container that runs MySQL
#       - host - Docker machine host
#       - cadvisor_port - optional - port used for cAdvisor - Default: 8080
#   Outputs:
#       - decoded - parse response
#       - timestamp - the time used to calculate the stat
#       - cpu_usage - calculated cpu usages of the container
#       - memory_usage- calculated cpu usages of the container (if the machine_memory_limit is given use the minimum
#                       of the container memory limit and the machine memory limit to calculate)
#       - throughput_rx- calculated network Throughput Tx bytes
#       - throughput_tx- calculated network Throughput Rx bytes
#       - error_rx- calculated network error Tx
#       - error_tx- calculated network error Rx
#       - errorMessage - returnResult if there was an error
#   Results:
#       - SUCCESS - parsing was successful (returnCode == '0')
#       - FAILURE - otherwise
##################################################################################################################################################

namespace: org.openscore.slang.docker.cadvisor

imports:
  docker_cadvisor: org.openscore.slang.docker.cadvisor

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