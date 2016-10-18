#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Performs an Amazon Web Services Elastic Compute Cloud (EC2) command to launch one ore more new instance/instances
#! @input endpoint: Endpoint to which first request will be sent
#!                  Example: 'https://ec2.amazonaws.com'
#! @input identity: optional - Amazon Access Key ID
#!                  Default: ''
#! @input credential: optional - Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#!                    Default: ''
#! @input proxy_host: optional - Proxy server used to access the provider services
#!                    Default: ''
#! @input proxy_port: optional - Proxy server port used to access the provider services
#!                    Default: '8080'
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
#! @input version: version of the web service to made the call against it.
#!                 Example: "2016-04-01"
#!                 Default: ""
#! @input delimiter: the delimiter to split the user_ids_string and user_groups_string
#!                    Default: ','
#! @input availability_zone: optional - Specifies the placement constraints for launching instance. Amazon automatically
#!                           selects an availability zone by default
#!                           Default: ''
#! @input image_id: ID of the AMI. For more information go to:
#!                  http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ComponentsAMIs.html
#!                  Examples: 'ami-abcdef12'
#! @input min_count: optional - The minimum number of launched instances - Default: '1'
#! @input max_count: optional - The maximum number of launched instances - Default: '1'
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output exception: exception if there was an error when executing, empty otherwise
#! @result SUCCESS: the server (instance) was successfully launched/created
#! @result FAILURE: an error occurred when trying to launch/create a server (instance)
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.instances

operation:
  name: run_instances

  inputs:
    - endpoint:
        default: 'https://ec2.amazonaws.com'
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
    - version
    - delimiter:
        required: false
        default: ','
    - availability_zone:
        required: false
    - availabilityZone:
        default: ${get("availability_zone", "")}
        private: true
        required: false
    - image_id
    - imageId:
        default: ${get("image_id", "")}
        private: true
    - min_count:
        required: false
    - minCount:
        default: ${get("min_count", "1")}
        private: true
    - max_count:
        required: false
    - maxCount:
        default: ${get("max_count", "1")}
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-jclouds:0.0.9'
    class_name: io.cloudslang.content.jclouds.actions.instances.RunInstancesAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE