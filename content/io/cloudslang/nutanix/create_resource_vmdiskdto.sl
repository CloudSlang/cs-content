#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow creates a create.dto.acropolis.VMDiskDTO  object. For example, it could be used for create a Virtual Machine operation. 
#
#
# Inputs:
#   - vmDiskCreate - Optionnal - Specification for creating a new disk. Only one of 'vmCreateSpec' and 'vmCloneSpec' is required per create/update request
#   - diskAddress - Optionnal - Disk address represented by device bus type and device index
#   - isScsiPassThrough - Optionnal - Whether the SCSI disk should be attached in passthrough mode to pass all SCSI commands directly to Stargate via iSCSI. The default value is true
#   - vmDiskClone - Optionnal -  Specification for cloning a new disk or snapshot. Only one of 'vmCloneSpec' and 'vmCreateSpec' is required per create/update request
#   - isEmpty - Optionnal -  Whether the drive should be empty. This field only applies to CD-ROM drives, otherwise it is ignored. If this field is set to true and the drive is a CD-ROM, then the disk creation field 'vmDiskCreate' should be ignored. The default value is 'false'
#   - isCdrom - Optionnal -  Whether this is a CD-ROM drive. The default value is 'false'
# Outputs:
#   - return_code - "0" if success, "-1" otherwise
#   - return_result - the response of the operation in case of success, the error message otherwise
#   - reponse - jSon response body containing an instance of Operation
#   - error_message - return_result if return_code is not "0"
####################################################

namespace: io.cloudslang.nutanix

operation:
  name: create_resource_vmdiskdto
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
                return_code = '0'
                return_result = 'Success'
  outputs:
    - return_code
    - return_result
    - response
    - error_message: return_result if return_code == '-1' else ''
