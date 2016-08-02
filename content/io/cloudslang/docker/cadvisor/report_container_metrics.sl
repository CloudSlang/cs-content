#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Retrieves cAdvisor status of a Docker container.
#! @input container: name or ID of Docker container that runs MySQL
#! @input host: Docker machine host
#! @input cadvisor_port: optional - port used for cAdvisor - Default: '8080'
#! @output decoded: parsed response
#! @output timestamp: time used to calculate stat
#! @output memory_usage: calculated memory usage of the container; the container memory usage divided by the
#!                       machine_memory_limit or by the minimum memory limit of the container whichever is smaller
#! @output cpu_usage: calculated CPU usage of the container
#! @output throughput_rx: calculated network Throughput Rx bytes
#! @output throughput_tx: calculated network Throughput Tx bytes
#! @output error_rx: calculated network error Rx
#! @output error_tx: calculated network error Tx
#! @output error_message: error message
#! @result SUCCESS: parsing was successful
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.docker.cadvisor

imports:
  cadvisor: io.cloudslang.docker.cadvisor

flow:
  name: report_container_metrics
  inputs:
    - container
    - host
    - cadvisor_port:
        default: '8080'
        required: false

  workflow:
    - retrieve_container_metrics:
        do:
          cadvisor.get_container_metrics:
            - container
            - host
            - cadvisor_port
        publish:
          - response_body: ${return_result}
          - returnCode
          - error_message
    - retrieve_machine_memory:
        do:
          cadvisor.report_machine_metrics:
            - host
            - cadvisor_port
        publish:
          - memory_capacity
    - parse_container_metrics:
        do:
          cadvisor.parse_container:
            - json_response: ${response_body}
            - machine_memory_limit: ${memory_capacity}
        publish:
          - decoded
          - timestamp
          - memory_usage
          - cpu_usage
          - throughput_rx
          - throughput_tx
          - error_rx
          - error_tx
          - error_message
  outputs:
    - decoded
    - timestamp
    - memory_usage
    - cpu_usage
    - throughput_rx
    - throughput_tx
    - error_rx
    - error_tx
    - error_message
  results:
    - SUCCESS
    - FAILURE
