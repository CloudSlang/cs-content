#   (c) Copyright 2021 Micro Focus, L.P.
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
#! @description: This flow launches one new instance. EBS volumes may be configured, created and attached to the instance.
#!               Existent network interfaces can be attached or, if desired, one or more new network interfaces can be
#!               created and attached to the instance. If you want these resources to be deleted when the instance is
#!               terminated, set the delete_on_terminations_string and network_interface_delete_on_termination inputs
#!               properly. After the instance is created and running, a tag is added to the instance. In case there is
#!               something wrong during the execution of run instance, the resources created will be deleted.
#!
#! @input provider_sap: The AWS endpoint as described here: https://docs.aws.amazon.com/general/latest/gr/rande.html
#!                      Default: 'https://ec2.amazonaws.com'
#! @input access_key_id: The ID of the secret access key associated with your Amazon AWS account.
#! @input access_key: The secret access key associated with your Amazon AWS account.
#! @input region: The region where to deploy the instance. To select a specific region, you either mention the endpoint
#!                corresponding to that region or provide a value to region input. In case both serviceEndpoint and
#!                region are specified, the serviceEndpoint will be used and region will be ignored.
#!                Examples: us-east-1, us-east-2, us-west-1, us-west-2, ca-central-1, eu-west-1, eu-central-1,
#!                eu-west-2, ap-northeast-1, ap-northeast-2, ap-southeast-1, ap-southeast-2, ap-south-1, sa-east-1
#! @input image_id: The ID of the AMI, which you can get by calling <DescribeImages>.For more information go to:
#!                  http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ComponentsAMIs.html
#!                  Example: "ami-abcdef12"
#! @input subnet_id: String that contains one or more subnet IDs. If you launch into EC2 Classic then supply values for
#!                   this input and don't supply values for Private IP Addresses string. [EC2-VPC] The ID of the subnet
#!                   to launch the instance into.
#! @input instance_name_prefix: The name prefix of the instance.
#! @input availability_zone: Specifies the placement constraints for launching instance. Amazon automatically selects
#!                           an availability zone by default.
#!                           Optional
#! @input instance_type: Instance type. For more information, see Instance Types in the Amazon Elastic Compute Cloud
#!                       User Guide.
#!                       Valid values: t1.micro | t2.nano | t2.micro | t2.small | t2.medium | t2.large | m1.small |
#!                       m1.medium | m1.large | m1.xlarge | m3.medium | m3.large | m3.xlarge | m3.2xlarge |
#!                       m4.large | m4.xlarge | m4.2xlarge | m4.4xlarge | m4.10xlarge | m2.xlarge |
#!                       m2.2xlarge | m2.4xlarge | cr1.8xlarge | r3.large | r3.xlarge | r3.2xlarge |
#!                       r3.4xlarge | r3.8xlarge | x1.4xlarge | x1.8xlarge | x1.16xlarge | x1.32xlarge |
#!                       i2.xlarge | i2.2xlarge | i2.4xlarge | i2.8xlarge | hi1.4xlarge | hs1.8xlarge |
#!                       c1.medium | c1.xlarge | c3.large | c3.xlarge | c3.2xlarge | c3.4xlarge | c3.8xlarge |
#!                       c4.large | c4.xlarge | c4.2xlarge | c4.4xlarge | c4.8xlarge | cc1.4xlarge |
#!                       cc2.8xlarge | g2.2xlarge | g2.8xlarge | cg1.4xlarge | d2.xlarge | d2.2xlarge |
#!                       d2.4xlarge | d2.8xlarge
#!                       Default: 't2.micro'
#!                       Optional
#! @input volume_type:  Type of Volume
#!                      Valid Values: "gp2", "gb3" "io1", "io2", "st1", "sc1", or "standard".
#!                      Default: 'Standard'
#! @input volume_size: Volume size in GB.
#!                     Constraints: 1-16384 for General Purpose SSD ("gp2"), 4-16384 for Provisioned IOPS SSD ("io1"),
#!                     500-16384 for Throughput Optimized HDD ("st1"), 500-16384 for Cold HDD ("sc1"), and 1-1024 for
#!                     Magnetic ("standard") volumes. If you specify a snapshot, the volume size must be equal to or
#!                     larger than the snapshot size. If you are creating the volume from a snapshot and don't specify
#!                     a volume size, the default is the snapshot size.
#!                     Examples: "Not relevant,Not relevant,100"
#!                     Default: '10'
#! @input key_pair_name: The name of the key pair. You can create a key pair using <CreateKeyPair> or <ImportKeyPair>.
#!                       Important: If you do not specify a key pair, you can't connect to the instance unless you choose
#!                       an AMI that is configured to allow users another way to log in.
#!                       Default: ''
#!                       Optional
#! @input proxy_host: The proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: The proxy server port used to access the provider services.
#!                    Optional
#! @input proxy_username: The proxy server user name.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Default: '10'
#!                          Optional
#! @input polling_retries: The number of retries to check if the instance is stopped.
#!                         Default: '60'
#!                         Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#!
#! @output instance_id: The ID of the newly created instance.
#! @output availability_zone_out: The availability zone of the instance.
#! @output ip_address: The public IP address of the new instance.
#! @output private_ip_address_out: The private IP address that is assigned to the instance.
#! @output private_dns_name: The private hostname of the instance, only usable inside the Amazon EC2 network.
#! @output public_dns_name: The fully qualified public domain name of the instance.
#! @output os_type: The type of platform the deployed instance is.
#! @output instance_state: The current state of the instance.
#! @output mac_address: The MAC address of the newly created instance.
#! @output vpc_id: The ID of virtual private cloud in which instance is deployed.
#! @output volume_id_list: The list of volumes attached to the instance.
#! @output return_result: Contains the instance details in case of success, error message otherwise.
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The server (instance) was successfully deployed.
#! @result FAILURE: There was an error while trying to deploy the instance.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2

imports:
  xml: io.cloudslang.base.xml
  strings: io.cloudslang.base.strings
  tags: io.cloudslang.amazon.aws.ec2.tags
  network: io.cloudslang.amazon.aws.ec2.network
  instances: io.cloudslang.amazon.aws.ec2.instances
  utils: io.cloudslang.amazon.aws.ec2.utils
flow:
  name: aws_deploy_instance_v2
  inputs:
    - provider_sap:
        default: 'https://ec2.amazonaws.com'
    - access_key_id
    - access_key:
        sensitive: true
    - region
    - image_id
    - subnet_id:
        required: true
    - instance_name_prefix:
        required: true
    - availability_zone:
        required: true
    - instance_type:
        default: t2.micro
        required: true
    - volume_type:
        default: standard
        required: true
    - volume_size:
        default: '10'
        required: true
    - key_pair_name:
        required: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - polling_interval:
        default: '10'
        required: false
    - polling_retries:
        default: '60'
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - set_endpoint:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - region: '${region}'
        publish:
          - provider_sap: '${".".join(("https://ec2",region, "amazonaws.com"))}'
        navigate:
          - SUCCESS: run_instances
          - FAILURE: on_failure
    - describe_instances:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.instances.describe_instances:
            - endpoint: '${provider_sap}'
            - identity: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - availability_zone
            - instance_ids_string: '${instance_id}'
        publish:
          - instance_details: '${return_result}'
          - return_code
          - exception
        navigate:
          - SUCCESS: search_and_replace
          - FAILURE: on_failure
    - search_and_replace:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${instance_details}'
            - text_to_replace: xmlns
            - replace_with: xhtml
        publish:
          - replaced_string
        navigate:
          - SUCCESS: parse_os_type
          - FAILURE: on_failure
    - set_ip_address:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${replaced_string}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='ipAddress']"
            - query_type: value
        publish:
          - ip_address: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: is_ip_address_not_found
          - FAILURE: on_failure
    - check_instance_state_v2:
        worker_group:
          value: '${worker_group}'
          override: true
        loop:
          for: 'step in range(0, int(get("polling_retries", 50)))'
          do:
            instances.check_instance_state_v2:
              - provider_sap: '${provider_sap}'
              - access_key_id: '${access_key_id}'
              - access_key:
                  value: '${access_key}'
                  sensitive: true
              - instance_id: '${instance_id}'
              - instance_state: running
              - proxy_host: '${proxy_host}'
              - proxy_port: '${proxy_port}'
              - proxy_username: '${proxy_username}'
              - proxy_password:
                  value: '${proxy_password}'
                  sensitive: true
              - polling_interval: '${polling_interval}'
              - worker_group: '${worker_group}'
          break:
            - SUCCESS
          publish:
            - return_result
            - return_code
            - exception
        navigate:
          - SUCCESS: generate_unique_name
          - FAILURE: terminate_instances
    - set_private_ip_address:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${replaced_string}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='privateIpAddress']"
            - query_type: value
        publish:
          - private_ip_address_out: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: set_private_dns_name
          - FAILURE: on_failure
    - set_public_dns_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${replaced_string}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='dnsName']"
            - query_type: value
        publish:
          - public_dns_name: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: is_public_dns_name_not_present
          - FAILURE: on_failure
    - set_instance_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${replaced_string}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='instanceState']/*[local-name()='name']"
            - query_type: value
        publish:
          - instance_state: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: set_vpc_id
          - FAILURE: on_failure
    - set_mac_address:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${replaced_string}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='networkInterfaceSet']/*[local-name()='item']/*[local-name()='macAddress']"
            - query_type: value
        publish:
          - mac_address: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: set_instance_state
          - FAILURE: on_failure
    - set_vpc_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${replaced_string}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='vpcId']"
            - query_type: value
        publish:
          - vpc_id: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - set_private_dns_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${replaced_string}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='privateDnsName']"
            - query_type: value
        publish:
          - private_dns_name: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: set_public_dns_name
          - FAILURE: on_failure
    - run_instances:
        worker_group: '${worker_group}'
        do:
          instances.run_instances:
            - endpoint: '${provider_sap}'
            - identity: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - delimiter: ','
            - image_id
            - availability_zone
            - instance_type
            - subnet_id
            - delete_on_terminations_string: '${true}'
            - volume_sizes_string: '${volume_size}'
            - volume_types_string: '${volume_type}'
            - key_pair_name
            - user_data
        publish:
          - return_result
          - return_code
          - exception
          - instance_id: '${instance_id_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: check_instance_state_v2
    - create_tags:
        worker_group: '${worker_group}'
        do:
          tags.create_tags:
            - endpoint: '${provider_sap}'
            - identity: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - resource_ids_string: '${instance_id}'
            - key_tags_string
            - value_tags_string
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - FAILURE: terminate_instances
          - SUCCESS: describe_instances
    - terminate_instances:
        worker_group: '${worker_group}'
        loop:
          for: 'step in range(0, int(get("polling_retries", 50)))'
          do:
            instances.terminate_instances:
              - endpoint: '${provider_sap}'
              - identity: '${access_key_id}'
              - credential:
                  value: '${access_key}'
                  sensitive: true
              - proxy_host
              - proxy_port
              - proxy_username
              - proxy_password
              - instance_ids_string: '${instance_id}'
          break:
            - SUCCESS
          publish:
            - return_result
            - return_code
            - exception
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
    - generate_unique_name:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          utils.get_unique_name:
            - instance_name_prefix
            - instance_tags_key: '${key_tags_string}'
            - instance_tags_value: '${value_tags_string}'
            - worker_group: '${worker_group}'
        publish:
          - key_tags_string
          - value_tags_string
        navigate:
          - FAILURE: terminate_instances
          - SUCCESS: is_instance_name_empty
    - is_instance_name_empty:
        worker_group: '${worker_group}'
        do:
          strings.string_equals:
            - first_string: '${key_tags_string}'
            - second_string: ''
        navigate:
          - FAILURE: create_tags
          - SUCCESS: describe_instances
    - parse_os_type:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${replaced_string}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='platform']"
            - query_type: value
        publish:
          - os_type: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: parse_availability_zone
          - FAILURE: on_failure
    - is_os_type_windows:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${os_type}'
            - second_string: windows
            - ignore_case: 'true'
        navigate:
          - SUCCESS: is_volume_size_null
          - FAILURE: set_os_type_linux
    - set_os_type_linux:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing: []
        publish:
          - os_type: Linux
        navigate:
          - SUCCESS: is_volume_size_null
          - FAILURE: on_failure
    - is_volume_size_null:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${volume_sizes_string}'
            - volume_id_list: '${volume_id_list}'
            - device_name_list: '${device_name_list}'
        publish:
          - volume_id_list: '${device_name_list+"::"+volume_id_list}'
        navigate:
          - IS_NULL: set_ip_address
          - IS_NOT_NULL: is_volume_size_0
    - is_volume_size_0:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${volume_sizes_string}'
            - second_string: '0'
        publish: []
        navigate:
          - SUCCESS: set_ip_address
          - FAILURE: iterate_volume_size
    - create_and_attach_single_volume:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.amazon.aws.ec2.volumes.create_and_attach_single_volume:
            - provider_sap: '${provider_sap}'
            - access_key_id: '${access_key_id}'
            - access_key:
                value: '${access_key}'
                sensitive: true
            - instance_id: '${instance_id}'
            - os_type: '${os_type}'
            - availability_zone: '${availability_zone_out}'
            - volume_size: '${volume_size}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - polling_interval: '${polling_interval}'
            - polling_retries: '${polling_retries}'
            - worker_group: '${worker_group}'
            - volume_type: '${volume_type}'
        publish:
          - return_result
          - return_code
          - exception
          - volume_id
          - device_name
        navigate:
          - SUCCESS: append_volume_id
          - FAILURE: terminate_instances
    - iterate_volume_size:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${volume_sizes_string}'
        publish:
          - volume_size: '${result_string}'
          - return_result
          - return_code
        navigate:
          - HAS_MORE: create_and_attach_single_volume
          - NO_MORE: set_ip_address
          - FAILURE: on_failure
    - parse_availability_zone:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${replaced_string}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='placement']/*[local-name()='availabilityZone']"
            - query_type: value
        publish:
          - availability_zone_out: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: parse_device_name
          - FAILURE: on_failure
    - append_volume_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - volume_id_list: '${volume_id_list}'
            - volume_id: '${volume_id}'
            - device_name: '${device_name}'
        publish:
          - volume_id_list: '${volume_id_list +", "+ device_name+"::"+volume_id}'
        navigate:
          - SUCCESS: iterate_volume_size
          - FAILURE: on_failure
    - parse_device_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${replaced_string}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='rootDeviceName']"
            - query_type: value
        publish:
          - device_name_list: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: parse_volume_id
          - FAILURE: on_failure
    - parse_volume_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${replaced_string}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='blockDeviceMapping']/*[local-name()='item']/*[local-name()='ebs']/*[local-name()='volumeId']"
            - query_type: value
        publish:
          - volume_id_list: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: is_os_type_windows
          - FAILURE: on_failure
    - is_ip_address_not_found:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${ip_address}'
            - second_string: No match found
            - ignore_case: 'true'
        navigate:
          - SUCCESS: set_ip_address_empty
          - FAILURE: set_private_ip_address
    - set_ip_address_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing: []
        publish:
          - ip_address: '-'
        navigate:
          - SUCCESS: set_private_ip_address
          - FAILURE: on_failure
    - is_public_dns_name_not_present:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${public_dns_name}'
            - second_string: No match found
            - ignore_case: 'true'
        navigate:
          - SUCCESS: set_public_dns_name_empty
          - FAILURE: set_mac_address
    - set_public_dns_name_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing: []
        publish:
          - public_dns_name: '-'
        navigate:
          - SUCCESS: set_mac_address
          - FAILURE: on_failure
  outputs:
    - instance_id
    - availability_zone_out
    - ip_address
    - private_ip_address_out
    - private_dns_name
    - public_dns_name
    - os_type
    - instance_state
    - mac_address
    - vpc_id
    - volume_id_list
    - return_result
    - return_code
    - exception
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      terminate_instances:
        x: 595
        'y': 550
        navigate:
          6936b8c3-e801-e173-78bf-0e2f2526f613:
            targetId: f31809d7-ee75-1d88-2683-192373df394e
            port: SUCCESS
      iterate_volume_size:
        x: 1400
        'y': 245
      create_and_attach_single_volume:
        x: 1058
        'y': 548
      is_volume_size_0:
        x: 1227
        'y': 244
      parse_availability_zone:
        x: 910
        'y': 405
      set_instance_state:
        x: 2378
        'y': 240
      is_os_type_windows:
        x: 1055
        'y': 43
      set_mac_address:
        x: 2374
        'y': 52
      set_ip_address_empty:
        x: 1543
        'y': 241
      parse_device_name:
        x: 908
        'y': 220
      is_ip_address_not_found:
        x: 1558
        'y': 52
      set_public_dns_name_empty:
        x: 2208
        'y': 246
      parse_os_type:
        x: 764
        'y': 407
      run_instances:
        x: 171
        'y': 221
      describe_instances:
        x: 755
        'y': 34
      set_os_type_linux:
        x: 1052
        'y': 227
      is_instance_name_empty:
        x: 583
        'y': 41
      set_vpc_id:
        x: 2381
        'y': 397
        navigate:
          577cce5c-12d7-40c5-d04b-15ed0b6e8120:
            targetId: 576dec96-8f7c-fa7a-5ec4-69f50e183dff
            port: SUCCESS
      generate_unique_name:
        x: 478
        'y': 228
      set_endpoint:
        x: 28
        'y': 222
      is_public_dns_name_not_present:
        x: 2206
        'y': 53
      parse_volume_id:
        x: 903
        'y': 28
      set_private_ip_address:
        x: 1729
        'y': 50
      search_and_replace:
        x: 761
        'y': 220
      is_volume_size_null:
        x: 1232
        'y': 43
      set_ip_address:
        x: 1399
        'y': 46
      set_private_dns_name:
        x: 1890
        'y': 50
      set_public_dns_name:
        x: 2044
        'y': 56
      append_volume_id:
        x: 1401
        'y': 544
      create_tags:
        x: 592
        'y': 231
      check_instance_state_v2:
        x: 325
        'y': 223
    results:
      SUCCESS:
        576dec96-8f7c-fa7a-5ec4-69f50e183dff:
          x: 2381
          'y': 558
      FAILURE:
        f31809d7-ee75-1d88-2683-192373df394e:
          x: 322
          'y': 552

