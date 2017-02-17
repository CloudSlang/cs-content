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
#!                    Default: '8080'
#! @input proxy_username: Optional - Proxy server user name.
#!                        Default: ''
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#!                        Default: ''
#! @input version: Optional - Version of the web service to make the call against it.
#!                 Example: '2016-11-15'
#!                 Default: '2016-11-15'
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
#! @input filter_addresses_private_ip_address: Optional - The private IPv4 addresses associated with the network
#!                                             interface.
#! @input filter_addresses_primary: Optional - Whether the private IPv4 address is the primary IP address associated
#!                                  with the network interface.
#! @input filter_addresses_association_public_ip: Optional - The association ID returned when the network interface was
#!                                                associated with the Elastic IP address (IPv4).
#! @input filter_addresses_association_owner_id: Optional - The owner ID of the addresses associated with the network
#!                                               interface.
#! @input filter_association_association_id: Optional - The association ID returned when the network interface
#!                                           was associated with an IPv4 address.
#! @input filter_association_allocation_id: Optional - The allocation ID returned when you allocated the Elastic
#!                                          IP address (IPv4) for your network interface.
#! @input filter_association_ip_owner_id: Optional - The owner of the Elastic IP address (IPv4) associated with the
#!                                        network interface.
#! @input filter_association_public_ip: Optional - The address of the Elastic IP address (IPv4) bound to the
#!                                      network interface.
#! @input filter_association_public_dns_name: Optional - The public DNS name for the network interface (IPv4).
#! @input filter_attachment_attachment_id: Optional - The ID of the interface attachment.
#! @input filter_attachment_attach_time: Optional - The time that the network interface was attached to an instance.
#! @input filter_attachment_delete_on_termination: Optional - Indicates whether the attachment is deleted when an
#!                                                 instance is terminated.
#! @input filter_attachment_device_index: Optional - The device index to which the network interface is attached.
#! @input filter_attachment_instance_id: Optional - The ID of the instance to which the network interface is attached.
#! @input filter_attachment_instance_owner_id: Optional - The owner ID of the instance to which the network interface
#!                                             is attached.
#! @input filter_attachment_nat_gateway_id: Optional - The ID of the NAT gateway to which the network interface is
#!                                          attached.
#! @input filter_attachment_status: Optional - The status of the attachment.
#!                                  Valid values: attaching, attached, detaching, detached.
#! @input filter_availability_zone: Optional - The Availability Zone of the network interface.
#! @input filter_description: Optional - The description of the network interface.
#! @input filter_group_id: Optional - The ID of a security group associated with the network interface.
#! @input filter_group_name: Optional - The name of a security group associated with the network interface.
#! @input filter_ipv6_addresses_ipv6_address: Optional - An IPv6 address associated with the network interface.
#! @input filter_mac_address: Optional - The MAC address of the network interface.
#! @input filter_network_interface_id: Optional - The ID of the network interface.
#! @input filter_owner_id: Optional - The AWS account ID of the network interface owner.
#! @input filter_private_ip_address: Optional - The private IPv4 address or addresses of the network interface.
#! @input filter_private_dns_name: Optional - The private DNS name of the network interface (IPv4).
#! @input filter_requester_id: Optional - The ID of the entity that launched the instance on your behalf (for example,
#!                             AWS Management Console, Auto Scaling, and so on).
#! @input filter_requester_managed: Optional - Indicates whether the network interface is being managed by an AWS service
#!                                  (for example, AWS Management Console, Auto Scaling, and so on).
#! @input filter_source_desk_check: Optional - Indicates whether the network interface performs source/destination
#!                                  checking. A value of true means checking is enabled, and false means checking is
#!                                  disabled. The value must be false for the network interface to perform network address
#!                                  translation (NAT) in your VPC.
#! @input filter_status: Optional - The status of the network interface. If the network interface is not attached to an
#!                       instance, the status is available; if a network interface is attached to an instance the status
#!                       is in-use.
#!                       Valid values: in-use, available.
#! @input filter_subnet_id: Optional - The ID of the subnet for the network interface.
#! @input filter_tag: Optional - The key/value combination of a tag assigned to the resource. Specify the key of the tag
#!                    in the filter name and the value of the tag in the filter value.
#!                    Format: <FilterName1>=<FilterValue1>,<FilterName2>=<FilterValue2>
#!                    Example: Purpose1=X,Purpose2=B
#! @input filter_tag_key: Optional - The key of a tag assigned to the resource. This filter is independent of the
#!                        filter_tag_value filter. For example, if you use both filter_tag_key = "Purpose" and
#!                        filter_tag_value = "X", you get any resources assigned both the tag key "Purpose" (regardless
#!                        of what the tag's value is), and the tag value "X" (regardless of what the tag's key is).
#!                        If you want to list only resources where "Purpose" is "X", see the filter_tag.
#! @input filter_tag_value: Optional - The value of a tag assigned to the resource. This filter is independent of the
#!                          filter_tag_key.
#! @input filter_vpc_id: Optional - The ID of the VPC for the network interface.
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
    - filter_addresses_private_ip_address:
        required: false
    - filterAddressesPrivateIpAddress:
        default: ${get("filter_addresses_private_ip_address", "")}
        private: true
        required: false
    - filter_addresses_primary:
        required: false
    - filterAddressesPrimary:
        default: ${get("filter_addresses_primary", "")}
        private: true
        required: false
    - filter_addresses_association_public_ip:
        required: false
    - filterAddressesAssociationPublicIp:
        default: ${get("filter_addresses_association_public_ip", "")}
        private: true
        required: false
    - filter_addresses_association_owner_id:
        required: false
    - filterAddressesAssociationOwnerId:
        default: ${get("filter_addresses_association_owner_id", "")}
        private: true
        required: false
    - filter_association_association_id:
        required: false
    - filterAssociationAssociationId:
        default: ${get("filter_association_association_id", "")}
        private: true
        required: false
    - filter_association_allocation_id:
        required: false
    - filterAssociationAllocationId:
        default: ${get("filter_association_allocation_id", "")}
        private: true
        required: false
    - filter_association_ip_owner_id:
        required: false
    - filterAssociationIpOwnerId:
        default: ${get("filter_association_ip_owner_id", "")}
        private: true
        required: false
    - filter_association_public_ip:
        required: false
    - filterAssociationPublicIp:
        default: ${get("filter_association_public_ip", "")}
        private: true
        required: false
    - filter_association_public_dns_name:
        required: false
    - filterAssociationPublicDnsName:
        default: ${get("filter_association_public_dns_name", "")}
        private: true
        required: false
    - filter_attachment_attachment_id:
        required: false
    - filterAttachmentAttachmentId:
        default: ${get("filter_attachment_attachment_id", "")}
        private: true
        required: false
    - filter_attachment_attach_time:
        required: false
    - filterAttachmentAttachTime:
        default: ${get("filter_attachment_attach_time", "")}
        private: true
        required: false
    - filter_attachment_delete_on_termination:
        required: false
    - filterAttachmentDeleteOnTermination:
        default: ${get("filter_attachment_delete_on_termination", "")}
        private: true
        required: false
    - filter_attachment_device_index:
        required: false
    - filterAttachmentDeviceIndex:
        default: ${get("filter_attachment_device_index", "")}
        private: true
        required: false
    - filter_attachment_instance_id:
        required: false
    - filterAttachmentInstanceId:
        default: ${get("filter_attachment_instance_id", "")}
        private: true
        required: false
    - filter_attachment_instance_owner_id:
        required: false
    - filterAttachmentInstanceOwnerId:
        default: ${get("filter_attachment_instance_owner_id", "")}
        private: true
        required: false
    - filter_attachment_nat_gateway_id:
        required: false
    - filterAttachmentNatGatewayId:
        default: ${get("filter_attachment_nat_gateway_id", "")}
        private: true
        required: false
    - filter_attachment_status:
        required: false
    - filterAttachmentStatus:
        default: ${get("filter_attachment_status", "")}
        private: true
        required: false
    - filter_availability_zone:
        required: false
    - filterAvailabilityZone:
        default: ${get("filter_availability_zone", "")}
        private: true
        required: false
    - filter_description:
        required: false
    - filterDescription:
        default: ${get("filter_description", "")}
        private: true
        required: false
    - filter_group_id:
        required: false
    - filterGroupId:
        default: ${get("filter_group_id", "")}
        private: true
        required: false
    - filter_group_name:
        required: false
    - filterGroupName:
        default: ${get("filter_group_name", "")}
        private: true
        required: false
    - filter_ipv6_addresses_ipv6_address:
        required: false
    - filterIpv6AddressesIpv6Address:
        default: ${get("filter_ipv6_addresses_ipv6_address", "")}
        private: true
        required: false
    - filter_mac_address:
        required: false
    - filterMacAddress:
        default: ${get("filter_mac_address", "")}
        private: true
        required: false
    - filter_network_interface_id:
        required: false
    - filterNetworkInterfaceId:
        default: ${get("filter_network_interface_id", "")}
        private: true
        required: false
    - filter_owner_id:
        required: false
    - filterOwnerId:
        default: ${get("filter_owner_id", "")}
        private: true
        required: false
    - filter_private_ip_address:
        required: false
    - filterPrivateIpAddress:
        default: ${get("filter_private_ip_address", "")}
        private: true
        required: false
    - filter_private_dns_name:
        required: false
    - filterPrivateDnsName:
        default: ${get("filter_private_dns_name", "")}
        private: true
        required: false
    - filter_requester_id:
        required: false
    - filterRequesterId:
        default: ${get("filter_requester_id", "")}
        private: true
        required: false
    - filter_requester_managed:
        required: false
    - filterRequesterManaged:
        default: ${get("filter_requester_managed", "")}
        private: true
        required: false
    - filter_source_desk_check:
        required: false
    - filterSourceDeskCheck:
        default: ${get("filter_source_desk_check", "")}
        private: true
        required: false
    - filter_status:
        required: false
    - filterStatus:
        default: ${get("filter_status", "")}
        private: true
        required: false
    - filter_subnet_id:
        required: false
    - filterSubnetId:
        default: ${get("filter_subnet_id", "")}
        private: true
        required: false
    - filter_tag:
        required: false
    - filterTag:
        default: ${get("filter_tag", "")}
        private: true
        required: false
    - filter_tag_key:
        required: false
    - filterTagKey:
        default: ${get("filter_tag_key", "")}
        private: true
        required: false
    - filter_tag_value:
        required: false
    - filterTagValue:
        default: ${get("filter_tag_value", "")}
        private: true
        required: false
    - filter_vpc_id:
        required: false
    - filterVpcId:
        default: ${get("filter_vpc_id", "")}
        private: true
        required: false
    - network_interface_id:
        required: false
    - networkInterfaceId:
        default: ${get("network_interface_id", "")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.9'
    class_name: io.cloudslang.content.amazon.actions.network.DescribeNetworkInterfacesAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE