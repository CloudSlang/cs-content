#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Creates an create.dto.acropolis.VMDiskDTO object.
# For example, it could be used for create a Virtual Machine operation.
#
# Inputs:
#   - vmDiskCreate - optional - Specification for creating a new disk.
#                               Only one of 'vmCreateSpec' and 'vmCloneSpec' is required per create/update request
#   - diskAddress - optional - Disk address represented by device bus type and device index
#   - isScsiPassThrough - optional - Whether the SCSI disk should be attached in pass-through mode to pass all SCSI
#                                    commands directly to stargate via iSCSI. Default: true
#   - vmDiskClone - optional - Specification for cloning a new disk or snapshot. Only one of 'vmCloneSpec' and
#                              'vmCreateSpec' is required per create/update request
#   - isEmpty - optional -  Whether the drive should be empty. This field only applies to CD-ROM drives, otherwise
#                              it is ignored. If this field is set to true and the drive is a CD-ROM, then the disk
#                              creation field 'vmDiskCreate' should be ignored. Default: false
#   - isCdrom - optional - Whether this is a CD-ROM drive. Default: false
# Outputs:
#   - return_result - the response of the operation in case of success, the error message otherwise
#   - error_message - return_result if return_code is not "0"
#   - response - JSON response body containing an instance of Operation
#   - return_code - "0" if success, "-1" otherwise
####################################################

namespace: io.cloudslang.nutanix

operation:
  name: beta_create_resource_vmdiskdto
  inputs:
    - vmDiskCreate:
        required: false
    - diskAddress:
        required: false
    - isScsiPassThrough:
        required: false
    - vmDiskClone:
        required: false
    - isEmpty:
        required: false
    - isCdrom:
        required: false

  action:
    python_script: |
      try:
        import json

        json_main = {}
        json_body = {}
        json_body_table = [[]]

        if vmDiskCreate:
          json_body['vmDiskCreate'] = vmDiskCreate
        if diskAddress:
          json_body['diskAddress'] = diskAddress
        if isScsiPassThrough:
          json_body['isScsiPassThrough'] = isScsiPassThrough
        if vmDiskClone:
          json_body['vmDiskClone'] = vmDiskClone
        if isEmpty:
          json_body['isEmpty'] = isEmpty
        if isCdrom:
          json_body['isCdrom'] = isCdrom

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
