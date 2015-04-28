#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Evaluates if a Docker container's resource usages (memory, cpu, network) exceeds the given maximum usage.
#
# Inputs:
#   - rule - optional - Python query to determine if the resource usages is high - Default: memory_usage < 0.8 and cpu_usage < 0.8 and throughput_rx < 0.8 and throughput_tx < 0.8 and error_rx < 0.5 and error_tx < 0.5
#   - memory_usage- calculated memory usage of container; if machine_memory_limit is given use lower of container memory limit and machine memory limit to calculate
#   - cpu_usage - calculated CPU usage of container
#   - throughput_rx - calculated network Throughput Tx bytes
#   - throughput_tx - calculated network Throughput Rx bytes
#   - error_rx - calculated network error Tx
#   - error_tx - calculated network error Rx
# Outputs:
#   - errorMessage - returnResult if returnCode == -1 or statusCode != 200
#   - result - if all resource usage did not exceed the maximum
# Results:
#   - LESS -  all resource usage did not exceed the maximum
#   - MORE -  one or more resources' usage exceeded the maximum
#   - FAILURE - input was not in correct format
####################################################

namespace: io.cloudslang.docker.cadvisor

operation:
  name: evaluate_resource_usage
  inputs:
    - rule:
        default: "memory_usage +'< 0.8 and '+cpu_usage+' < 0.8 and '+throughput_rx+' < 0.8 and '+throughput_tx+' < 0.8 and '+error_rx+'<0.5 and '+error_tx+'<0.5'"
        required: false
    - memory_usage
    - cpu_usage
    - throughput_rx
    - throughput_tx
    - error_rx
    - error_tx
  action:
    python_script: |
      error_message = ""
      result = None
      try:
          if rule=="":
            rule= str(memory_usage) +'< 0.8 and '+str(cpu_usage)+' < 0.8 and '+str(throughput_rx)+' < 0.8 and '+str(throughput_tx)+' < 0.8 and '+str(error_rx)+'<0.5 and '+str(error_tx)+'<0.5'
          result = error_message == "" and eval(rule)
      except ValueError:
          error_message = "inputs have to be float"
  outputs:
    - error_message
    - result
  results:
    - LESS: result
    - MORE: not result
    - FAILURE: error_message <> ""