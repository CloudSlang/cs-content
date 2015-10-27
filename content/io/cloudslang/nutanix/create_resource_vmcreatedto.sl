#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow creates a create.dto.acropolis.VMCreateDTO object. For example, it could be used for create a Virtual Machine operation. 
#
#
# Inputs:
#   - name - Named for the cloned Virtual Machine
#   - memoryMb - Override the amount of RAM assigned to the clone
#   - numVcpus - Override the number of vCPUs assigned to the clone
#   - description - Optionnal -  Description for the Virtual Machine
#   - haPriority - Optionnal -  Priority for restarting in case of HA event
#   - numCoresPerVcpu - Optionnal -  Number of cores assigned to each VCPUs
#   - uuid - Optionnal -  A version 4 UUID that the client may specify for idempotence. This UUID will be used as the vm ID of the target vm
# Outputs:
#   - return_code - "0" if success, "-1" otherwise
#   - return_result - the response of the operation in case of success, the error message otherwise
#   - reponse - jSon response body containing an instance of Operation
#   - error_message - return_result if return_code is not "0"
####################################################

namespace: io.cloudslang.nutanix

operation:
  name: create_resource_vmcreatedto
  inputs:
    - name:
        required: true
    - memoryMb:
        required: true
    - numVcpus:
        required: true
    - description:
        required: false
    - haPriority:
        required: false
    - numCoresPerVcpu:
        required: false
    - uuid:
        required: false
  action:
    python_script: |
                import json

                json_main = {}
                json_body = {}
                json_body_table = [[]]

                if name:
                    json_body['name'] = name
                if memoryMb:
                    json_body['memoryMb'] = memoryMb
                if numVcpus:
                    json_body['numVcpus'] = numVcpus
                if description:
                    json_body['description'] = description
                if haPriority:
                    json_body['haPriority'] = haPriority
                if numCoresPerVcpu:
                    json_body['numCoresPerVcpu'] = numCoresPerVcpu
                if uuid:
                    json_body['uuid'] = uuid

                json_body_table[0] = json_body
                json_main['specList'] = json_body_table

                response = json.dumps(json_main, sort_keys=True)
                return_code = '0'
                return_result = 'Success'
  outputs:
    - return_code
    - return_result
    - response
    - error_message: return_result if return_code == '-1' else ''
