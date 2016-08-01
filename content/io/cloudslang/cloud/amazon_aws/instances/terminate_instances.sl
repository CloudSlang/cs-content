#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Performs an Amazon Web Services Elastic Compute Cloud (EC2) command to shut down an instance. If you
#!               terminate an instance more than once, each call succeeds. Terminated instances remain visible after
#!               termination for approximately one hour
#! @input provider: the cloud provider on which the instance is - Default: 'amazon'
#! @input endpoint: the endpoint to which first request will be sent - Default: 'https://ec2.amazonaws.com'
#! @input identity: optional - the Amazon Access Key ID
#! @input credential: optional - the Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#! @input proxy_host: optional - the proxy server used to access the provider services
#! @input proxy_port: optional - the proxy server port used to access the provider services - Default: '8080'
#! @input debug_mode: optional - If 'true' then the execution logs will be shown in CLI console - Default: 'false'
#! @input region: optional - the region where the server (instance) to be started can be found. "regions/list_regions" operation
#!                           can be used in order to get all regions - Default: 'us-east-1'
#! @input instance_id: the ID of the server (instance) you want to terminate
#! @input proxy_host: optional - the proxy server used to access the provider services
#! @input proxy_port: optional - the proxy server port used to access the provider services - Default: '8080'
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: the server (instance) was successfully terminated
#! @result FAILURE: an error occurred when trying to terminate a server (instance)
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.instances

operation:
  name: terminate_instances

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
    - instance_id
    - instanceId:
        default: ${instance_id}
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-jClouds:0.0.6'
    class_name: io.cloudslang.content.jclouds.actions.instances.TerminateInstancesAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
