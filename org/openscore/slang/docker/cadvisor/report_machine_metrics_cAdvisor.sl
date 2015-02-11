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
#       - host - Docker machine host
#       - identityPort - optional - port used for cAdvisor - Default: 8080
#   Outputs:
#       - decoded - parse response
#       - num_cores - machine number of cores
#       - cpu_frequency_khz - machine cpu
#       - memory_capacity- machine memory
#       - file_systems - parse cAdviser machine filesystems
#       - disk_map- parse cAdviser machine disk map
#       - network_devices- parse cAdviser machine network devices
#       - topology- parse cAdviser machine topology
#       - errorMessage - returnResult if there was an error
#   Results:
#       - SUCCESS - parsing was successful (returnCode == '0')
#       - FAILURE - otherwise
##################################################################################################################################################

namespace: org.openscore.slang.docker.cadvisor

imports:
  docker_cadvisor: org.openscore.slang.docker.cadvisor

flow:
  name: report_machine_metrics_cAdvisor
  inputs:
    - host
    - identityPort:
        default: "'8080'"
        required: false
  workflow:
    retrieve_machine_metrics_cAdvisor:
      do:
        docker_cadvisor.get_machine_metrics_cAdvisor:
            - host
            - identityPort
      publish:
        - response_body: returnResult
        - returnCode
        - errorMessage
    parse_machine_metrics_cAdvisor:
      do:
        docker_cadvisor.parse_cadvisor_machine:
          - json_response: response_body
      publish:
        - decoded
        - num_cores
        - cpu_frequency_khz
        - memory_capacity
        - file_systems
        - disk_map
        - network_devices
        - topology
        - errorMessage
  outputs:
    - decoded
    - num_cores
    - cpu_frequency_khz
    - memory_capacity
    - filesystems
    - disk_map
    - network_devices
    - topology
    - errorMessage
  results:
    - SUCCESS
    - FAILURE