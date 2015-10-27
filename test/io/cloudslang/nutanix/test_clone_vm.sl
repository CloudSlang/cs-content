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
  lists: io.cloudslang.base.lists
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: test_vms_clone

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
          - error_message
          - return_code
        navigate:
          SUCCESS: check_result
          FAILURE: CREATE_RESOURCE_VMCLONEDTO

    - check_result:
        do:
          lists.compare_lists:
            - list_1: [str(error_message), int(return_code)]
            - list_2: ["''", 0]
        navigate:
          SUCCESS: nutanixCloneVM
          FAILURE: CHECK_RESPONSES_FAILURE

    - nutanixCloneVM:
        do:
          vms_clone:
            - host
            - username
            - password
            - templateId
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - body: return_result
        publish:
          - return_result
          - response
          - error_message
          - response_body: return_result
        navigate:
          SUCCESS: check_result2
          FAILURE: CLONE_VM

    - check_result2:
        do:
          lists.compare_lists:
            - list_1: [str(error_message), int(return_code), int(status_code)]
            - list_2: ["''", 0, 200]
        navigate:
          SUCCESS: SUCCESS
          FAILURE: CHECK_RESPONSES_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - CHECK_RESPONSES_FAILURE
    - CREATE_RESOURCE_VMCLONEDTO
    - CLONE_VM