#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Creates an create.dto.acropolis.VMDiskDTO object.
#!               For example, it could be used for create a Virtual Machine operation.
#!
#! @input vm_disk_create: optional - Specification for creating a new disk.
#!                        Only one of 'vmCreateSpec' and 'vmCloneSpec' is required per create/update request
#! @input disk_address: optional - Disk address represented by device bus type and device index
#! @input is_scsi_pass_through: optional - Whether the SCSI disk should be attached in pass-through mode to pass all SCSI
#!                                         commands directly to stargate via iSCSI. Default: true
#! @input vm_disk_clone: optional - Specification for cloning a new disk or snapshot. Only one of 'vmCloneSpec' and
#!                                  'vmCreateSpec' is required per create/update request
#! @input is_empty: optional - Whether the drive should be empty. This field only applies to CD-ROM drives, otherwise
#!                             it is ignored. If this field is set to true and the drive is a CD-ROM, then the disk
#!                             creation field 'vmDiskCreate' should be ignored. Default: false
#! @input is_cdrom: optional - Whether this is a CD-ROM drive. Default: false
#!
#! @output return_result: the response of the operation in case of success, the error message otherwise
#! @output error_message: return_result if return_code is not "0"
#! @output response: JSON response body containing an instance of Operation
#! @output return_code: "0" if success, "-1" otherwise
#!
#! @result SUCCESS: command executed successfully
#! @result FAILURE: something went wrong
#!!#
####################################################

namespace: io.cloudslang.nutanix

operation:
  name: beta_create_resource_vmdiskdto
  inputs:
    - vm_disk_create:
        required: false
    - disk_address:
        required: false
    - is_scsi_pass_through:
        required: false
    - vm_disk_clone:
        required: false
    - is_empty:
        required: false
    - is_cdrom:
        required: false

  python_action:
    script: |
      try:
        import json

        json_main = {}
        json_body = {}
        json_body_table = [[]]

        if vm_disk_create:
          json_body['vmDiskCreate'] = vm_disk_create
        if disk_address:
          json_body['diskAddress'] = disk_address
        if is_scsi_pass_through:
          json_body['isScsiPassThrough'] = is_scsi_pass_through
        if vm_disk_clone:
          json_body['vmDiskClone'] = vm_disk_clone
        if is_empty:
          json_body['isEmpty'] = is_empty
        if is_cdrom:
          json_body['isCdrom'] = is_cdrom

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
    - FAILURE
