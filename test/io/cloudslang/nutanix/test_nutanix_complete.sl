#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.nutanix

imports:
  utils: io.cloudslang.base.utils
  print: io.cloudslang.base.print

flow:
  name: test_nutanix_complete
  inputs:
    - name
    - numVcpus
    - memoryMb
    - uuid
    - host
    - port
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
          create_resource_vmclonedto:
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
          create_resource_vmcreatedto:
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

    - nutanixCreateVM:
        do:
          vms_create:
            - host
            - port
            - username
            - password
            - templateId
            - body: response
        publish:
          - return_result
          - response
          - error_message
          - response_body: return_result

    - print_nutanixCreateVM:
        do:
          print.print_text:
            - text: response

    - nutanixCloneVM:
        do:
          vms_clone:
            - host
            - port
            - username
            - password
            - templateId
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

