#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Creates an EBS volume that can be attached to an instance in the same Availability Zone. The volume is
#!               created in the regional endpoint that you send the HTTP request to.
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
#! @input region: optional - Region where volume will reside. Ex: 'RegionOne', 'us-east-1'. ListRegionAction can be used
#!                           in order to get all regions - Default: 'us-east-1'
#! @input availability_zone: Specifies the placement constraints for launching instance. Amazon automatically selects an
#!                           availability zone by default - Default: ''
#! @input snapshot_id: optional - Snapshot from which to create the volume - Default: ''
#! @input volume_type: optional - Volume type of the Amazon EBS volume - Valid values: 'gp2' (for General Purpose SSD volumes),
#!                                'io1' (for Provisioned IOPS SSD volumes), 'st1' (for Throughput Optimized HDD), 'sc1'
#!                                (for Cold HDD) and 'standard' (for Magnetic volumes) - Default: 'standard'
#! @input size: optional - size of the volume, in GiBs. Constraints: 1-16384 for gp2, 4-16384 for io1, 500-16384 for st1,
#!                         500-16384 for sc1, and 1-1024 for standard. If you specify a snapshot, the volume size must
#!                         be equal to or larger than the snapshot size. If you're creating the volume from a snapshot
#!                         and don't specify a volume size, the default is the snapshot size - Default: '1'
#! @input iops: optional - only valid for Provisioned IOPS SSD volumes. The number of I/O operations per second (IOPS) to
#!                         provision for the volume, with a maximum ratio of 30 IOPS/GiB. Constraint: Range is 100 to 20000
#!                         for Provisioned IOPS SSD volumes
#! @input encrypted: Specifies whether the volume should be encrypted. Encrypted Amazon EBS volumes may only be attached
#!                   to instances that support Amazon EBS encryption. Volumes that are created from encrypted snapshots
#!                   are automatically encrypted. There is no way to create an encrypted volume from an unencrypted snapshot
#!                   or vice versa. If your AMI uses encrypted volumes, you can only launch it on supported instance types.
#!                   For more information, see Amazon EBS Encryption in the Amazon Elastic Compute Cloud User Guide.
#!                   Valid values: 'false', 'true'. Any other but valid values provided will be ignored
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: the list with existing regions was successfully retrieved
#! @result FAILURE: an error occurred when trying to retrieve the regions list
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.volumes

operation:
  name: create_volume_in_availability_zone

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
    - availability_zone
    - availabilityZone:
        default: ${availability_zone}
        private: true
    - snapshot_id:
        required: false
    - snapshotId:
        default: ${get("snapshot_id", "")}
        private: true
        required: false
    - volume_type:
        required: false
    - volumeType:
        default: ${get("volume_type", "")}
        private: true
        required: false
    - size:
        default: '1'
        required: false
    - iops:
        default: ''
        required: false
    - encrypted:
        default: ''
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-jClouds:0.0.6'
    class_name: io.cloudslang.content.jclouds.actions.volumes.CreateVolumeInAvailabilityZoneAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE