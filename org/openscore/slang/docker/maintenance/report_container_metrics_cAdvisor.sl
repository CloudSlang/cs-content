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
#       - dockerHost - Docker machine host
#       - identityPort - optional - port used for cAdvisor - Default: 8080
##################################################################################################################################################

namespace: org.openscore.slang.docker.maintenance

imports:
  docker_maintenance: org.openscore.slang.docker.maintenance

flow:
  name: report_container_metrics_cAdvisor
  inputs:
    - container
    - host
    - identityPort:
        default: "'8080'"
        required: false
  workflow:
    retrieve_container_metrics_cAdvisor:
          do:
            docker_maintenance.get_container_metrics_cAdvisor:
                - container
                - host
                - identityPort
          publish:
            - response_body: returnResult
            - returnCode
            - errorMessage
    retrieve_machine_memory:
      do:
        docker_maintenance.report_machine_metrics_cAdvisor:
          - host
          - identityPort
      publish:
        - memory_capacity
    parse_container_metrics_cAdvisor:
      do:
        docker_maintenance.parse_cadvisor_container:
          - jsonResponse: response_body
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