#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will evaluate if a docker container resource usages (memory, cpu, network) 
#   exceeds the maximum usage 
#
#   Inputs:
#       - rule - optional - python query to determine if the resource usages is high
#       - cpu_usage - calculated cpu usages of the container
#       - memory_usage- calculated cpu usages of the container (if the machine_memory_limit is given use the minimum
#                       of the container memory limit and the machine memory limit to calculate)
#       - throughput_rx- calculated network Throughput Tx bytes
#       - throughput_tx- calculated network Throughput Rx bytes
#       - error_rx- calculated network error Tx
#       - error_tx- calculated network error Rx
#   Outputs:
#       - errorMessage: returnResult if returnCode is equal to -1 or statusCode different than 200
#       - result -if all resources usage not exceed the maximum
#   Results:
#       - LESS -  if all resources usage not exceed the maximum
#       - MORE -  if one or more resources usage exceed the maximum
#       - ERROR - if input was not in correct format
####################################################

namespace: org.openscore.slang.docker.cadvisor

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
            rule= memory_usage +'< 0.8 and '+cpu_usage+' < 0.8 and '+throughput_rx+' < 0.8 and '+throughput_tx+' < 0.8 and '+error_rx+'<0.5 and '+error_tx+'<0.5'
          result = error_message == "" and eval(rule)
      except ValueError:
          error_message = "inputs have to be float"
  outputs:
    - error_message
    - result
  results:
    - LESS: result == "True"
    - MORE: result == "False"
    - FAILURE: error_message <> ""