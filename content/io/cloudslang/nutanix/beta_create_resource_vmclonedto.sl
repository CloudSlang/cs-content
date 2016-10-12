#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Creates an create.dto.acropolis.VMCloneDTO object.
#!               For example, it could be used for clone a Virtual Machine operation.
#!
#! @input name:name for the cloned Virtual Machine
#! @input num_vcpus: overrides the number of vCPUs assigned to the clone
#! @input memory_mb: overrides the amount of RAM assigned to the clone
#! @input uuid: a version 4 UUID that the client may specify for idempotence.
#!              This UUID will be used as the vm ID of the target vm
#!
#! @output return_result: the response of the operation in case of success, the error message otherwise
#! @output error_message: return_result if return_code is not "0"
#! @output response: JSON response body containing an instance of Operation
#! @output return_code: "0" if success, "-1" otherwise
#!
#! @result SUCCESS: virtual machine cloned successfully
#! @result FAILURE: something went wrong
#!!#
####################################################

namespace: io.cloudslang.nutanix

operation:
  name: beta_create_resource_vmclonedto
  inputs:
    - name
    - num_vcpus:
        required: false
    - memory_mb:
        required: false
    - uuid:
        required: false

  python_action:
    script: |
      try:
        import json

        json_main = {}
        json_body = {}
        json_body_table = [[]]

        if name:
          json_body['name'] = name
        if num_vcpus:
          json_body['numVcpus'] = num_vcpus
        if memory_mb:
          json_body['memoryMb'] = memory_mb
        if uuid:
          json_body['uuid'] = uuid

        json_body_table[0] = json_body
        json_main['specList'] = json_body_table

        response = json.dumps(json_main, sort_keys=True)

        return_result = 'Success'
        return_code = '0'
      except:
        return_result = 'An error occurred.'
        return_code = '-1'
  outputs:
    - return_result
    - error_message: ${return_result if return_code == '-1' else ''}
    - response
    - return_code

  results:
    - SUCCESS: ${return_code == '0'}
    - FAIYRE