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
#! @input host: Docker machine host
#! @input cadvisor_port: optional - port used for cAdvisor - Default: '8080'
#! @output decoded: parsed response
#! @output num_cores: machine number of cores
#! @output cpu_frequency_khz: machine CPU
#! @output memory_capacity: machine memory
#! @output file_systems: parsed cAdvisor machine filesystems
#! @output disk_map: parsed cAdvisor machine disk map
#! @output network_devices: parsed cAdvisor machine network devices
#! @output topology: parsed cAdvisor machine topology
#! @output error_message: error message
#! @result SUCCESS: parsing was successful
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.docker.cadvisor

imports:
  cadvisor: io.cloudslang.docker.cadvisor

flow:
  name: report_machine_metrics
  inputs:
    - host
    - cadvisor_port:
        default: '8080'
        required: false

  workflow:
    - retrieve_machine_metrics:
        do:
          cadvisor.get_machine_metrics:
            - host
            - cadvisor_port
        publish:
          - response_body: ${return_result}
          - error_message
          - return_code
    - parse_machine_metrics:
        do:
          cadvisor.parse_machine:
            - json_response: ${response_body}
        publish:
          - decoded
          - num_cores
          - cpu_frequency_khz
          - memory_capacity
          - file_systems
          - disk_map
          - network_devices
          - topology
          - error_message
  outputs:
    - decoded
    - num_cores
    - cpu_frequency_khz
    - memory_capacity
    - file_systems
    - disk_map
    - network_devices
    - topology
    - error_message
  results:
    - SUCCESS
    - FAILURE
