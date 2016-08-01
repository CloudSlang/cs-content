#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Describes one or more of the images (AMIs, AKIs, and ARIs) available to you. Images available to you include
#!               public images, private images that you own, and private images owned by other AWS accounts but for which you
#!               have explicit launch permissions.
#!               Note: De-registered images are included in the returned results for an unspecified interval after de-registration.
#! @input provider: Cloud provider on which the instance is - Default: 'amazon'
#! @input endpoint: Endpoint to which first request will be sent - Default: 'https://ec2.amazonaws.com'
#! @input identity: optional - Amazon Access Key ID
#! @input credential: optional - Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#! @input proxy_host: optional - Proxy server used to access the provider services
#! @input proxy_port: optional - Proxy server port used to access the provider services - Default: '8080'
#! @input delimiter: optional - Delimiter that will be used - Default: ','
#! @input debug_mode: optional - If 'true' then the execution logs will be shown in CLI console - Default: 'false'
#! @input region: optional - Region where image to be de-registered reside. ListRegionAction can be used in order to get
#!                           all regions. For further details check: http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region
#!                         - Default: 'us-east-1'
#! @input identity_id: - Scopes the images by users with explicit launch permissions. Specify an AWS account ID, 'self'
#!                       (the sender of the request), or 'all' (public AMIs) - Valid: '' (no identity_id filtering),
#!                       'self', 'all' or AWS account ID - Default: ''
#! @input architecture: optional - Instance architecture - Valid values: '' (no architecture filtering), 'i386', 'x86_64'
#!                               - Default: ''
#! @input delete_on_termination: optional - a Boolean that indicates whether the EBS volume is deleted on instance termination.
#!                                        - Valid values: '' (no delete_on_termination filtering), 'true', 'false' - Default: ''
#! @input block_mapping_device_name: optional - Device name for the EBS volume - Ex: '/dev/sdh' - Default: ''
#! @input block_device_mapping_snapshot_id: optional - ID of the snapshot used for the Amazon EBS volume - Default: ''
#! @input volume_size: optional - Volume size of the Amazon EBS volume, in GiB - Default: ''
#! @input volume_type: optional - Volume type of the Amazon EBS volume - Valid values: '' (no delete_on_termination filtering),
#!                                'gp2' (for General Purpose SSD volumes), 'io1' (for Provisioned IOPS SSD volumes),
#!                                and 'standard' (for Magnetic volumes) - Default: ''
#! @input hypervisor: optional - Hypervisor type of the instance. Valid values: '' (no hypervisor filtering), 'ovm', 'xen'
#!                             - Default: ''
#! @input image_id: optional - ID of the specified image to search for - Default: ''
#! @input kernel_id: optional - Kernel ID  - Default: ''
#! @input owner_alias: optional - AWS account alias. Ex: 'amazon' - Default: ''
#! @input owner_id: optional - AWS account ID of the instance owner - Default: ''
#! @input platform: optional - platform used. Use 'windows' if you have Windows instances; otherwise leave blank.
#!                           - Valid values: '', 'windows' - Default: ''
#! @input product_code: optional - product code associated with the AMI used to launch the instance - Default: ''
#! @input product_code_type: optional - type of product code. Valid values: '' (no hypervisor filtering), 'devpay',
#!                                      'marketplace' - Default: ''
#! @input ramdisk_id: optional - RAM disk ID - Default: ''
#! @input root_device_name: optional - name of the root device for the instance. Ex: '/dev/sda1' - Default: ''
#! @input root_device_type: optional - type of root device that the instance uses - Valid values: '' (no root_device_type filtering),
#!                                     'ebs', 'instance-store' - Default: ''
#! @input state_reason_code: optional - reason code for the state change - Default: ''
#! @input state_reason_message: optional - a message that describes the state change - Default: ''
#! @input key_tags_string: optional - A string that contains: none, one or more key tags separated by delimiter - Default: ''
#! @input value_tags_string: optional - A string that contains: none, one or more tag values separated by delimiter - Default: ''
#! @input virtualization_type: optional - virtualization type of the instance - Valid values: '' (no virtualization_type filtering),
#!                                        'paravirtual', 'hvm' - Default: '
#! @input ids_string: optional - A string that contains: none, one or more image IDs separated by delimiter - Default: ''
#! @input owners_string: optional - Filters the images by the owner. Specify an AWS account ID, a'mazon' (owner is Amazon),
#!                                  'aws-marketplace' (owner is AWS Marketplace), 'self' (owner is the sender of the request).
#!                                  Omitting this option returns all images for which you have launch permissions, regardless
#!                                  of ownership - Valid values: '' (no owners_string filtering), 'amazon', 'aws-marketplace',
#!                                  or 'self' - Default: ''
#! @input description: optional - Description of the image (provided during image creation) - Default: ''
#! @input type: optional - Image type - Valid values: '' (no owners_string filtering), 'machine', 'kernel', 'ramdisk' - Default: ''
#! @input is_public: optional - A Boolean that indicates whether the image is public - Valid values: '' (no is_public filtering),
#!                              'true', 'false' - Default: ''
#! @input manifest_location: optional - Location of the image manifest - Default: ''
#! @input name: optional - Name of the AMI (provided during image creation) - Default: ''
#! @input state: optional - State of the image - Valid values: '' (no state filtering), 'available', 'pending', 'failed' - Default: ''
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: the image was successfully created
#! @result FAILURE: an error occurred when trying to create image
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.images

