#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Performs an Amazon Web Services Elastic Compute Cloud (EC2) command to list the servers (instances)
#!               from a cloud region.
#! @input provider: the cloud provider on which the instance is - Default: 'amazon'
#! @input endpoint: the endpoint to which first request will be sent - Default: 'https://ec2.amazonaws.com'
#! @input identity: optional - the Amazon Access Key ID
#! @input credential: optional - the Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#! @input region: optional - the region where the servers (instances) are. list_regions operation can be used in order
#!                to get all regions - Default: 'us-east-1'
#! @input proxy_host: optional - the proxy server used to access the provider services
#! @input proxy_port: optional - the proxy server port used to access the provider services - Default: '8080'
#! @input delimiter: optional - the delimiter used in result list
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: the list with existing servers (instances) was successfully retrieved
#! @result FAILURE: an error occurred when trying to retrieve servers (instances) list
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.instances

operation:
  name: list_servers

  inputs:
    - provider: 'amazon'
    - endpoint: 'https://ec2.amazonaws.com'
    - identity:
        required: false
        sensitive: true
    - credential:
        required: false
        sensitive: true
    - region:
        default: 'us-east-1'
        required: false
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        private: true
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get("proxy_port", "8080")}
        private: true
    - delimiter:
        default: ''
        required: false

  java_action:
    class_name: io.cloudslang.content.jclouds.actions.instances.ListServersAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${exception if exception in locals() else ''}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
