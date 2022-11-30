#   (c) Copyright 2022 Micro Focus, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: This operation is used to form the request body of the insert disk based on the provided inputs.
#!
#! @input disk_name: The name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash.
#! @input disk_description: An optional description of this resource. Provide this property when you create the resource.
#! @input disk_size: The size, in GB, of the persistent disk. You can specify this field when creating a persistent disk using the sourceImage, sourceSnapshot, or sourceDisk parameter, or specify it alone to create an empty persistent disk.If you specify this field along with a source, the value of sizeGb must not be less than the size of the source. Acceptable values are 1 to 65536, inclusive.
#! @input disk_type: The URL of the disk type resource describing which disk type to use to create the disk. Provide this when creating the disk. For example: projects/project/zones/zone/diskTypes/pd-ssd . See Persistent disk types.
#! @input label_keys: The labels key list separated by comma(,).
#! @input label_values: The labels value list separated by comma(,).
#! @input source_snapshot: The source snapshot used to create this disk. You can provide this as a partial or full URL to the resource. For example, the following are valid values:
#!                         https://www.googleapis.com/compute/v1/projects/project/global/snapshots/snapshot
#!                         projects/project/global/snapshots/snapshot
#!                         global/snapshots/snapshot
#! @input source_snapshot_encryption_key: The customer-supplied encryption key of the source snapshot. Required if the source snapshot is protected by a customer-supplied encryption key.
#! @input source_image: Source image to restore onto a disk. This field is optional.
#! @input image_encryption_key: The customer-supplied encryption key of the source image. Required if the source image is protected by a customer-supplied encryption key.
#! @input licenses_list: A list of publicly visible licenses separated by comma(,). Reserved for Google's use.
#! @input source_disk: The source disk used to create this disk. You can provide this as a partial or full URL to the resource. For example, the following are valid values:
#!                     https://www.googleapis.com/compute/v1/projects/project/zones/zone/disks/disk
#!                     https://www.googleapis.com/compute/v1/projects/project/regions/region/disks/disk
#!                     projects/project/zones/zone/disks/disk
#!                     projects/project/regions/region/disks/disk
#!                     zones/zone/disks/disk
#!                     regions/region/disks/disk
#! @input disk_encryption_key: Specifies a 256-bit customer-supplied encryption key, encoded in RFC 4648 base64 to either encrypt or decrypt this resource. For example: "rawKey": "SGVsbG8gZnJvbSBHb29nbGUgQ2xvdWQgUGxhdGZvcm0="
#!
#! @output return_result: The request body.
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#!
#! @result SUCCESS: The request body formed successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute_v2.disks.utils
operation:
  name: create_insert_disk_request_body
  inputs:
    - disk_name:
        required: true
    - disk_description:
        required: false
    - disk_size:
        required: false
    - disk_type:
        required: false
    - label_keys:
        required: false
    - label_values:
        required: false
    - source_snapshot:
        required: false
    - source_snapshot_encryption_key:
        required: false
    - source_image:
        required: false
    - image_encryption_key:
        required: false
    - licenses_list:
        required: false
    - source_disk:
        required: false
    - disk_encryption_key:
        required: false
  python_action:
    use_jython: false
    script: "# do not remove the execute function\r\nimport json\r\ndef execute(disk_description,disk_size,disk_type,disk_name,label_keys,label_values,source_snapshot,source_snapshot_encryption_key,\r\nsource_image,image_encryption_key,licenses_list,source_disk,disk_encryption_key):\r\n    return_code = 0\r\n    return_result = '\"name\": \"'+disk_name+'\"'\r\n        \r\n    if (disk_description == '' and disk_size == '' and disk_type == ''):\r\n        return_code =-1\r\n        return_result = return_result\r\n    if disk_description != '':\r\n        return_result = return_result + ',\"description\": \"'+disk_description+'\"'\r\n    if disk_size != '':\r\n        return_result = return_result + ',\"sizeGb\": \"'+disk_size+'\"'\r\n    if disk_type != '':\r\n        return_result = return_result + ',\"type\": \"'+disk_type+'\"'\r\n    if source_snapshot != '':\r\n        return_result = return_result + ',\"sourceSnapshot\": \"'+source_snapshot+'\"'\r\n    if source_snapshot_encryption_key != '':\r\n        return_result = return_result + ',\"sourceSnapshotEncryptionKey\": { \"rawKey\" : \"'+ source_snapshot_encryption_key +'\"}'\r\n    if source_image != '':\r\n        return_result = return_result + ',\"sourceImage\": \"'+ source_image +'\"'\r\n    if image_encryption_key != '':\r\n        return_result = return_result + ',\"sourceImageEncryptionKey\": { \"rawKey\" : \"'+ image_encryption_key +'\"}'\r\n    if licenses_list != '':\r\n        license = licenses_list.split(',')\r\n        return_result = return_result + ',\"licenses\": ' + json.dumps(license)\r\n    if source_disk != '':\r\n        return_result = return_result + ',\"sourceDisk\": \"'+ source_disk +'\"'        \r\n    if disk_encryption_key != '':\r\n        return_result = return_result + ',\"diskEncryptionKey\": { \"rawKey\" : \"'+ disk_encryption_key +'\"}'        \r\n    if label_keys != '':\r\n        label_keys=label_keys.split(',')\r\n        label_values=label_values.split(',')\r\n        return_result = return_result+',\"labels\": '+json.dumps(dict(zip(label_keys,label_values)))\r\n    return{\"return_code\": return_code, \"return_result\": '{'+return_result+'}'}"
  outputs:
    - return_result
    - return_code
  results:
    - SUCCESS
