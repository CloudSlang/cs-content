#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Detaches a network interface from an instance.
#!               Note: The set of: <attachmentId> and <force> are mutually exclusive with <queryParams> input.
#!                     Please provide values EITHER FOR BOTH: <attachmentId> and <force> inputs OR FOR <queryParams> input.
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
#! @input headers: optional - string containing the headers to use for the request separated by new line (CRLF). The header
#!                 name-value pair will be separated by ":". Format: Conforming with HTTP standard for headers (RFC 2616).
#!                 Examples: Accept:text/plain
#! @input query_params: optional - string containing query parameters that will be appended to the URL. The names and the
#!                      values must not be URL encoded because if they are encoded then a double encoded will occur. The
#!                      separator between name-value pairs is "&" symbol. The query name will be separated from query value by "=".
#!                      Examples: "parameterName1=parameterValue1&parameterName2=parameterValue2"
#! @input attachment_id: ID of the attachment.
#!                       Example: "eni-attach-12345678"
#! @input force_detach: optional - specifies whether to force a detachment or not - Valid values: "true", "false".
#!                      Default: "false"
#! @input version: Version of the web service to made the call against it.
#!                 Example: "2014-06-15"
#! @output return_result: outcome of the action in case of success, exception occurred otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: success message
#! @result FAILURE: an error occurred when trying to detach specified network interface
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.network

operation:
  name: detach_network_interface

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
    - headers:
        default: ''
        required: false
    - query_params:
        required: false
    - queryParams:
        default: ${get("query_params", "")}
        private: true
        required: false
    - attachment_id
    - attachmentId:
        default: ${get("attachment_id", "")}
        private: true
        required: false
    - force_detach:
        required: false
    - forceDetach:
        default: ${get("force_detach", "false")}
        private: true
    - version

  java_action:
    gav: 'io.cloudslang.content:cs-jclouds:0.0.9'
    class_name: io.cloudslang.content.jclouds.actions.network.DetachNetworkInterfaceAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE