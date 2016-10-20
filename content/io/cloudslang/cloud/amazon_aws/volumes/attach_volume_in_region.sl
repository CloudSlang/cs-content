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
#! @input endpoint: Endpoint to which the request will be sent.
#!                  Default: 'https://ec2.amazonaws.com'
#! @input identity: optional - Amazon Access Key ID
#!                  Default: ''
#! @input credential: optional - Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#!                    Default: ''
#! @input proxy_host: optional - Proxy server used to access the provider services
#!                    Default: ''
#! @input proxy_port: optional - Proxy server port used to access the provider services.
#!                               Default: '8080'
#! @input proxy_username: optional - proxy server user name.
#! @input proxy_password: optional - proxy server password associated with the <proxyUsername> input value.
#! @input headers: optional - string containing the headers to use for the request separated by new line (CRLF).
#!                            The header name-value pair will be separated by ":".
#!                            Format: Conforming with HTTP standard for headers (RFC 2616)
#!                            Examples: "Accept:text/plain"
#! @input query_params: optional - string containing query parameters that will be appended to the URL. The names
#!                                 and the values must not be URL encoded because if they are encoded then a double encoded
#!                                 will occur. The separator between name-value pairs is "&" symbol. The query name will be
#!                                 separated from query value by "=".
#!                                 Examples: "parameterName1=parameterValue1&parameterName2=parameterValue2"
#! @input version: version of the web service to make the call against it.
#!                 Example: "2016-04-01"
#!                 Default: ""
#! @input volume_id: ID of the EBS volume. The volume and instance must be within the same Availability Zone
#! @input instance_id: ID of the instance
#! @input device_name: Device name
#!                     Example: '/dev/sdh'
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output exception: exception if there was an error when executing, empty otherwise
#! @result SUCCESS: the list with existing regions was successfully retrieved
#! @result FAILURE: an error occurred when trying to retrieve the regions list
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.volumes

operation:
  name: attach_volume_in_region

  inputs:
    - endpoint:
        default: 'https://ec2.amazonaws.com'
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
    - proxy_username:
        required: false
    - proxyUsername:
        required: false
        default: ${get("proxy_username", "")}
        private: true
    - proxy_password:
        required: false
        sensitive: true
    - proxyPassword:
        required: false
        default: ${get("proxy_password", "")}
        private: true
        sensitive: true
    - headers:
        required: false
    - query_params:
        required: false
    - queryParams:
        required: false
        default: ${get("query_params", "")}
        private: true
    - version:
        default: "2016-04-01"
        required: false
    - volume_id
    - volumeId:
        default: ${volume_id}
        private: true
    - instance_id
    - instanceId:
        default: ${get("instance_id", "")}
        private: true
    - device_name
    - deviceName: 
        default: ${device_name}
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.0'
    class_name: io.cloudslang.content.jclouds.actions.volumes.AttachVolumeAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE