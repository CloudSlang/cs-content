#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Performs an Amazon Web Services Elastic Compute Cloud (EC2) command to start a STOPPED server (instance)
#!               and changes its status to ACTIVE. PAUSED and SUSPENDED servers (instances) cannot be started.
#! @input provider: the cloud provider on which the instance is - Default: 'amazon'
#! @input endpoint: the endpoint to which first request will be sent - Default: 'https://ec2.amazonaws.com'
#! @input identity: optional - the Amazon Access Key ID
#! @input credential: optional - the Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#! @input region: optional - the region where the server (instance) to be started can be found. list_regions operation
#!                can be used in order to get all regions - Default: 'us-east-1'
#! @input server_id: the ID of the server (instance) you want to start
#! @input proxy_host: optional - the proxy server used to access the provider services
#! @input proxy_port: optional - the proxy server port used to access the provider services - Default: '8080'
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: the server (instance) was successfully started
#! @result FAILURE: an error occurred when trying to start a server (instance)
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws

operation:
  name: start_server

  inputs:
    - provider: 'amazon'
    - endpoint: 'https://ec2.amazonaws.com'
    - identity:
        required: false
    - credential:
        required: false
    - region:
        default: 'us-east-1'
        required: false
    - server_id
    - serverId: ${server_id}
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

  action:
    java_action:
      className: io.cloudslang.content.jclouds.actions.StartServerAction
      methodName: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${'' if 'exception' not in locals() else exception}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