operation:
  name: describe_images_in_region

  inputs:
    - provider: 'amazon'
    - endpoint: 'https://ec2.amazonaws.com'
    - identity:
        default: ''
        required: false
        sensitive: true
    - credential:
        default: ''
        required: false
        sensitive: true
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        private: true
        required: false
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get("proxy_port", "8080")}
        private: true
    - delimiter:
        default: ','
        required: false
    - debug_mode:
        required: false
    - debugMode:
        default: ${get("debug_mode", "false")}
        private: true
    - region:
        default: 'us-east-1'
        required: false
    - identity_id:
        required: false
    - identityId: ${get("identity_id", "")}
    - delete_on_termination:
        required: false
    - deleteOnTermination:
        default: ${get("delete_on_termination", "")}
        private: true
        required: false
    - block_mapping_device_name:
        required: false
    - blockMappingDeviceName:
        default: ${get("block_mapping_device_name", "")}
        private: true
        required: false
    - block_device_mapping_snapshot_id:
        required: false
    - blockDeviceMappingSnapshotId:
        default: ${get("block_device_mapping_snapshot_id", "")}
        private: true
        required: false
    - volume_size:
        required: false
    - volumeSize:
        default: ${get("volume_size", "")}
        private: true
        required: false
    - volume_type:
        required: false
    - volumeType:
        default: ${get("volume_type", "")}
        private: true
        required: false
    - hypervisor:
        default: ''
        required: true
    - image_id:
        required: false
    - imageId:
        default: ${get("image_id", "")}
        private: true
        required: false
    - kernel_id:
        required: false
    - kernelId:
        default: ${get("kernel_id", "")}
        private: true
        required: false
    - owner_alias:
        required: false
    - ownerAlias:
        default: ${get("owner_alias", "")}
        private: true
        required: false
    - owner_id:
        required: false
    - ownerId:
        default: ${get("owner_id", "")}
        private: true
        required: false
    - platform:
        default: ''
        required: false
    - product_code:
        required: false
    - productCode:
        default: ${get("product_code", "")}
        private: true
        required: false
    - product_code_type:
        required: false
    - productCodeType:
        default: ${get("product_code_type", "")}
        private: true
        required: false
    - ramdisk_id:
        required: false
    - ramdiskId:
        default: ${get("ramdisk_id", "")}
        private: true
        required: false
    - root_device_name:
        required: false
    - rootDeviceName:
        default: ${get("root_device_name", "")}
        private: true
        required: false
    - root_device_type:
        required: false
    - rootDeviceType:
        default: ${get("root_device_type", "")}
        private: true
        required: false
    - state_reason_code:
        required: false
    - stateReasonCode:
        default: ${get("state_reason_code", "")}
        private: true
        required: false
    - state_reason_message:
        required: false
    - stateReasonMessage:
        default: ${get("state_reason_message", "")}
        private: true
        required: false
    - key_tags_string:
        required: false
    - keyTagsString:
        default: ${get("key_tags_string", "")}
        private: true
        required: false
    - value_tags_string:
        required: false
    - valueTagsString:
        default: ${get("value_tags_string", "")}
        private: true
        required: false
    - virtualization_type:
        required: false
    - virtualizationType:
        default: ${get("virtualization_type", "")}
        private: true
        required: false
    - ids_string:
        required: false
    - idsString:
        default: ${get("ids_string", "")}
        private: true
        required: false
    - owners_string:
        required: false
    - ownersString:
        default: ${get("owners_string", "")}
        private: true
        required: false
    - description:
        default: ''
        required: false
    - type:
        default: ''
        required: false
    - is_public:
        required: false
    - isPublic:
        default: ${get("is_public", "")}
        private: true
        required: false
    - manifest_location:
        required: false
    - manifestLocation:
        default: ${get("manifest_location", "")}
        private: true
        required: false
    - name:
        default: ''
        required: false
    - state:
        default: ''
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-jClouds:0.0.6'
    class_name: io.cloudslang.content.jclouds.actions.images.DescribeImagesInRegionAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
