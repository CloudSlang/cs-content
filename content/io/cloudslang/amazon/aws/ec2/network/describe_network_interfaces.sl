#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: This operation can be used to retrieve information about one or more network interfaces, in XML format,
#!               that respect all the filter criterion.
#!
#! @input endpoint: Endpoint to which the request will be sent.
#!                  Default: 'https://ec2.amazonaws.com'
#!                  Optional
#! @input identity: ID of the secret access key associated with your Amazon AWS or IAM account.
#!                  Example: 'AKIAIOSFODNN7EXAMPLE'
#! @input credential: Secret access key associated with your Amazon AWS or IAM account.
#!                    Example: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
#! @input proxy_host: Proxy server used to connect to Amazon API. If empty no proxy will be used.
#!                    Default: ''
#!                    Optional
#! @input proxy_port: Proxy server port. You must either specify values for both <proxy_host> and <proxy_port>
#!                    inputs or leave them both empty.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Default: ''
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Default: ''
#!                        Optional
#! @input version: Version of the web service to make the call against it.
#!                 Example: '2016-11-15'
#!                 Default: '2016-11-15'
#!                 Optional
#! @input headers: String containing the headers to use for the request separated by new line (CRLF). The header
#!                 name-value pair will be separated by ':'.
#!                 Format: Conforming with HTTP standard for headers (RFC 2616).
#!                 Examples: Accept:text/plain
#!                 Default: ''
#!                 Optional
#! @input query_params: String containing query parameters that will be appended to the URL. The names and the
#!                      values must not be URL encoded because if they are encoded then a double encoded will occur. The
#!                      separator between name-value pairs is '&' symbol. The query name will be separated from query
#!                      value by '='.
#!                      Examples: 'parameterName1=parameterValue1&parameterName2=parameterValue2'
#!                      Default: ''
#!                      Optional
#! @input delimiter: Delimiter that will be used to separate parameters in all of the inputs.
#!                   Default: ','
#!                   Optional
#! @input filter_addresses_private_ip_address: The private IPv4 addresses associated with the network interface.
#!                                             Default: ''
#!                                             Optional
#! @input filter_addresses_primary: Whether the private IPv4 address is the primary IP address associated with the
#!                                  network interface.
#!                                  Default: ''
#!                                  Optional
#! @input filter_addresses_association_public_ip: The association ID returned when the network interface was associated
#!                                                with the Elastic IP address (IPv4).
#!                                                Default: ''
#!                                                Optional
#! @input filter_addresses_association_owner_id: The owner ID of the addresses associated with the network interface.
#!                                               Default: ''
#!                                               Optional
#! @input filter_association_association_id: The association ID returned when the network interface was associated with
#!                                           an IPv4 address.
#!                                           Default: ''
#!                                           Optional
#! @input filter_association_allocation_id: The allocation ID returned when you allocated the Elastic IP address (IPv4)
#!                                          for your network interface.
#!                                          Default: ''
#!                                          Optional
#! @input filter_association_ip_owner_id: The owner of the Elastic IP address (IPv4) associated with the network
#!                                        interface.
#!                                        Default: ''
#!                                        Optional
#! @input filter_association_public_ip: The address of the Elastic IP address (IPv4) bound to the network interface.
#!                                      Default: ''
#!                                      Optional
#! @input filter_association_public_dns_name: The public DNS name for the network interface (IPv4).
#!                                            Default: ''
#!                                            Optional
#! @input filter_attachment_attachment_id: The ID of the interface attachment.
#!                                         Optional
#! @input filter_attachment_attach_time: The time that the network interface was attached to an instance.
#!                                       Optional
#! @input filter_attachment_delete_on_termination: Indicates whether the attachment is deleted when an instance is
#!                                                 terminated.
#!                                                 Default: ''
#!                                                 Optional
#! @input filter_attachment_device_index: The device index to which the network interface is attached.
#!                                        Default: ''
#!                                        Optional
#! @input filter_attachment_instance_id: The ID of the instance to which the network interface is attached.
#!                                       Default: ''
#!                                       Optional
#! @input filter_attachment_instance_owner_id: The owner ID of the instance to which the network interface is attached.
#!                                             Default: ''
#!                                             Optional
#! @input filter_attachment_nat_gateway_id: The ID of the NAT gateway to which the network interface is attached.
#!                                          Default: ''
#!                                          Optional
#! @input filter_attachment_status: The status of the attachment.
#!                                  Valid values: attaching, attached, detaching, detached.
#!                                  Default: ''
#!                                  Optional
#! @input filter_availability_zone: The Availability Zone of the network interface.
#!                                  Default: ''
#!                                  Optional
#! @input filter_description: The description of the network interface.
#!                            Default: ''
#!                            Optional
#! @input filter_group_id: The ID of a security group associated with the network interface.
#!                         Default: ''
#!                         Optional
#! @input filter_group_name: The name of a security group associated with the network interface.
#!                           Default: ''
#!                           Optional
#! @input filter_ipv6_addresses_ipv6_address: An IPv6 address associated with the network interface.
#!                                            Default: ''
#!                                            Optional
#! @input filter_mac_address: The MAC address of the network interface.
#!                            Default: ''
#!                            Optional
#! @input filter_network_interface_id: The ID of the network interface.
#!                                     Default: ''
#!                                     Optional
#! @input filter_owner_id: The AWS account ID of the network interface owner.
#!                         Default: ''
#!                         Optional
#! @input filter_private_ip_address: The private IPv4 address or addresses of the network interface.
#!                                   Default: ''
#!                                   Optional
#! @input filter_private_dns_name: The private DNS name of the network interface (IPv4).
#!                                 Default: ''
#!                                 Optional
#! @input filter_requester_id: The ID of the entity that launched the instance on your behalf (for example, AWS
#!                             Management Console, Auto Scaling, and so on).
#!                             Default: ''
#!                             Optional
#! @input filter_requester_managed: Indicates whether the network interface is being managed by an AWS service
#!                                  (for example, AWS Management Console, Auto Scaling, and so on).
#!                                  Default: ''
#!                                  Optional
#! @input filter_source_dest_check: Indicates whether the network interface performs source/destination checking. A
#!                                  value of true means checking is enabled, and false means checking is disabled. The
#!                                  value must be false for the network interface to perform network address translation
#!                                  (NAT) in your VPC.
#!                                  Default: ''
#!                                  Optional
#! @input filter_status: The status of the network interface. If the network interface is not attached to an
#!                       instance, the status is available; if a network interface is attached to an instance the status
#!                       is in-use.
#!                       Valid values: in-use, available.
#!                       Default: ''
#!                       Optional
#! @input filter_subnet_id: The ID of the subnet for the network interface.
#!                          Optional
#! @input filter_tag: The key/value combination of a tag assigned to the resource. Specify the key of the tag
#!                    in the filter name and the value of the tag in the filter value.
#!                    Format: <FilterName1>=<FilterValue1>,<FilterName2>=<FilterValue2>
#!                    Example: Purpose1=X,Purpose2=B
#!                    Default: ''
#!                    Optional
#! @input filter_tag_key: The key of a tag assigned to the resource. This filter is independent of the
#!                        filter_tag_value filter. For example, if you use both filter_tag_key = 'Purpose' and
#!                        filter_tag_value = 'X', you get any resources assigned both the tag key 'Purpose' (regardless
#!                        of what the tag's value is), and the tag value 'X' (regardless of what the tag's key is).
#!                        If you want to list only resources where 'Purpose' is 'X', see the filter_tag.
#!                        Default: ''
#!                        Optional
#! @input filter_tag_value: The value of a tag assigned to the resource. This filter is independent of the
#!                          filter_tag_key.
#!                          Default: ''
#!                          Optional
#! @input filter_vpc_id: The ID of the VPC for the network interface.
#!                       Default: ''
#!                       Optional
#! @input network_interface_id: String that contains one or more network interface IDs.
#!                              Example: 'eni-12345678,eni-87654321'
#!                              Default: ''
#!                              Optional
#!
#! @output return_result: Outcome of the action in case of success, exception occurred otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output exception: Error message if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: The xml with existing network interfaces that match the criterias was successfully retrieved.
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
        default: ${get('proxy_host', '')}
        required: false
        private: true
    - proxy_port:
        default: '8080'
        required: false
    - proxyPort:
        default: ${get('proxy_port', '')}
        required: false
        private: true
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get('proxy_username', '')}
        required: false
        private: true
    - proxy_password:
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get('proxy_password', '')}
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
        default: ${get('query_params', '')}
        required: false
        private: true
    - delimiter:
        default: ','
        required: false
    - filter_addresses_private_ip_address:
        default: ''
        required: false
    - filterAddressesPrivateIpAddress:
        default: ${get('filter_addresses_private_ip_address', '')}
        required: false
        private: true
    - filter_addresses_primary:
        default: ''
        required: false
    - filterAddressesPrimary:
        default: ${get('filter_addresses_primary', '')}
        required: false
        private: true
    - filter_addresses_association_public_ip:
        default: ''
        required: false
    - filterAddressesAssociationPublicIp:
        default: ${get('filter_addresses_association_public_ip', '')}
        required: false
        private: true
    - filter_addresses_association_owner_id:
        default: ''
        required: false
    - filterAddressesAssociationOwnerId:
        default: ${get('filter_addresses_association_owner_id', '')}
        required: false
        private: true
    - filter_association_association_id:
        default: ''
        required: false
    - filterAssociationAssociationId:
        default: ${get('filter_association_association_id', '')}
        required: false
        private: true
    - filter_association_allocation_id:
        default: ''
        required: false
    - filterAssociationAllocationId:
        default: ${get('filter_association_allocation_id', '')}
        required: false
        private: true
    - filter_association_ip_owner_id:
        default: ''
        required: false
    - filterAssociationIpOwnerId:
        default: ${get('filter_association_ip_owner_id', '')}
        required: false
        private: true
    - filter_association_public_ip:
        default: ''
        required: false
    - filterAssociationPublicIp:
        default: ${get('filter_association_public_ip', '')}
        required: false
        private: true
    - filter_association_public_dns_name:
        default: ''
        required: false
    - filterAssociationPublicDnsName:
        default: ${get('filter_association_public_dns_name', '')}
        required: false
        private: true
    - filter_attachment_attachment_id:
        default: ''
        required: false
    - filterAttachmentAttachmentId:
        default: ${get('filter_attachment_attachment_id', '')}
        required: false
        private: true
    - filter_attachment_attach_time:
        default: ''
        required: false
    - filterAttachmentAttachTime:
        default: ${get('filter_attachment_attach_time', '')}
        required: false
        private: true
    - filter_attachment_delete_on_termination:
        default: ''
        required: false
    - filterAttachmentDeleteOnTermination:
        default: ${get('filter_attachment_delete_on_termination', '')}
        required: false
        private: true
    - filter_attachment_device_index:
        default: ''
        required: false
    - filterAttachmentDeviceIndex:
        default: ${get('filter_attachment_device_index', '')}
        required: false
        private: true
    - filter_attachment_instance_id:
        default: ''
        required: false
    - filterAttachmentInstanceId:
        default: ${get('filter_attachment_instance_id', '')}
        required: false
        private: true
    - filter_attachment_instance_owner_id:
        default: ''
        required: false
    - filterAttachmentInstanceOwnerId:
        default: ${get('filter_attachment_instance_owner_id', '')}
        required: false
        private: true
    - filter_attachment_nat_gateway_id:
        default: ''
        required: false
    - filterAttachmentNatGatewayId:
        default: ${get('filter_attachment_nat_gateway_id', '')}
        required: false
        private: true
    - filter_attachment_status:
        default: ''
        required: false
    - filterAttachmentStatus:
        default: ${get('filter_attachment_status', '')}
        required: false
        private: true
    - filter_availability_zone:
        default: ''
        required: false
    - filterAvailabilityZone:
        default: ${get('filter_availability_zone', '')}
        required: false
        private: true
    - filter_description:
        default: ''
        required: false
    - filterDescription:
        default: ${get('filter_description', '')}
        required: false
        private: true
    - filter_group_id:
        default: ''
        required: false
    - filterGroupId:
        default: ${get('filter_group_id', '')}
        required: false
        private: true
    - filter_group_name:
        default: ''
        required: false
    - filterGroupName:
        default: ${get('filter_group_name', '')}
        required: false
        private: true
    - filter_ipv6_addresses_ipv6_address:
        default: ''
        required: false
    - filterIpv6AddressesIpv6Address:
        default: ${get('filter_ipv6_addresses_ipv6_address', '')}
        required: false
        private: true
    - filter_mac_address:
        default: ''
        required: false
    - filterMacAddress:
        default: ${get('filter_mac_address', '')}
        required: false
        private: true
    - filter_network_interface_id:
        default: ''
        required: false
    - filterNetworkInterfaceId:
        default: ${get('filter_network_interface_id', '')}
        required: false
        private: true
    - filter_owner_id:
        default: ''
        required: false
    - filterOwnerId:
        default: ${get('filter_owner_id', '')}
        required: false
        private: true
    - filter_private_ip_address:
        default: ''
        required: false
    - filterPrivateIpAddress:
        default: ${get('filter_private_ip_address', '')}
        required: false
        private: true
    - filter_private_dns_name:
        default: ''
        required: false
    - filterPrivateDnsName:
        default: ${get('filter_private_dns_name', '')}
        required: false
        private: true
    - filter_requester_id:
        default: ''
        required: false
    - filterRequesterId:
        default: ${get('filter_requester_id', '')}
        required: false
        private: true
    - filter_requester_managed:
        default: ''
        required: false
    - filterRequesterManaged:
        default: ${get('filter_requester_managed', '')}
        required: false
        private: true
    - filter_source_dest_check:
        default: ''
        required: false
    - filterSourceDestCheck:
        default: ${get('filter_source_dest_check', '')}
        required: false
        private: true
    - filter_status:
        default: ''
        required: false
    - filterStatus:
        default: ${get('filter_status', '')}
        required: false
        private: true
    - filter_subnet_id:
        default: ''
        required: false
    - filterSubnetId:
        default: ${get('filter_subnet_id', '')}
        required: false
        private: true
    - filter_tag:
        default: ''
        required: false
    - filterTag:
        default: ${get('filter_tag', '')}
        required: false
        private: true
    - filter_tag_key:
        default: ''
        required: false
    - filterTagKey:
        default: ${get('filter_tag_key', '')}
        required: false
        private: true
    - filter_tag_value:
        default: ''
        required: false
    - filterTagValue:
        default: ${get('filter_tag_value', '')}
        required: false
        private: true
    - filter_vpc_id:
        default: ''
        required: false
    - filterVpcId:
        default: ${get('filter_vpc_id', '')}
        required: false
        private: true
    - network_interface_id:
        default: ''
        required: false
    - networkInterfaceId:
        default: ${get('network_interface_id', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.18'
    class_name: io.cloudslang.content.amazon.actions.network.DescribeNetworkInterfacesAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE