#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Creates a snapshot of an Amazon EBS volume and stores it in Amazon S3.
#!               Note: You can use snapshots for backups, to make copies of instance store volumes, and to save data before
#!               shutting down an instance. When a snapshot is created from a volume with an AWS Marketplace product code,
#!               the product code is propagated to the snapshot. You can take a snapshot of an attached volume that is in
#!               use. However, snapshots only capture data that has been written to your Amazon EBS volume at the time the
#!               snapshot command is issued. This might exclude any data that has been cached by any applications or the
#!               operating system. If you can pause any file writes to the volume long enough to take a snapshot, your
#!               snapshot should be complete. However, if you can't pause all file writes to the volume, you should un-mount
#!               the volume from within the instance, issue the snapshot command, and then remount the volume to ensure
#!               a consistent and complete snapshot. You can remount and use your volume while the snapshot status is pending.
#!               To create a snapshot for Amazon EBS volumes that serve as root devices, you should stop the instance before
#!               taking the snapshot. Snapshots that are taken from encrypted volumes are automatically encrypted. Volumes
#!               that are created from encrypted snapshots are also automatically encrypted. Your encrypted volumes and
#!               any associated snapshots always remain protected. For more information, see Amazon Elastic Block Store
#!               and Amazon EBS Encryption in the Amazon Elastic Compute Cloud User Guide.
#! @input provider: Cloud provider on which the instance is - Default: 'amazon'
#! @input endpoint: Endpoint to which first request will be sent - Default: 'https://ec2.amazonaws.com'
#! @input identity: optional - Amazon Access Key ID
#! @input credential: optional - Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#! @input proxy_host: optional - Proxy server used to access the provider services
#! @input proxy_port: optional - Proxy server port used to access the provider services - Default: '8080'
#! @input debug_mode: optional - If 'true' then the execution logs will be shown in CLI console - Default: 'false'
#! @input region: optional - Region in which the volume whose snapshot is being created resides. ListRegionAction can be
#!                           used in order to get all regions. For further details check: http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region
#!                         - Default: 'us-east-1'
#! @input volume_id: ID of the EBS volume
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: the image was successfully created
#! @result FAILURE: an error occurred when trying to create image
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.snapshots

operation:
  name: create_snapshot_in_region

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

  java_action:
    gav: 'io.cloudslang.content:cs-jClouds:0.0.6'
    class_name: io.cloudslang.content.jclouds.actions.snapshots.CreateSnapshotInRegionAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE