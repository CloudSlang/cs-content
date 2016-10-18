#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Performs an Amazon Web Services Elastic Compute Cloud (EC2) command to list all regions.
#! @input provider: the cloud provider - Default: 'amazon'
#! @input endpoint: the endpoint to which the request will be sent - Default: 'https://ec2.amazonaws.com'
#! @input identity: optional - the Amazon Access Key ID
#! @input credential: optional - the Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#! @input proxy_host: optional - the proxy server used to access the provider services
#! @input proxy_port: optional - the proxy server port used to access the provider services - Default: '8080'
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
#! @input key_filters_string: optional - String that contains one or more filter keys separated by delimiter.
#!                           Example: "endpoint", "region-name"
#!                          Default: ""
#! @input value_filters_string: optional - String that contains one or more filter values separated by delimiter.
#!                           Example: "ec2.eu-central-1.amazonaws.com", "us-east-1"
#!                           Default: ""
#! @input regions_string: String that contains one or more regions.
#!                           Example: "us-east-1,eu-central-1"
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output exception: exception if there was an error when executing, empty otherwise
#! @result SUCCESS: the list with existing regions was successfully retrieved
#! @result FAILURE: an error occurred when trying to retrieve the regions list
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.regions

operation:
  name: describe_regions

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
    - version
    - delimiter:
        required: false
        default: ','
    - key_filters_string
    - keyFiltersString:
        default: ${get("key_filters_string", "")}
        private: true
    - value_filters_string
    - valueFiltersString:
        default: ${get("value_filters_string", "")}
        private: true
    - regions_string
    - regionsString:
        default: ${get("regions_string", "")}
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-jclouds:0.0.9'
    class_name: io.cloudslang.content.jclouds.actions.regions.DescribeRegionsAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
