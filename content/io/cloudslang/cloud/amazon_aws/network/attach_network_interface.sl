#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Attaches a network interface to an instance.
#!               Note: The set of: <instance_id>, <networkInterface_id>, <device_index> are mutually exclusive with
#!                     <query_params> input. Please provide values EITHER FOR ALL: <instance_id>, <networkInterface_id>,
#!                     <device_index> inputs OR FOR <query_params> input.
#!                     As with all Amazon EC2 operations, the results might not appear immediately.
#!                     For Region-Endpoint correspondence information, check all the service endpoints available at:
#!                     http://docs.amazonwebservices.com/general/latest/gr/rande.html#ec2_region
#! @input endpoint: Endpoint to which the request will be sent
#!                  Default: 'https://ec2.amazonaws.com'
#! @input identity: ID of the secret access key associated with your Amazon AWS or IAM account.
#!                  Example: "AKIAIOSFODNN7EXAMPLE"
#! @input credential: Secret access key associated with your Amazon AWS or IAM account.
#!                    Example: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
#! @input proxy_host: optional - Proxy server used to connect to Amazon API. If empty no proxy will be used.
#! @input proxy_port: optional - proxy server port. You must either specify values for both <proxy_host> and <proxy_port>
#!                    inputs or leave them both empty.
#! @input proxy_username: optional - proxy server user name.
#! @input proxy_password: optional - proxy server password associated with the <proxy_username> input value.
#! @input instance_id: optional - ID of the instance that will be attached to the network interface. The instance
#!                     should be running (hot attach) or stopped (warm attach).
#!                     Example: "i-abcdef12"
#! @input headers: optional - string containing the headers to use for the request separated by new line (CRLF). The header
#!                 name-value pair will be separated by ":". Format: Conforming with HTTP standard for headers (RFC 2616).
#!                 Examples: Accept:text/plain
#! @input query_params: optional - string containing query parameters that will be appended to the URL. The names and the
#!                      values must not be URL encoded because if they are encoded then a double encoded will occur. The
#!                      separator between name-value pairs is "&" symbol. The query name will be separated from query value by "=".
#!                      Examples: "parameterName1=parameterValue1&parameterName2=parameterValue2"
#! @input network_interface_id: optional - ID of the network interface to attach.
#!                              Example: "eni-12345678"
#! @input device_index: optional - ID of the device for the network interface attachment on the instance.
#!                      Example: "1"
#! @input version: Version of the web service to made the call against it.
#!                 Example: "2014-06-15"
#! @output return_result: outcome of the action in case of success, exception occurred otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: success message
#! @result FAILURE: an error occurred when trying to attach network interface to specified instance
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.network

operation:
  name: attach_network_interface

  inputs:
    - endpoint: 'https://ec2.amazonaws.com'
    - identity
    - credential:
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
        required: false
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
    - instance_id:
        required: false
    - instanceId:
        default: ${get("instance_id", "")}
        private: true
        required: false
    - headers:
        default: ''
        required: false
    - query_params:
        required: false
    - queryParams:
        default: ${get("query_params", "")}
        private: true
        required: false
    - network_interface_id
    - networkInterfaceId:
        default: ${get("network_interface_id", "")}
        private: true
        required: false
    - device_index
    - deviceIndex:
        default: ${get("device_index", "")}
        private: true
    - version

  java_action:
    gav: 'io.cloudslang.content:cs-jclouds:0.0.9'
    class_name: io.cloudslang.content.jclouds.actions.network.AttachNetworkInterfaceAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE