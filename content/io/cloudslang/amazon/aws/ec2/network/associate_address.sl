#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Associates an Elastic IP address with an instance or a network interface.
#!               Note: An Elastic IP address is for use in either the EC2-Classic platform or in a VPC. For more information,
#!                     see Elastic IP Addresses in the Amazon Elastic Compute Cloud User Guide.
#!                     [EC2-Classic, VPC in an EC2-VPC-only account] If the Elastic IP address is already associated with
#!                     a different instance, it is disassociated from that instance and associated with the specified instance.
#!                     [VPC in an EC2-Classic account] If you don't specify a private IP address, the Elastic IP address
#!                     is associated with the primary IP address. If the Elastic IP address is already associated with a
#!                     different instance or a network interface, you get an error unless you allow re-association.
#!               Important: This is an idempotent operation. If you perform the operation more than once, Amazon EC2 doesn't
#!                          return an error, and you may be charged for each time the Elastic IP address is remapped to
#!                          the same instance. For more information, see the Elastic IP Addresses section of Amazon EC2
#!                          Pricing.
#!
#! @input endpoint: optional - Endpoint to which first request will be sent
#!                  Example: 'https://ec2.amazonaws.com'
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
#! @input version: version of the web service to make the call against it.
#!                 Example: "2014-06-15"
#!                 Default: "2014-06-15"
#! @input headers: optional - String containing the headers to use for the request separated by new line (CRLF). The
#!                 header name-value pair will be separated by ":".
#!                 Format: Conforming with HTTP standard for headers (RFC 2616).
#!                 Examples: Accept:text/plain
#!                 Default: ''
#! @input query_params: optional - String containing query parameters that will be appended to the URL. The names and the
#!                      values must not be URL encoded because if they are encoded then a double encoded will occur. The
#!                      separator between name-value pairs is "&" symbol. The query name will be separated from query
#!                      value by '='.
#!                      Examples: "parameterName1=parameterValue1&parameterName2=parameterValue2"
#!                      Default: ''
#! @input allocation_id: optional - [EC2-VPC] Allocation ID. This is required for EC2-VPC.
#!                       Example: 'eipalloc-abcdef12'
#!                       Default: ''
#! @input instance_id: optional - ID of the instance. This is required for EC2-Classic. For EC2-VPC, you can specify either
#!                     the instance ID or the network interface ID, but not both. The operation fails if you specify an
#!                     instance ID unless exactly one network interface is attached.
#!                     Example: 'i-12345678'
#!                     Default: ''
#! @input allow_reassociation: optional - [EC2-VPC] For a VPC in an EC2-Classic account, specify 'true' to allow an
#!                             Elastic IP address that is already associated with an instance or network interface to be
#!                             re-associated with the specified instance or network interface. Otherwise, the operation
#!                             fails. In a VPC in an EC2-VPC-only account, re-association is automatic, therefore you can
#!                             specify 'false' to ensure the operation fails if the Elastic IP address is already associated
#!                             with another resource. Any other values except valid values will be ignored.
#!                             Valid values: 'true', 'false'
#!                             Default: 'false'
#! @input network_interface_id: optional - [EC2-VPC] ID of the network interface. If the instance has more than one network
#!                              interface, you must specify a network interface ID.
#!                              Example: 'eni-12345678'
#!                              Default: ''
#! @input private_ip_address: optional - [EC2-VPC] The primary or secondary private IP address to associate
#!                            with the Elastic IP address. If no private IP address is specified, the Elastic
#!                            IP address is associated with the primary private IP address.
#!                            Default: ''
#! @input public_ip: optional - Elastic IP address. This is required for EC2-Classic.
#!
#! @output return_result: outcome of the action in case of success, exception occurred otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output exception: error message if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: success message
#! @result FAILURE: an error occurred when trying to associate the IP address with spacified network interface
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.network

operation:
  name: associate_address

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
        default: "2014-06-15"
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
    - allocation_id:
        required: false
    - allocationId:
        default: ${get("allocation_id", "")}
        required: false
        private: true
    - instance_id:
        required: false
    - instanceId:
        default: ${get("instance_id", "")}
        required: false
        private: true
    - allow_reassociation:
        required: false
    - allowReassociation:
        default: ${get("allow_reassociation", "false")}
        required: false
        private: true
    - network_interface_id:
        required: false
    - networkInterfaceId:
        default: ${get("network_interface_id", "")}
        required: false
        private: true
    - private_ip_address:
        required: false
    - privateIpAddress:
        default: ${get("private_ip_address", "")}
        required: false
        private: true
    - public_ip:
        required: false
    - publicIp:
        default: ${get("public_ip", "")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.7'
    class_name: io.cloudslang.content.amazon.actions.network.AssociateAddressAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE