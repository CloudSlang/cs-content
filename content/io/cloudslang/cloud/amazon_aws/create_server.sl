#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Performs an Amazon Web Services Elastic Compute Cloud (EC2) command to launch (create) one ore more new
#!               instance/instances
#! @input provider: the cloud provider on which the instance is - Default: 'amazon'
#! @input endpoint: the endpoint to which first request will be sent - Default: 'https://ec2.amazonaws.com'
#! @input identity: optional - the Amazon Access Key ID
#! @input credential: optional - the Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#! @input proxy_host: optional - the proxy server used to access the provider services
#! @input proxy_port: optional - the proxy server port used to access the provider services - Default: '8080'
#! @input region: optional - the region where the server (instance) to be created/launched can be found.
#!                           "regions/list_regions" operation can be used in order to get all regions - Default: 'us-east-1'
#! @input availability_zone: optional - specifies the placement constraints for launching instance. Amazon automatically
#!                                     selects an availability zone by default - Default: ''
#! @input image_ref: the ID of the AMI. For more information go to: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ComponentsAMIs.html
#!                   - Examples: 'ami-fce3c696', 'ami-4b91bb21'
#! @input min_count: optional - The minimum number of launched instances - Default: '1'
#! @input max_count: optional - The maximum number of launched instances - Default: '1'
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: the server (instance) was successfully launched/created
#! @result FAILURE: an error occurred when trying to launch/create a server (instance)
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws

operation:
  name: create_server

  inputs:
    - provider: 'amazon'
    - endpoint: 'https://ec2.amazonaws.com'
    - identity:
        required: false
    - credential:
        required: false
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        overridable: false
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get("proxy_port", "8080")}
        overridable: false
    - region:
        default: 'us-east-1'
        required: false
    - availability_zone:
        default: ''
        required: false
    - availabilityZone:
        default: ${get("availability_zone", "")}
        overridable: false
    - image_ref
    - imageRef:
        default: ${image_ref}
        overridable: false
    - min_count:
        default: '1'
        required: false
    - minCount:
        default: ${get("min_count", "1")}
        overridable: false
    - max_count:
        default: '1'
        required: false
    - maxCount:
        default: ${get("max_count", "1")}
        overridable: false

  action:
    java_action:
      className: io.cloudslang.content.jclouds.actions.CreateServerAction
      methodName: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${'' if exception not in locals() else exception}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE