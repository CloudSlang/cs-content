#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Detaches an EBS volume from an instance.
#!               Note: Make sure to un-mount any file systems on the device within your operating system before detaching
#!               the volume. Failure to do so results in the volume being stuck in a busy state while detaching. If an
#!               Amazon EBS volume is the root device of an instance, it can't be detached while the instance is running.
#!               To detach the root volume, stop the instance first. When a volume with an AWS Marketplace product code
#!               is detached from an instance, the product code is no longer associated with the instance. For more
#!               information, see Detaching an Amazon EBS Volume in the Amazon Elastic Compute Cloud User Guide.
#! @input provider: Cloud provider on which you the instance that have volume attached is - Default: 'amazon'
#! @input endpoint: Endpoint to which the request will be sent - Default: 'https://ec2.amazonaws.com'
#! @input identity: optional - the Amazon Access Key ID
#! @input credential: optional - the Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#! @input proxy_host: optional - the proxy server used to access the provider services
#! @input proxy_port: optional - the proxy server port used to access the provider services - Default: '8080'
#! @input debug_mode: optional - If 'true' then the execution logs will be shown in CLI console - Default: 'false'
#! @input region: optional - region where volume belongs. Ex: 'RegionOne', 'us-east-1'. ListRegionAction can be used in
#!                           order to get all regions - Default: 'us-east-1'
#! @input volume_id: ID of the EBS volume. The volume and instance must be within the same Availability Zone
#! @input instance_id: optional - ID of the instance
#! @input device_name: optional - Device name
#! @input force: optional - Forces detachment if the previous detachment attempt did not occur cleanly (for example,
#!                          logging into an instance, un-mounting the volume, and detaching normally). This option can lead
#!                          to data loss or a corrupted file system. Use this option only as a last resort to detach a volume
#!                          from a failed instance. The instance won't have an opportunity to flush file system caches or
#!                          file system metadata. If you use this option, you must perform file system check and repair
#!                          procedures
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: the list with existing regions was successfully retrieved
#! @result FAILURE: an error occurred when trying to retrieve the regions list
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.volumes

operation:
  name: detach_volume_in_region

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
    - instance_id:
        required: false
    - instanceId:
        default: ${get("instance_id", "")}
        private: true
        required: false
    - device_name:
        required: false
    - deviceName:
        default: ${get("device_name", "")}
        private: true
        required: false
    - force:
        default: 'false'
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-jClouds:0.0.6'
    class_name: io.cloudslang.content.jclouds.actions.volumes.DetachVolumeInRegionAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE