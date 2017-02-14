#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Describes one or more of your network interfaces.
#!
#! @input endpoint: Optional - Endpoint to which the request will be sent
#!                  Default: 'https://ec2.amazonaws.com'
#! @input identity: ID of the secret access key associated with your Amazon AWS or IAM account.
#!                  Example: "AKIAIOSFODNN7EXAMPLE"
#! @input credential: Secret access key associated with your Amazon AWS or IAM account.
#!                    Example: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
#! @input proxy_host: Optional - Proxy server used to connect to Amazon API. If empty no proxy will be used.
#!                    Default: ''
#! @input proxy_port: Optional - Proxy server port. You must either specify values for both <proxy_host> and <proxy_port>
#!                    inputs or leave them both empty.
#!                    Default: ''
#! @input proxy_username: Optional - Proxy server user name.
#!                        Default: ''
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#!                        Default: ''
#! @input version: Version of the web service to make the call against it.
#!                 Example: '2014-06-15'
#!                 Default: '2014-06-15'
#! @input headers: Optional - String containing the headers to use for the request separated by new line (CRLF). The
#!                 header name-value pair will be separated by ":".
#!                 Format: Conforming with HTTP standard for headers (RFC 2616).
#!                 Examples: Accept:text/plain
#!                 Default: ''
#! @input query_params: Optional - String containing query parameters that will be appended to the URL. The names and the
#!                      values must not be URL encoded because if they are encoded then a double encoded will occur. The
#!                      separator between name-value pairs is "&" symbol. The query name will be separated from query
#!                      value by "=".
#!                      Examples: "parameterName1=parameterValue1&parameterName2=parameterValue2"
#!                      Default: ''
#! @input delimiter: Optional - delimiter that will be used
#!                   Default: ','
#! @input filter_names_string: Optional - String that contains one or more values that represents filters for the search.
#!                             For a complete list of valid filters see: http://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeNetworkInterfaces.html
#!                             Example: "status,attachment.status"
#!                             Default: ""
#! @input filter_values_string: Optional - String that contains one or more values that represents filters values.
#!                              For a complete list of valid filters see: http://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeNetworkInterfaces.html
#!                              Example of filters values for the above <filterNamesString> input: "in-use|available,attaching|attached|detaching|detached"
#!                              Note that "in-use|available" represents values for "status" and are separated
#!                              by the enforced "|" symbol
#!                              Default (describes all your network interfaces): ""
#! @input network_interface_id: Optional - String that contains one or more network interface IDs.
#!                              Example: 'eni-12345678,eni-87654321'
#!
#! @output return_result: Outcome of the action in case of success, exception occurred otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output exception: Error message if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: Success message
#! @result FAILURE: An error occurred when trying to retrieve network interfaces details.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.network

operation:
  name: describe_network_interfaces

  inputs:
    - endpoint:
        default: 'https://ec2.amazonaws.com'
        required: false
    - identity
    - credential:
        sensitive: true
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        required: false
        private: true
    - proxy_port:
        default: '8080'
        required: false
    - proxyPort:
        default: ${get("proxy_port", "")}
        required: false
        private: true
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get("proxy_username", "")}
        required: false
        private: true
    - proxy_password:
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get("proxy_password", "")}
        private: true
        sensitive: true
        required: false
    - version:
        default: '2016-11-15'
        required: false
    - headers:
        default: ''
        required: false
    - query_params:
        required: false
    - queryParams:
        default: ${get("query_params", "")}
        required: false
        private: true
    - delimiter:
        default: ','
        required: false
    - filter_names_string:
        required: false
    - filterNamesString:
        default: ${get("filter_names_string", "")}
        required: false
        private: true
    - filter_values_string:
        required: false
    - filterValuesString:
        default: ${get("filter_values_string", "")}
        required: false
        private: true
    - network_interface_id:
        required: false
    - networkInterfaceId:
        default: ${get("network_interface_id", "")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.8'
    class_name: io.cloudslang.content.amazon.actions.network.DescribeNetworkInterfacesAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE