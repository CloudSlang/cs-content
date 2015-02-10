#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will parse the response of the cAdviser container information and have the
#   decoded as output.
#
#   Inputs:
#       -json_response - response of the cAdviser container information
#   Outputs:
#       - decoded - parse response
#       - num_cores - machine number of cores
#       - cpu_frequency_khz - machine cpu
#       - memory_capacity- machine memory
#       - file_systems - parse cAdviser machine filesystems
#       - disk_map- parse cAdviser machine disk map
#       - network_devices- parse cAdviser machine network devices
#       - topology- parse cAdviser machine topology
#       - returnResult - notification string which says if parsing was successful or not
#       - returnCode - 0 if parsing was successful, -1 otherwise
#       - errorMessage - returnResult if there was an error
#   Results:
#       - SUCCESS - parsing was successful (returnCode == '0')
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.docker.maintenance

operation:
      name: parse_cadvisor_machine
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
            filesystems=decoded['filesystems']
            disk_map=decoded['disk_map']
            network_devices=decoded['network_devices']
            topology=decoded['topology']
            returnCode = '0'
            returnResult = 'Parsing successful.'
          except:
            returnCode = '-1'
            returnResult = 'Parsing error.'
      outputs:
        - decoded
        - num_cores
        - cpu_frequency_khz
        - memory_capacity
        - file_systems
        - disk_map
        - network_devices
        - topology
        - returnCode
        - returnResult
        - errorMessage: returnResult if returnCode == '-1' else ''
      results:
        - SUCCESS: returnCode == '0'
        - FAILURE