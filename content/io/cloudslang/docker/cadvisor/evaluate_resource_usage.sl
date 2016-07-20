#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Evaluates if a Docker container's resource usages (memory, cpu, network) exceeds the given maximum usage.
#! @input rule: optional - Python query to determine if the resource usages is high
#!              Default: memory_usage < 0.8 and cpu_usage < 0.8 and throughput_rx < 0.8 and throughput_tx < 0.8
#!              and error_rx < 0.5 and error_tx < 0.5
#! @input memory_usage: calculated memory usage of container; if machine_memory_limit is given use lower of container
#!                      memory limit and machine memory limit to calculate
#! @input cpu_usage: calculated CPU usage of container
#! @input throughput_rx: calculated network Throughput Tx bytes
#! @input throughput_tx: calculated network Throughput Rx bytes
#! @input error_rx: calculated network error Tx
#! @input error_tx: calculated network error Rx
#! @output error_message: error message if error occurred
#! @output result: result if all resource usage did not exceed the maximum
#! @result LESS: all resource usage did not exceed the maximum
#! @result MORE: one or more resources' usage exceeded the maximum
#! @result FAILURE: input was not in correct format
#!!#
####################################################

namespace: io.cloudslang.docker.cadvisor

operation:
  name: evaluate_resource_usage
  inputs:
    - rule:
        default: >
          ${str(memory_usage) + '< 0.8 and ' + str(cpu_usage) + ' < 0.8 and ' + str(throughput_rx) + ' < 0.8 and ' +
          str(throughput_tx) + ' < 0.8
          and ' + str(error_rx) + '<0.5 and ' + str(error_tx) + '<0.5'}
        required: false
    - memory_usage
    - cpu_usage
    - throughput_rx
    - throughput_tx
    - error_rx
    - error_tx
  python_action:
    script: |
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
    - LESS: ${result}
    - MORE: ${not result}
    - FAILURE: ${error_message <> ""}
