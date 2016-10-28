#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Acquires an Elastic IP address.
#!               Note: An Elastic IP address is for use either in the EC2-Classic platform or in a VPC.
#!                     For more information, see Elastic IP Addresses in the Amazon Elastic Compute Cloud User Guide.
#! @input endpoint: Endpoint to which the request will be sent
#!                  Default: 'https://ec2.amazonaws.com'
#! @input identity: ID of the secret access key associated with your Amazon AWS or IAM account.
#!                  Example: "AKIAIOSFODNN7EXAMPLE"
#! @input credential: Secret access key associated with your Amazon AWS or IAM account.
#!                    Example: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
#! @input proxy_host: optional - Proxy server used to connect to Amazon API. If empty no proxy will be used.
#!                    Default: ''
#! @input proxy_port: optional - Proxy server port. You must either specify values for both <proxy_host> and <proxy_port>
#!                    inputs or leave them both empty.
#!                    Default: ''
#! @input proxy_username: optional - Proxy server user name.
#!                    Default: ''
#! @input proxy_password: optional - Proxy server password associated with the <proxy_username> input value.
#!                    Default: ''
#! @input version: Version of the web service to made the call against it.
#!                 Example: "2014-06-15"
#! @input headers: optional - String containing the headers to use for the request separated by new line (CRLF). The
#!                 header name-value pair will be separated by ":".
#!                 Format: Conforming with HTTP standard for headers (RFC 2616).
#!                 Examples: Accept:text/plain
#!                 Default: ''
#! @input query_params: optional - String containing query parameters that will be appended to the URL. The names and the
#!                      values must not be URL encoded because if they are encoded then a double encoded will occur. The
#!                      separator between name-value pairs is "&" symbol. The query name will be separated from query
#!                      value by "=".
#!                      Examples: "parameterName1=parameterValue1&parameterName2=parameterValue2"
#!                      Default: ''
#! @input domain: optional - If set to "vpc" then allocates the address for use with instances in a VPC, otherwise for
#!                use with with instances in EC2 Classic way.
#!                Valid values: "standard", "vpc"
#!                Default: "standard"
#! @output return_result: outcome of the action in case of success, exception occurred otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output exception: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: success message
#! @result FAILURE: an error occurred when trying to allocate new IP address
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.network

operation:
  name: allocate_address

  inputs:
    - endpoint:
        default: 'https://ec2.amazonaws.com'
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
        default: '8080'
        required: false
    - proxyPort:
        default: ${get("proxy_port", "")}
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
        sensitive: true
    - proxyPassword:
        default: ${get("proxy_password", "")}
        private: true
        sensitive: true
        required: false
    - version
    - headers:
        default: ''
        required: false
    - query_params:
        required: false
    - queryParams:
        default: ${get("query_params", "")}
        private: true
        required: false
    - domain:
        default: 'standard'
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-jclouds:0.0.10'
    class_name: io.cloudslang.content.jclouds.actions.network.AllocateAddressAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE