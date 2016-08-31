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
#! @input endpoint: Endpoint to which the request will be sent - Default: 'https://ec2.amazonaws.com'
#! @input identity: optional - ID of the secret access key associated with your Amazon AWS or IAM account.
#!                  Example: "AKIAIOSFODNN7EXAMPLE"
#! @input credential: optional - Secret access key associated with your Amazon AWS or IAM account.
#!                    Example: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
#! @input proxy_host: optional - proxy server used to connect to Amazon API. If empty no proxy will be used.
#! @input proxy_port: optional - proxy server port. You must either specify values for both <proxyHost> and <proxyPort>
#!                    inputs or leave them both empty.
#! @input proxy_username: optional - proxy server user name.
#! @input proxy_password: optional - proxy server password associated with the <proxyUsername> input value.
#! @input availability_zone: Specifies the Availability Zone in which to create the volume. See more on:
#!                           https://aws.amazon.com/about-aws/global-infrastructure. Amazon automatically selects an
#!                           Example: 'us-east-1d'
#!                           Default: ''
#! @input encrypted: Specifies whether the volume should be encrypted. Encrypted Amazon EBS volumes may only be attached
#!                   to instances that support Amazon EBS encryption. Volumes that are created from encrypted snapshots
#!                   are automatically encrypted. There is no way to create an encrypted volume from an unencrypted snapshot
#!                   or vice versa. If your AMI uses encrypted volumes, you can only launch it on supported instance types.
#!                   For more information, see Amazon EBS Encryption in the Amazon Elastic Compute Cloud User Guide.
#!                   Valid values: 'false', 'true'. Any other but valid values provided will be ignored.
#!                   Default: 'false'
#! @input iops: optional - only valid for Provisioned IOPS SSD volumes. The number of I/O operations per second (IOPS) to
#!                         provision for the volume, with a maximum ratio of 30 IOPS/GiB. Constraint: Range is 100 to 20000
#!                         for Provisioned IOPS SSD volumes
#! @input kms_key_id: optional - The full ARN of the AWS Key Management Service (AWS KMS) customer master key (CMK) to use
#!                    when creating the encrypted volume. This parameter is only required if you want to use a non-default
#!                    CMK; if this parameter is not specified, the default CMK for EBS is used. The ARN contains the
#!                    arn:aws:kms namespace, followed by the region of the CMK, the AWS account ID of the CMK owner, the
#!                    key namespace, and then the CMK ID. If a KmsKeyId is specified, the <encrypted> input must be set on "true".
#!                    Example: "arn:aws:kms:us-east-1:012345678910:key/abcd1234-a123-456a-a12b-a123b4cd56ef"
#! @input size: optional - size of the volume, in GiBs. If you specify a snapshot, the volume size must be equal to or
#!              larger than the snapshot size. If you're creating the volume from a snapshot and don't specify a volume
#!              size, the default is the snapshot size. Constraints: 1-16384 for "gp2", 4-16384 for "io1", 500-16384 for
#!              "st1", 500-16384 for "sc1", and 1-1024 for "standard".
#! @input snapshot_id: optional - Snapshot from which to create the volume - Default: ''
#! @input volume_type: optional - Volume type of the Amazon EBS volume - Valid values: 'gp2' (for General Purpose SSD volumes),
#!                                'io1' (for Provisioned IOPS SSD volumes), 'st1' (for Throughput Optimized HDD), 'sc1'
#!                                (for Cold HDD) and 'standard' (for Magnetic volumes) - Default: 'standard'
#! @input version: Version of the web service to made the call against it.
#!                 Example: "2014-06-15"
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: the list with existing regions was successfully retrieved
#! @result FAILURE: an error occurred when trying to retrieve the regions list
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.volumes

operation:
  name: create_volume

  inputs:
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
        default: ${get("proxy_port", "")}
        required: false
        private: true
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get("proxy_username", "")}
        private: true
        required: false
    - proxy_password:
        required: false
    - proxyPassword:
        default: ${get("proxy_password", "")}
        private: true
        required: false
    - availability_zone
    - availabilityZone:
        default: ${availability_zone}
        private: true
    - encrypted:
        default: 'false'
        required: false
    - iops:
        default: ''
        required: false
    - kms_key_id:
        required: false
    - kmsKeyId:
        default: ${get("kms_key_id", "")}
        private: true
        required: false
    - size:
        default: ''
        required: false
    - snapshot_id:
        required: false
    - snapshotId:
        default: ${get("snapshot_id", "")}
        private: true
        required: false
    - volume_type:
        required: false
    - volumeType:
        default: ${get("volume_type", "standard")}
        private: true
    - version

  java_action:
    gav: 'io.cloudslang.content:cs-jclouds:0.0.9'
    class_name: io.cloudslang.content.jclouds.actions.volumes.CreateVolumeAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE