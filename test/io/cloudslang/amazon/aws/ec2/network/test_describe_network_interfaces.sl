#   (c) Copyright 2017 EntIT Software LLC, a Micro Focus company, L.P.
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
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.network

imports:
  network: io.cloudslang.amazon.aws.ec2.network
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings

flow:
  name: test_describe_network_interfaces

  inputs:
    - endpoint
    - identity
    - credential
    - proxy_host:
        default: ''
        required: false
    - proxy_port:
        default: ''
        required: false
    - proxy_username:
        default: ''
        required: false
    - proxy_password:
        default: ''
        required: false
    - headers:
        default: ''
        required: false
    - query_params:
        default: ''
        required: false
    - delimiter
    - version
    - filter_addresses_private_ip_address:
        required: false
    - filter_addresses_primary:
        required: false
    - filter_addresses_association_public_ip:
        required: false
    - filter_addresses_association_owner_id:
        required: false
    - filter_association_association_id:
        required: false
    - filter_association_allocation_id:
        required: false
    - filter_association_ip_owner_id:
        required: false
    - filter_association_public_ip:
        required: false
    - filter_association_public_dns_name:
        required: false
    - filter_attachment_attachment_id:
        required: false
    - filter_attachment_attach_time:
        required: false
    - filter_attachment_delete_on_termination:
        required: false
    - filter_attachment_device_index:
        required: false
    - filter_attachment_instance_id:
        required: false
    - filter_attachment_instance_owner_id:
        required: false
    - filter_attachment_nat_gateway_id:
        required: false
    - filter_attachment_status:
        required: false
    - filter_availability_zone:
        required: false
    - filter_description:
        required: false
    - filter_group_id:
        required: false
    - filter_group_name:
        required: false
    - filter_ipv6_addresses_ipv6_address:
        required: false
    - filter_mac_address:
        required: false
    - filter_network_interface_id:
        required: false
    - filter_owner_id:
        required: false
    - filter_private_ip_address:
        required: false
    - filter_private_dns_name:
        required: false
    - filter_requester_id:
        required: false
    - filter_requester_managed:
        required: false
    - filter_source_dest_check:
        required: false
    - filter_status:
        required: false
    - filter_subnet_id:
        required: false
    - filter_tag:
        required: false
    - filter_tag_key:
        required: false
    - filter_tag_value:
        required: false
    - filter_vpc_id:
        required: false
    - network_interface_id:
        required: false

  workflow:
    - describe_network_interfaces:
        do:
          network.describe_network_interfaces:
            - endpoint
            - identity
            - credential
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - headers
            - query_params
            - delimiter
            - version
            - filter_addresses_private_ip_address
            - filter_addresses_primary
            - filter_addresses_association_public_ip
            - filter_addresses_association_owner_id
            - filter_association_association_id
            - filter_association_allocation_id
            - filter_association_ip_owner_id
            - filter_association_public_ip
            - filter_association_public_dns_name
            - filter_attachment_attachment_id
            - filter_attachment_attach_time
            - filter_attachment_delete_on_termination
            - filter_attachment_device_index
            - filter_attachment_instance_id
            - filter_attachment_instance_owner_id
            - filter_attachment_nat_gateway_id
            - filter_attachment_status
            - filter_availability_zone
            - filter_description
            - filter_group_id
            - filter_group_name
            - filter_ipv6_addresses_ipv6_address
            - filter_mac_address
            - filter_network_interface_id
            - filter_owner_id
            - filter_private_ip_address
            - filter_private_dns_name
            - filter_requester_id
            - filter_requester_managed
            - filter_source_dest_check
            - filter_status
            - filter_subnet_id
            - filter_tag
            - filter_tag_key
            - filter_tag_value
            - filter_vpc_id
            - network_interface_id
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_result
          - FAILURE: DESCRIBE_NETWORK_INTERFACE_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${str(exception) + "," + return_code}
            - list_2: ",0"
        navigate:
          - SUCCESS: check_describe_network_interface_message_exist
          - FAILURE: CHECK_RESULT_FAILURE

    - check_describe_network_interface_message_exist:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${return_result}
            - string_to_find: 'DescribeNetworkInterfaces'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_DESCRIBE_NETWORK_INTERFACE_MESSAGE_FAILURE

  results:
    - SUCCESS
    - DESCRIBE_NETWORK_INTERFACE_FAILURE
    - CHECK_RESULT_FAILURE
    - CHECK_DESCRIBE_NETWORK_INTERFACE_MESSAGE_FAILURE