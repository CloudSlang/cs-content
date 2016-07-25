#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Attaches an EBS volume to a running or stopped instance and exposes it to the instance with the specified
#!               device name.
#!               Note: Encrypted EBS volumes may only be attached to instances that support Amazon EBS encryption. For
#!               more information, see Amazon EBS Encryption in the Amazon Elastic Compute Cloud User Guide. For a list
#!               of supported device names, see Attaching an EBS Volume to an Instance. Any device names that aren't
#!               reserved for instance store volumes can be used for EBS volumes. For more information, see Amazon EC2
#!               Instance Store in the Amazon Elastic Compute Cloud User Guide. If a volume has an AWS Marketplace product
#!               code: - the volume can be attached only to a stopped instance; - AWS Marketplace product codes are copied
#!               from the volume to the instance; - you must be subscribed to the product; - the instance type and operating
#!               system of the instance must support the product. For example, you can't detach a volume from a Windows
#!               instance and attach it to a Linux instance. For more information about EBS volumes, see Attaching Amazon
#!               EBS Volumes in the Amazon Elastic Compute Cloud User Guide.
#! @input provider: Cloud provider on which you the instance, to attach volume to, is - Default: 'amazon'
#! @input endpoint: Endpoint to which the request will be sent - Default: 'https://ec2.amazonaws.com'
#! @input identity: optional - Amazon Access Key ID
#! @input credential: optional - Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#! @input proxy_host: optional - Proxy server used to access the provider services
#! @input proxy_port: optional - Proxy server port used to access the provider services - Default: '8080'
#! @input debug_mode: optional - If 'true' then the execution logs will be shown in CLI console - Default: 'false'
#! @input region: optional - Region where volume belongs. Ex: 'RegionOne', 'us-east-1'. ListRegionAction can be used in
#!                           order to get all regions - Default: 'us-east-1'
#! @input volume_id: ID of the EBS volume. The volume and instance must be within the same Availability Zone
#! @input instance_id: ID of the instance
#! @input device_name: Device name
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: the list with existing regions was successfully retrieved
#! @result FAILURE: an error occurred when trying to retrieve the regions list
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.volumes

operation:
  name: attach_volume_in_region

  inputs:
    - provider: 'amazon'
    - endpoint: 'https://ec2.amazonaws.com'
    - identity:
        required: false
        sensitive: true
    - credential:
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
    - debug_mode:
        required: false
    - debugMode:
        default: ${get("debug_mode", "false")}
        private: true
    - region:
        default: 'us-east-1'
        required: false
    - volume_id
    - volumeId:
        default: ${volume_id}
        private: true
    - instance_id
    - instanceId:
        default: ${instance_id}
        private: true
    - device_name
    - deviceName: 
        default: ${device_name}
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-jClouds:0.0.6'
    class_name: io.cloudslang.content.jclouds.actions.volumes.AttachVolumeInRegionAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE