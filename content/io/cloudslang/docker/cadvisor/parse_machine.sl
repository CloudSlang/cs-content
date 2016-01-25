#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Parses the response of the cAdvisor container information.
#
# Inputs:
#   - json_response - response of the cAdvisor container information
# Outputs:
#   - decoded - parsed response
#   - num_cores - machine number of cores
#   - cpu_frequency_khz - machine CPU
#   - memory_capacity - machine memory
#   - file_systems - parsed cAdvisor machine filesystems
#   - disk_map - parsed cAdvisor machine disk map
#   - network_devices - parsed cAdvisor machine network devices
#   - topology - parsed cAdvisor machine topology
#   - return_code - '0' if parsing was successful, '-1' otherwise
#   - return_result - notification string; was parsing was successful or not
#   - error_message - return_result if there was an error
# Results:
#   - SUCCESS - parsing was successful (return_code == '0')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.docker.cadvisor

operation:
  name: parse_machine
  inputs:
    - json_response
  action:
    python_script: |
      try:
        import json
        decoded = json.loads(json_response)
        num_cores=int(decoded['num_cores'])
        cpu_frequency_khz=int(decoded['cpu_frequency_khz'])
        memory_capacity=int(decoded['memory_capacity'])
        file_systems=decoded['filesystems']
        disk_map=decoded['disk_map']
        network_devices=decoded['network_devices']
        topology=decoded['topology']
        return_code = '0'
        return_result = 'Parsing successful.'
      except:
        return_code = '-1'
        return_result = 'Parsing error.'
  outputs:
    - decoded
    - num_cores
    - cpu_frequency_khz
    - memory_capacity
    - file_systems
    - disk_map
    - network_devices
    - topology
    - return_code
    - return_result
    - error_message: ${return_result if return_code == '-1' else ''}
  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE