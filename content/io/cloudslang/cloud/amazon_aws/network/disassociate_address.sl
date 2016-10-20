#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Disassociates an Elastic IP address from the instance or network interface it's associated with.
#!               Note: An Elastic IP address is for use in either the EC2-Classic platform or in a VPC. For more information,
#!                     see Elastic IP Addresses in the Amazon Elastic Compute Cloud User Guide.
#!               Important: This is an idempotent operation. If you perform the operation more than once, Amazon EC2 doesn't
#!                          return an error.
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
#! @input headers: optional - String containing the headers to use for the request separated by new line (CRLF). The
#!                 header name-value pair will be separated by ":".
#!                 Format: Conforming with HTTP standard for headers (RFC 2616).
#!                 Examples: Accept:text/plain
#!                 Default: ''
#! @input query_params: optional - String containing query parameters that will be appended to the URL. The names and the
#!                      values must not be URL encoded because if they are encoded then a double encoded will occur. The
#!                      separator between name-value pairs is "&" symbol. The query name will be separated from query
#!                      value by '='.
#!                      Examples: 'parameterName1=parameterValue1&parameterName2=parameterValue2'
#!                      Default: ''
#! @input version: version of the web service to make the call against it.
#!                 Example: '2014-06-15'
#!                 Default: '2014-06-15'
#! @input association_id: optional - [EC2-VPC] Association ID. Required for EC2-VPC.
#!                        Default: ''
#! @input public_ip: optional - Elastic IP address. This is required for EC2-Classic.
#!                                     Default: ''
#! @output return_result: outcome of the action in case of success, exception occurred otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output exception: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: success message
#! @result FAILURE: an error occurred when trying to disassociate specified IP address
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.network

operation:
  name: disassociate_address

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
    - headers:
        default: ''
        required: false
    - query_params:
        required: false
    - queryParams:
        default: ${get("query_params", "")}
        private: true
        required: false
    - version:
        default: "2014-06-15"
        required: false
    - association_id:
        required: false
    - associationId:
        default: ${get("association_id", "")}
        private: true
        required: false
    - public_ip:
        required: false
    - publicIp:
        default: ${get("public_ip", "")}
        private: true
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.0'
    class_name: io.cloudslang.content.jclouds.actions.network.DisassociateAddressAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE