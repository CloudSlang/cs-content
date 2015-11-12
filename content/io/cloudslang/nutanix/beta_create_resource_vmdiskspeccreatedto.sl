#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Creates an create.dto.acropolis.VmDiskSpecCreateDTO object.
# For example, it could be used for create a Virtual Machine operation.
#
#
# Inputs:
#   - size - Size of the Virtual Machine disk to be created in bytes
#   - size_mb -  Size of the Virtual Machine disk to be created in MB
#   - container_name - optional - WName of container to create disk in.
#                                If this is specified, then 'containerId' should not be specified
#   - container_id - optional -  Id of container to create disk in.
#                               If this is specified, then 'containerName' should not be specified
# Outputs:
#   - return_result - the response of the operation in case of success, the error message otherwise
#   - error_message - return_result if return_code is not "0"
#   - response - JSON response body containing an instance of Operation
#   - return_code - "0" if success, "-1" otherwise
####################################################


namespace: io.cloudslang.nutanix

operation:
  name: beta_create_resource_vmdiskspeccreatedto
  inputs:
    - size
    - size_mb
    - container_name
    - container_id

  action:
    python_script: |
      try:
        import json

        json_main = {}
        json_body = {}
        json_body_table = [[]]

        if size:
          json_body['size'] = size
        if size_mb:
          json_body['sizeMb'] = size_mb
        if container_name:
          json_body['containerName'] = container_name
        if vmDiskClone:
          json_body['vmDiskClone'] = vmDiskClone
        if container_id:
          json_body['containerId'] = container_id

        json_body_table[0] = json_body
        json_main['specList'] = json_body_table

        response = json.dumps(json_main, sort_keys=True)
        return_code = '0'
        return_result = 'Success'
      except:
        return_result = 'An error occurred.'
        return_code = '-1'
  outputs:
    - return_result
    - error_message: return_result if return_code == '-1' else ''
    - response
    - return_code