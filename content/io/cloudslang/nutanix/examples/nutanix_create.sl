#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Sample workflow for Google Container Engine
#
# Inputs:
# 
# Outputs:
#   - return_result - response of the operation
#   - status_code - normal status code is 202
#   - error_message: returnResult if statusCode != '202'
# Results:
#   - SUCCESS - operation succeeded (statusCode == '202')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.nutanix.examples

imports:
  nutanix: io.cloudslang.nutanix
  utils: io.cloudslang.base.utils
  print: io.cloudslang.base.print

flow:
  name: nutanix_create
  inputs:
    - name
    - numVcpus
    - memoryMb
    - uuid
    - host
    - username
    - password
    - templateId
    - proxy_host
    - proxy_port
    - proxy_username
    - proxy_password
    - description
    - haPriority
    - numCoresPerVcpu
  workflow:
    - nutanixCreateResourceVMClone:
        do:
          nutanix.create_resource_vmclonedto:
            - name
            - numVcpus
            - memoryMb
            - uuid
        publish:
          - return_result
          - response
          - error_message
          - response_body: return_result

    - print_reateResourceVMClone:
        do:
          print.print_text:
            - text: response

    - nutanixCreateResourceVMCreate:
        do:
          nutanix.create_resource_vmcreatedto:
            - name
            - memoryMb
            - numVcpus
            - description
            - haPriority
            - numCoresPerVcpu
            - uuid
        publish:
          - return_result
          - response
          - error_message
          - response_body: return_result

    - print_reateResourceVMCreate:
        do:
          print.print_text:
            - text: response

    - nutanixCloneVM:
        do:
          nutanix.vms_clone:
            - host
            - username
            - password
            - templateId
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - body: response
        publish:
          - return_result
          - response
          - error_message
          - response_body: return_result

    - print_nutanixCloneVM:
        do:
          print.print_text:
            - text: response
  outputs:
    - return_result
    - error_message
  results:
    - SUCCESS
    - FAILURE

