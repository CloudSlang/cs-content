#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################

namespace: io.cloudslang.virtualization.vmware.virtual_machines

imports:
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings

flow:
  name: test_create_virtual_machine
  inputs:
    - host
    - port:
        default: '443'
        required: false
    - protocol:
        default: 'https'
        required: false
    - username:
        required: false
    - password
    - trust_everyone:
        default: 'true'
        required: false
    - data_center_name
    - hostname
    - virtual_machine_name
    - description:
        default: ''
        required: false
    - data_store
    - num_cpus:
        default: '1'
        required: false
    - vm_disk_size:
        default: '1024'
        required: false
    - vm_memory_size:
        default: '1024'
        required: false
    - guest_os_id

  workflow:
    - create_virtual_machine:
        do:
          create_virtual_machine:
            - host
            - port
            - protocol
            - username
            - password
            - trust_everyone
            - data_center_name
            - hostname
            - virtual_machine_name
            - description
            - data_store
            - num_cpus
            - vm_disk_size
            - vm_memory_size
            - guest_os_id
        publish:
          - return_result
          - return_code
          - exception : ${exception if exception != None else ''}
        navigate:
          - SUCCESS: check_result
          - FAILURE: CREATE_VIRTUAL_MACHINE_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${[str(exception), int(return_code)]}
            - list_2: ['', 0]
        navigate:
          - SUCCESS: get_text_occurrence
          - FAILURE: CHECK_RESPONSES_FAILURE

    - get_text_occurrence:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${str(return_result)}
            - string_to_find: "${'Success: Created'}"
            - ignore_case: True
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: GET_TEXT_OCCURRENCE_FAILURE

  outputs:
    - return_result
    - return_code
    - exception

  results:
    - SUCCESS
    - CREATE_VIRTUAL_MACHINE_FAILURE
    - CHECK_RESPONSES_FAILURE
    - GET_TEXT_OCCURRENCE_FAILURE
