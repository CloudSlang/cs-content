#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Creates an create.dto.acropolis.VMCloneDTO object.
# For example, it could be used for clone a Virtual Machine operation.
#
# Inputs:
#   - name - name for the cloned Virtual Machine
#   - numVcpus - overrides the number of vCPUs assigned to the clone
#   - memoryMb - overrides the amount of RAM assigned to the clone
#   - uuid - a version 4 UUID that the client may specify for idempotence.
#            This UUID will be used as the vm ID of the target vm
# Outputs:
#   - return_result - the response of the operation in case of success, the error message otherwise
#   - error_message - return_result if return_code is not "0"
#   - response - JSON response body containing an instance of Operation
#   - return_code - "0" if success, "-1" otherwise
####################################################

namespace: io.cloudslang.nutanix

operation:
  name: beta_create_resource_vmclonedto
  inputs:
    - name
    - numVcpus:
        required: false
    - memoryMb:
        required: false
    - uuid:
        required: false

  action:
    python_script: |
      try:
        import json

        json_main = {}
        json_body = {}
        json_body_table = [[]]

        if name:
          json_body['name'] = name
        if numVcpus:
          json_body['numVcpus'] = numVcpus
        if memoryMb:
          json_body['memoryMb'] = memoryMb
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
    - error_message: return_result if return_code == '-1' else ''
    - response
    - return_code