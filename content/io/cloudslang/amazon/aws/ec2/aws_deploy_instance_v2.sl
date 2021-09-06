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
#!                   Default: ''
#! @input availability_zone: Specifies the placement constraints for launching instance. Amazon automatically selects
#!                           an availability zone by default.
#!                           Optional
#! @input instance_type: Instance type. For more information, see Instance Types in the Amazon Elastic Compute Cloud
#!                       User Guide.
#!                       Valid values: t1.micro | t2.nano | t2.micro | t2.small | t2.medium | t2.large | m1.small |
#!                                    m1.medium | m1.large | m1.xlarge | m3.medium | m3.large | m3.xlarge | m3.2xlarge |
#!                                    m4.large | m4.xlarge | m4.2xlarge | m4.4xlarge | m4.10xlarge | m2.xlarge |
#!                                    m2.2xlarge | m2.4xlarge | cr1.8xlarge | r3.large | r3.xlarge | r3.2xlarge |
#!                                    r3.4xlarge | r3.8xlarge | x1.4xlarge | x1.8xlarge | x1.16xlarge | x1.32xlarge |
#!                                    i2.xlarge | i2.2xlarge | i2.4xlarge | i2.8xlarge | hi1.4xlarge | hs1.8xlarge |
#!                                    c1.medium | c1.xlarge | c3.large | c3.xlarge | c3.2xlarge | c3.4xlarge | c3.8xlarge |
#!                                    c4.large | c4.xlarge | c4.2xlarge | c4.4xlarge | c4.8xlarge | cc1.4xlarge |
#!                                    cc2.8xlarge | g2.2xlarge | g2.8xlarge | cg1.4xlarge | d2.xlarge | d2.2xlarge |
#!                                    d2.4xlarge | d2.8xlarge
#!                        Default: 't2.micro'
#!                        Optional
#! @input volume_sizes_string: String that contains one or more values of the sizes (in GiB) for EBS devices.
#!                             Constraints: 1-16384 for General Purpose SSD ("gp2"), 4-16384 for Provisioned IOPS SSD ("io1"),
#!                             500-16384 for Throughput Optimized HDD ("st1"), 500-16384 for Cold HDD ("sc1"), and 1-1024 for
#!                             Magnetic ("standard") volumes. If you specify a snapshot, the volume size must be equal to or
#!                             larger than the snapshot size. If you are creating the volume from a snapshot and don't specify
#!                             a volume size, the default is the snapshot size.
#!                             Examples: "Not relevant,Not relevant,100"
#!                             Default: ''
#!                             Optional
#! @input instance_name_prefix: The name prefix of the instance.
#!                              Default: ''
#!                              Optional
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
#! @input headers: String containing the headers to use for the request separated by new line (CRLF). The header
#!                 name-value pair will be separated by ":".
#!                 Format: Conforming with HTTP standard for headers (RFC 2616).
#!                 Examples: 'Accept:text/plain'
#!                 Optional
#! @input query_params: String containing query parameters regarding the instance. These parameters will be
#!                      appended to the URL, but the names and the values must not be URL encoded because if
#!                      they are encoded then a double encoded will occur. The separator between name-value
#!                      pairs is "&" symbol. The query name will be separated from query value by "=".
#!                      Examples: "parameterName1=parameterValue1&parameterName2=parameterValue2"
#!                      Optional
#! @input host_id: ID of the dedicated host on which the instance resides (as part of Placement). This parameter is not
#!                 supported for the <ImportInstance> command.
#!                 Optional
#! @input kernel_id: ID of the kernel. Important: We recommend that you use PV-GRUB instead of kernels and RAM disks.
#!                   For more information, see PV-GRUB in the Amazon Elastic Compute Cloud User Guide.
#!                   Default: ''
#!                   Optional
#! @input ramdisk_id: ID of the RAM disk. Important: We recommend that you use PV-GRUB instead of kernels and RAM disks.
#!                    For more information, see PV-GRUB in the Amazon Elastic Compute Cloud User Guide.
#!                    Default: ''
#!                    Optional
#! @input block_device_mapping_device_names_string: String that contains one or more device names, exposed to the instance,
#!                                                  separated by ','. If you want to suppress the specified device included
#!                                                  in the block device mapping of the AMI then supply "NoDevice" in string.
#!                                                  Examples: "/dev/sdc,/dev/sdd", "/dev/sdh", "xvdh" or "NoDevice".
#!                                                  Default: ''
#!                                                  Optional
#! @input block_device_mapping_virtual_names_string: String that contains one or more virtual names separated by ','.
#!                                                   Virtual device name is "ephemeralN". Instance store volumes are numbered
#!                                                   starting from 0. An instance type with 2 available instance store volumes
#!                                                   can specify mappings for ephemeral0 and ephemeral1. The number of available
#!                                                   instance store volumes depends on the instance type. After you connect to
#!                                                   the instance, you must mount the volume.
#!                                                   Constraints: For M3 instances, you must specify instance store volumes
#!                                                   in the block device mapping for the instance. When you launch an M3 instance,
#!                                                   we ignore any instance store volumes specified in the block device mapping
#!                                                   for the AMI.
#!                                                   Example: 'ephemeral0,ephemeral1,Not relevant'
#!                                                   Default: ''
#!                                                   Optional
#! @input delete_on_terminations_string: String that contains one or more values that indicates whether a specific EBS
#!                                       volume will be deleted on instance termination. 
#!                                       Example: For a second EBS device (from existing 4 devices), that should be deleted,
#!                                       the string will be: "false,true,false,false". 
#!                                       Valid values: 'true', 'false'. 
#!                                       Default: ''
#!                                       Optional
#! @input ebs_optimized: Indicates whether the instance is optimized for EBS I/O.This optimization provides dedicated
#!                       throughput to Amazon EBS and an optimized configuration stack to provide optimal EBS I/O performance.
#!                       This optimization isn't available with all instance types. Additional usage charges apply when
#!                       using an EBS-optimized instance.
#!                       Valid values: 'true', 'false'.
#!                       Default: 'false'
#!                       Optional
#! @input encrypted_string: String that contains one or more values that indicates whether a specific EBS volume will be
#!                          encrypted. Encrypted Amazon EBS volumes may only be attached to instances that support Amazon
#!                          EBS encryption.
#!                          Example: For a second EBS device (from existing 4 devices), that should be encrypted, the
#!                          string will be: "0,1,0,0". If no value is provided, the default value of not encrypted will
#!                          be considered for all EBS specified devices.
#!                          Default: ''
#!                          Optional
#! @input iops_string: String that contains one or more values that specifies the number of I/O operations per second (IOPS)
#!                     that the volume supports. For "io1", this represents the number of IOPS that are provisioned for the
#!                     volume. For "gp2", this represents the baseline performance of the volume and the rate at which the
#!                     volume accumulates I/O credits for bursting. For more information about General Purpose SSD baseline
#!                     performance, I/O credits, and bursting, see Amazon EBS Volume Types in the Amazon Elastic Compute Cloud
#!                     User Guide. Constraint: Range is 100-20000 IOPS for "io1" volumes and 100-10000 IOPS for "gp2" volumes.
#!                     Condition: This parameter is required for requests to create "io1" volumes; it is not used
#!                     in requests to create "gp2", "st1", "sc1", or "standard" volumes.
#!                     Example: For a first EBS device  (from existing 3 devices), with type "io1" that should have 5000
#!                     IOPS as value the string will be: "5000,,". If no value provided then the default value for every
#!                     single EBS device will be used.
#!                     Default: ''
#!                     Optional
#! @input snapshot_ids_string: String that contains one or more values of the snapshot IDs to be used when creating the
#!                             EBS device.
#!                             Example: For a last EBS device (from existing 3 devices), to be created using a snapshot
#!                             as image the string will be: "Not relevant,Not relevant,snap-abcdef12". If no value provided
#!                             then no snapshot will be used when creating EBS device.
#!                             Default: ''
#!                             Optional
#! @input volume_types_string: String that contains one or more values that specifies the volume types: "gp2", "io1",
#!                             "st1", "sc1", or "standard". If no value provided then the default value of "standard"
#!                             for every single EBS device type will be considered.
#!                             Default: ''
#!                             Optional
#! @input private_ip_address: [EC2-VPC] The primary IP address. You must specify a value from the IP address range of
#!                            the subnet. Only one private IP address can be designated as primary. Therefore, you can't
#!                            specify this parameter if <PrivateIpAddresses.n.Primary> is set to "true" and
#!                            <PrivateIpAddresses.n.PrivateIpAddress> is set to an IP address.
#!                            Default: We select an IP address from the IP address range of the subnet.
#!                            Optional
#! @input private_ip_addresses_string: String that contains one or more private IP addresses to assign to the network
#!                                     interface. Only one private IP address can be designated as primary. Use this if
#!                                     you want to launch instances with many NICs attached.
#!                                     Default: ''
#!                                     Optional
#! @input iam_instance_profile_arn: Amazon Resource Name (IAM_INSTANCE_PROFILE_ARN) of the instance profile.
#!                                  Example: "arn:aws:iam::123456789012:user/some_user".
#!                                  Default: ''
#!                                  Optional
#! @input iam_instance_profile_name: Name of the instance profile.
#!                                   Default: ''
#!                                   Optional
#! @input security_group_ids_string: IDs of the security groups for the network interface. Applies only if creating a
#!                                   network interface when launching an instance.
#!                                   Default: ''
#!                                   Optional
#! @input affinity: Affinity setting for the instance on the Dedicated Host(as part of Placement). This parameter is not
#!                  supported for the <ImportInstance> command.
#!                  Default: ''
#!                  Optional
#! @input client_token: Unique, case-sensitive identifier you provide to ensure the idem-potency of the request. For more
#!                      information, see Ensuring Idempotency.
#!                      Constraints: Maximum 64 ASCII characters.
#!                      Default: ''
#!                      Optional
#! @input disable_api_termination: If you set this parameter to "true", you can"t terminate the instance using the Amazon
#!                                 EC2 console, CLI, or API; otherwise, you can. If you set this parameter to "true" and
#!                                 then later want to be able to terminate the instance, you must first change the value
#!                                 of the <disableApiTermination> attribute to "false" using <ModifyInstanceAttribute>.
#!                                 Alternatively, if you set <InstanceInitiatedShutdownBehavior> to "terminate", you can
#!                                 terminate the instance by running the shutdown command from the instance.
#!                                 Valid values: 'true', 'false'.
#!                                 Default: 'false'
#!                                 Optional
#! @input instance_initiated_shutdown_behavior: Indicates whether an instance stops or terminates when you initiate shutdown
#!                                              from the instance (using the operating system command for system shutdown).
#!                                              Valid values: 'stop', 'terminate'.
#!                                              Default: 'stop'
#!                                              Optional
#! @input monitoring: Whether to enable or not monitoring for the instance.
#!                    Default: 'false'
#!                    Optional
#! @input placement_group_name: Name of the placement group for the instance (as part of Placement).
#!                              Default: ''
#!                              Optional
#! @input tenancy: Tenancy of an instance (if the instance is running in a VPC - as part of Placement). An instance with
#!                 a tenancy of dedicated runs on single-tenant hardware. The host tenancy is not supported for the
#!                 ImportInstance command.
#!                 Valid values: 'dedicated', 'default', 'host'.
#!                 Optional
#! @input user_data: The user data to make available to the instance. For more information, see Running Commands on Your
#!                   Linux Instance at Launch (Linux) and Adding User Data (Windows). If you are using an AWS SDK or
#!                   command line tool, Base64-encoding is performed for you, and you can load the text from a file.
#!                   Otherwise, you must provide Base64-encoded text.
#!                   Default: ''
#!                   Optional
#! @input network_interface_associate_public_ip_address: String that contains one or more values that indicates whether
#!                                                       to assign a public IP address or not when you launch in a VPC.
#!                                                       The public IP address can only be assigned to a network interface
#!                                                       for eth0, and can only be assigned to a new network interface,
#!                                                       not an existing one. You cannot specify more than one network
#!                                                       interface in the request. If launching into a default subnet,
#!                                                       the default value is 'true'.
#!                                                       Valid values: 'true', 'false'.
#!                                                       Default: ''
#!                                                       Optional
#! @input network_interface_delete_on_termination: String that contains one or more values that indicates that the interface
#!                                                 is deleted when the instance is terminated. You can specify true only
#!                                                 if creating a new network interface when launching an instance.
#!                                                 Valid values: 'true', 'false'.
#!                                                 Default: ''
#!                                                 Optional
#! @input network_interface_description: String that contains one or more values that describe the network interfaces.
#!                                       Applies only if creating a network interfaces when launching an instance.
#!                                       Default: ''
#!                                       Optional
#! @input network_interface_device_index: String that contains one or more values that are indexes of the device on the
#!                                        instance for the network interface attachment. If you are specifying a network
#!                                        interface in a RunInstances request, you should provide the device index.
#!                                        If not provided, then we supply the automatic index starting from 0.
#!                                        Default: ''
#!                                        Optional
#! @input network_interface_id: String that contains one or more values that are IDs of the network interfaces.
#!                              Default: ''
#!                              Optional
#! @input secondary_private_ip_address_count: The number of secondary private IP addresses. You can't specify this option
#!                                            and specify more than one private IP address using the private IP addresses
#!                                            option. Minimum valid number is 2.
#!                                            Default: ''
#!                                            Optional
#! @input key_tags_string: String that contains one or more key tags separated by delimiter. Constraints: Tag keys are
#!                         case-sensitive and accept a maximum of 127 Unicode characters. May not begin with "aws:";
#!                         Each resource can have a maximum of 50 tags. Note: if you want to overwrite the existing tag
#!                         and replace it with empty value then specify the parameter with "Not relevant" string.
#!                         Example: 'Name,webserver,stack,scope'
#!                         Default: ''
#!                         Optional
#! @input value_tags_string: String that contains one or more tag values separated by delimiter. The value parameter is
#!                           required, but if you don't want the tag to have a value, specify the parameter with
#!                           "Not relevant" string, and we set the value to an empty string. Constraints: Tag values are
#!                           case-sensitive and accept a maximum of 255 Unicode characters; Each resource can have a
#!                           maximum of 50 tags.
#!                           Example of values string for tagging resources with values corresponding to the keys from
#!                           above example: "Tagged from API call,Not relevant,Testing,For testing purposes"
#!                           Default: ''
#!                           Optional
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Default: '10'
#!                          Optional
#! @input polling_retries: The number of retries to check if the instance is stopped.
#!                         Default: '50'
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
  volumes: io.cloudslang.amazon.aws.ec2.volumes
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
    - availability_zone:
        required: false
    - instance_type:
        default: t2.micro
        required: false
    - volume_sizes_string:
        required: false
    - instance_name_prefix:
        required: false
    - key_pair_name:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - headers:
        required: false
    - query_params:
        required: false
    - host_id:
        required: false
    - kernel_id:
        required: false
    - ramdisk_id:
        required: false
    - block_device_mapping_device_names_string:
        required: false
    - block_device_mapping_virtual_names_string:
        required: false
    - delete_on_terminations_string:
        required: false
    - ebs_optimized:
        default: 'false'
        required: false
    - encrypted_string:
        required: false
    - iops_string:
        required: false
    - snapshot_ids_string:
        required: false
    - volume_types_string:
        required: false
    - private_ip_address:
        required: false
    - private_ip_addresses_string:
        required: false
    - iam_instance_profile_arn:
        required: false
    - iam_instance_profile_name:
        required: false
    - security_group_ids_string:
        required: false
    - affinity:
        required: false
    - client_token:
        required: false
    - disable_api_termination:
        required: false
    - instance_initiated_shutdown_behavior:
        default: stop
        required: false
    - monitoring:
        default: 'false'
        required: false
    - placement_group_name:
        required: false
    - tenancy:
        required: false
    - user_data:
        required: false
    - network_interface_associate_public_ip_address:
        required: false
    - network_interface_delete_on_termination:
        required: false
    - network_interface_description:
        required: false
    - network_interface_device_index:
        required: false
    - network_interface_id:
        required: false
    - secondary_private_ip_address_count:
        required: false
    - key_tags_string:
        required: false
    - value_tags_string:
        required: false
    - polling_interval:
        default: '10'
        required: false
    - polling_retries:
        default: '50'
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false

  workflow:
    - set_endpoint:
        worker_group: '${worker_group}'
        do:
          utils.do_nothing:
            - region: '${region}'
        publish:
          - provider_sap: '${".".join(("https://ec2",region, "amazonaws.com"))}'
        navigate:
          - SUCCESS: run_instances
          - FAILURE: on_failure

    - describe_instances:
        worker_group: '${worker_group}'
        do:
          instances.describe_instances:
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
          strings.search_and_replace:
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
          xml.xpath_query:
            - xml_document: '${replaced_string}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='ipAddress']"
            - query_type: value
        publish:
          - ip_address: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: set_private_ip_address
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
          xml.xpath_query:
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
          xml.xpath_query:
            - xml_document: '${replaced_string}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='dnsName']"
            - query_type: value
        publish:
          - public_dns_name: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: set_mac_address
          - FAILURE: on_failure

    - set_instance_state:
        worker_group: '${worker_group}'
        do:
          xml.xpath_query:
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
          xml.xpath_query:
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
          xml.xpath_query:
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
          - FAILURE:

    - set_private_dns_name:
        worker_group: '${worker_group}'
        do:
          xml.xpath_query:
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
            - headers
            - query_params
            - delimiter: ','
            - image_id
            - availability_zone
            - host_id
            - instance_type
            - kernel_id
            - ramdisk_id
            - subnet_id
            - block_device_mapping_device_names_string
            - block_device_mapping_virtual_names_string
            - delete_on_terminations_string
            - ebs_optimized
            - encrypted_string
            - iops_string
            - snapshot_ids_string
            - volume_sizes_string
            - volume_types_string
            - iam_instance_profile_arn
            - private_ip_address
            - private_ip_addresses_string
            - iam_instance_profile_name
            - key_pair_name
            - security_group_ids_string
            - affinity
            - client_token
            - disable_api_termination
            - instance_initiated_shutdown_behavior
            - monitoring
            - placement_group_name
            - tenancy
            - user_data
            - network_interface_associate_public_ip_address
            - network_interface_delete_on_termination
            - network_interface_description
            - network_interface_device_index
            - network_interface_id
            - secondary_private_ip_address_count
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
            - headers
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
              - headers
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
          xml.xpath_query:
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
          strings.string_equals:
            - first_string: '${os_type}'
            - second_string: windows
            - ignore_case: 'true'
        navigate:
          - SUCCESS: is_volume_size_null
          - FAILURE: set_os_type_linux

    - set_os_type_linux:
        worker_group: '${worker_group}'
        do:
          utils.do_nothing: []
        publish:
          - os_type: Linux
        navigate:
          - SUCCESS: is_volume_size_null
          - FAILURE: on_failure

    - is_volume_size_null:
        worker_group: '${worker_group}'
        do:
          utils.is_null:
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
          strings.string_equals:
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
          volumes.create_and_attach_single_volume:
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
            - iops: '${iops_string}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - polling_interval: '${polling_interval}'
            - polling_retries: '${polling_retries}'
            - worker_group: '${worker_group}'
            - snapshot_id: '${snapshot_ids_string}'
            - volume_type: '${volume_types_string}'
            - encrypted: '${encrypted_string}'
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
          xml.xpath_query:
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
          utils.do_nothing:
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
          xml.xpath_query:
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
          xml.xpath_query:
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
    - return_result
    - return_code
    - exception
    - volume_id_list

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
        x: 2017
        'y': 237
      is_os_type_windows:
        x: 1055
        'y': 43
      set_mac_address:
        x: 2017
        'y': 54
      parse_device_name:
        x: 908
        'y': 220
      parse_os_type:
        x: 764
        'y': 407
      run_instances:
        x: 172
        'y': 222
      describe_instances:
        x: 756
        'y': 34
      set_os_type_linux:
        x: 1052
        'y': 227
      is_instance_name_empty:
        x: 583
        'y': 41
      set_vpc_id:
        x: 2019
        'y': 401
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
      parse_volume_id:
        x: 903
        'y': 28
      set_private_ip_address:
        x: 1551
        'y': 48
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
        x: 1709
        'y': 51
      set_public_dns_name:
        x: 1859
        'y': 51
      append_volume_id:
        x: 1401
        'y': 544
      create_tags:
        x: 592
        'y': 231
      check_instance_state_v2:
        x: 324
        'y': 223
    results:
      SUCCESS:
        576dec96-8f7c-fa7a-5ec4-69f50e183dff:
          x: 2016
          'y': 579
      FAILURE:
        f31809d7-ee75-1d88-2683-192373df394e:
          x: 322
          'y': 552
