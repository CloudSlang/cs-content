#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow creates a create.dto.acropolis.VmDiskSpecCreateDTO object. For example, it could be used for create a Virtual Machine operation. 
#
#
# Inputs:
#   - size - Size of the Virtual Machine disk to be created in bytes
#   - sizeMb -  Size of the Virtual Machine disk to be created in MB
#   - containerName - Optionnal - WName of container to create disk in. If this is specified, then 'containerId' should not be specified
#   - containerId - Optionnal -  Id of container to create disk in. If this is specified, then 'containerName' should not be specified
# Outputs:
#   - return_code - "0" if success, "-1" otherwise
#   - return_result - the response of the operation in case of success, the error message otherwise
#   - reponse - jSon response body containing an instance of Operation
#   - error_message - return_result if return_code is not "0"
####################################################


namespace: io.cloudslang.nutanix

operation:
  name: create_resource_vmdiskspeccreatedto
  inputs:
    - size:
        required: true
    - sizeMb:
        required: true
    - containerName:
        required: false
    - containerId:
        required: false
  action:
    python_script: |
                import json

                json_main = {}
                json_body = {}
                json_body_table = [[]]

                if size:
                    json_body['size'] = size
                if sizeMb:
                    json_body['sizeMb'] = sizeMb
                if containerName:
                    json_body['containerName'] = containerName
                if vmDiskClone:
                    json_body['vmDiskClone'] = vmDiskClone
                if containerId:
                    json_body['containerId'] = containerId

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
