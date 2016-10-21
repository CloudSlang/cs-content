#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Creates a network interface in the specified subnet.
#!               Note: For more information about network interfaces, see Elastic Network Interfaces in the Amazon Elastic
#!                     Compute Cloud User Guide.
#! @input endpoint: Optional - Endpoint to which the request will be sent
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
#! @input delimiter: Optional - Delimiter that will be used - Default: ','
#! @input network_interface_description: optional - A description for the network interface.
#!                                       Default: ''
#! @input private_ip_address: optional - Primary private IP address of the network interface. If you
#!                                              don't specify an IP address, Amazon EC2 selects one for you from the subnet
#!                                              range. If you specify an IP address, you cannot indicate any IP addresses
#!                                              specified in privateIpAddresses as primary (only one IP address can be
#!                                              designated as primary).
#!                                              Default: ''
#! @input private_ip_addresses_string: optional - String that contains one or more private IP addresses separated by <delimiter>
#!                                     Default: ''
#! @input secondary_private_ip_address_count: optional - Number of secondary private IP addresses to assign to a network
#!                                            interface. When you specify a number of secondary IP addresses, Amazon EC2
#!                                            selects these IP addresses within the subnet range. You can't specify this
#!                                            option and specify more than one private IP address using privateIpAddresses.
#!                                            The number of IP addresses you can assign to a network interface varies by
#!                                            instance type. For more information, see Private IP Addresses Per ENI Per
#!                                            Instance Type in the Amazon Elastic Compute Cloud User Guide.
#!                                            http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI
#!                                            Example: '2'
#! @input security_group_ids_string: optional - IDs of one or more security groups.
#!                                   Default: ''
#! @input subnet_id: ID of the subnet to associate with the network interface.
#! @output return_result: outcome of the action in case of success, exception occurred otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output exception: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: success message
#! @result FAILURE: an error occurred when trying to create a new network interface
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.network

operation:
  name: create_network_interface

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
    - delimiter:
        default: ','
        required: false
    - network_interface_description:
        required: false
    - networkInterfaceDescription:
        default: ${get("network_interface_description", "")}
        private: true
        required: false
    - private_ip_address:
        required: false
    - privateIpAddress:
        default: ${get("private_ip_address", "")}
        private: true
        required: false
    - private_ip_addresses_string:
        required: false
    - privateIpAddressesString:
        default: ${get("private_ip_addresses_string", "")}
        private: true
        required: false
    - secondary_private_ip_address_count:
        required: false
    - secondaryPrivateIpAddressCount:
        default: ${get("secondary_private_ip_address_count", "")}
        private: true
        required: false
    - security_group_ids_string:
        required: false
    - securityGroupIdsString:
        default: ${get("security_group_ids_string", "")}
        private: true
        required: false
    - subnet_id
    - subnetId:
        default: ${get("subnet_id", "")}
        private: true
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.0'
    class_name: io.cloudslang.content.amazon.actions.network.CreateNetworkInterfaceAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE