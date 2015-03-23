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
#   - machine_memory_limit - optional - the container machine memory limit
# Outputs:
#   - decoded - parsed response
#   - spec - parsed cAdvisor spec
#   - stat - parsed cAdvisor stat
#   - timestamp - time used to calculate the stat
#   - cpu - parsed cAdvisor CPU
#   - memory - parsed cAdvisor memory
#   - network - parsed cAdvisor network
#   - cpu_usage - calculated CPU usage of the container
#   - memory_usage - calculated memory usage of the container; if machine_memory_limit is given lower of container memory limit and machine memory limit used to calculate
#   - throughput_rx - calculated network Throughput Rx bytes
#   - throughput_tx - calculated network Throughput Tx bytes
#   - error_rx - calculated network error Rx
#   - error_tx - calculated network error Tx
#   - returnResult - notification string; was parsing was successful or not
#   - returnCode - 0 if parsing was successful, -1 otherwise
#   - errorMessage - returnResult if there was an error
# Results:
#   - SUCCESS - parsing was successful (returnCode == '0')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.docker.cadvisor

operation:
  name: parse_cadvisor_container
  inputs:
    - json_response
    - machine_memory_limit:
        default: -1
        required: false
  action:
    python_script: |
      try:
        import json
        decoded = json.loads(json_response)
        for key, value in decoded.items():
          statsPrev= value['stats'][len(value['stats'])-2]
          stats= value['stats'][len(value['stats'])-1]
          spec = value['spec']
        cpu=stats['cpu']
        memory=stats['memory']
        network=stats['network']
        timestamp=stats['timestamp']
        prev_timestamp=statsPrev['timestamp']
        cpu_total=cpu['usage']['total']
        prev_cpu_total=statsPrev['cpu']['usage']['total']
        timestamp_arr=timestamp.split(':')[2];
        prev_timestamp_arr=prev_timestamp.split(':')[2];
        interval=float(timestamp_arr[0:-1])-float(prev_timestamp_arr[0:-1])
        interval=interval*1000000000
        cpu_usage=float(cpu_total)-float(prev_cpu_total)
        cpu_usage=cpu_usage/interval
        throughput_tx=float(network['tx_bytes'])-float(statsPrev['network']['tx_bytes'])
        throughput_tx=throughput_tx/interval
        throughput_rx=float(network['rx_bytes'])-float(statsPrev['network']['rx_bytes'])
        throughput_rx=throughput_rx/interval
        error_tx=float(network['tx_errors'])-float(statsPrev['network']['tx_errors'])
        error_tx=error_tx/interval
        error_rx=float(network['rx_errors'])-float(statsPrev['network']['rx_errors'])
        error_rx=error_rx/interval
        memory_usage=float(memory['usage'])
        min=long(spec['memory']['limit'])
        machine_memory_limit=long(machine_memory_limit)
        if machine_memory_limit != -1:
          if min>machine_memory_limit:
            min=machine_memory_limit
        memory_usage=memory_usage/min
        returnCode = '0'
        returnResult = 'Parsing successful.'
      except:
        returnCode = '-1'
        returnResult = 'Parsing error.'
  outputs:
    - decoded
    - spec
    - stats
    - timestamp
    - cpu
    - memory
    - network
    - cpu_usage
    - memory_usage
    - throughput_rx
    - throughput_tx
    - error_rx
    - error_tx
    - returnCode
    - returnResult
    - errorMessage: returnResult if returnCode == '-1' else ''
  results:
    - SUCCESS: returnCode == '0'
    - FAILURE