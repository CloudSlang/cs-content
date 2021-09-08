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
#! @description: This flow launches one new instance. EBS volumes may be configured, created and attached to the instance.
#!               Existent network interfaces can be attached or, if desired, one or more new network interfaces can be
#!               created and attached to the instance. If you want these resources to be deleted when the instance is
#!               terminated, set the delete_on_terminations_string and network_interface_delete_on_termination inputs
#!               properly. After the instance is created and running, a tag is added to the instance. In case there is
#!               something wrong during the execution of run instance, the resources created will be deleted.
#!
#! @input endpoint: AWS endpoint as described here: https://docs.aws.amazon.com/general/latest/gr/rande.html
#!                  Default: 'https://ec2.amazonaws.com'
#! @input identity: ID of the secret access key associated with your Amazon AWS account.
#! @input credential: Secret access key associated with your Amazon AWS account.
#! @input proxy_host: Proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
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
#! @input availability_zone: Specifies the placement constraints for launching instance. Amazon automatically selects
#!                           an availability zone by default.
#!                           Optional
#! @input host_id: ID of the dedicated host on which the instance resides (as part of Placement). This parameter is not
#!                 supported for the <ImportInstance> command.
#!                 Optional
#! @input image_id: ID of the AMI, which you can get by calling <DescribeImages>.
#!                  For more information go to: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ComponentsAMIs.html
#!                  Example: "ami-abcdef12"
#! @input instance_type: Instance type. For more information, see Instance Types in the Amazon Elastic Compute Cloud User Guide.
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
#!                                    Default: 'm1.small'
#!                                    Optional
#! @input kernel_id: ID of the kernel. Important: We recommend that you use PV-GRUB instead of kernels and RAM disks.
#!                   For more information, see PV-GRUB in the Amazon Elastic Compute Cloud User Guide.
#!                   Default: ''
#!                   Optional
#! @input ramdisk_id: ID of the RAM disk. Important: We recommend that you use PV-GRUB instead of kernels and RAM disks.
#!                    For more information, see PV-GRUB in the Amazon Elastic Compute Cloud User Guide.
#!                    Default: ''
#!                    Optional
#! @input subnet_id: String that contains one or more subnet IDs. If you launch into EC2 Classic then supply values for
#!                   this input and don't supply values for Private IP Addresses string. [EC2-VPC] The ID of the subnet
#!                   to launch the instance into.
#!                   Default: ''
#!                   Optional
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
#! @input volume_sizes_string: String that contains one or more values of the sizes (in GiB) for EBS devices.
#!                             Constraints: 1-16384 for General Purpose SSD ("gp2"), 4-16384 for Provisioned IOPS SSD ("io1"),
#!                             500-16384 for Throughput Optimized HDD ("st1"), 500-16384 for Cold HDD ("sc1"), and 1-1024 for
#!                             Magnetic ("standard") volumes. If you specify a snapshot, the volume size must be equal to or
#!                             larger than the snapshot size. If you are creating the volume from a snapshot and don't specify
#!                             a volume size, the default is the snapshot size.
#!                             Examples: "Not relevant,Not relevant,100"
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
#! @input instance_name_prefix: The name prefix of the instance.
#!                              Default: ''
#!                              Optional
#! @input key_pair_name: Name of the key pair. You can create a key pair using <CreateKeyPair> or <ImportKeyPair>.
#!                       Important: If you do not specify a key pair, you can't connect to the instance unless you choose
#!                       an AMI that is configured to allow users another way to log in.
#!                       Default: ''
#!                       Optional
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
#!
#! @output instance_id: The ID of the newly created instance.
#! @output ip_address: The public IP address of the new instance.
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
  name: deploy_instance
  inputs:
    - endpoint:
        default: 'https://ec2.amazonaws.com'
    - identity
    - credential:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
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
    - availability_zone:
        required: false
    - host_id:
        required: false
    - image_id
    - instance_type:
        default: 'm1.small'
        required: false
    - kernel_id:
        required: false
    - ramdisk_id:
        required: false
    - subnet_id:
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
    - volume_sizes_string:
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
    - instance_name_prefix:
        required: false
    - key_pair_name:
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
        default: 'stop'
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
        default: ''
        required: false
    - value_tags_string:
        default: ''
        required: false
    - polling_interval:
        default: '10'
        required: false
    - polling_retries:
        default: '50'
        required: false

  workflow:
    - run_instances:
        do:
          instances.run_instances:
            - endpoint
            - identity
            - credential
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
          - SUCCESS: check_instance_state
          - FAILURE: on_failure

    - check_instance_state:
        loop:
          for: 'step in range(0, int(get("polling_retries", 50)))'
          do:
            instances.check_instance_state:
              - identity
              - credential
              - proxy_host
              - proxy_port
              - proxy_username
              - proxy_password
              - instance_id
              - instance_state: running
              - polling_interval
          break:
            - SUCCESS
          publish:
            - return_result: '${output}'
            - return_code
            - exception
        navigate:
          - SUCCESS: generate_unique_name
          - FAILURE: terminate_instances

    - create_tags:
        do:
          tags.create_tags:
            - identity
            - credential
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
          - SUCCESS: describe_instances
          - FAILURE: terminate_instances

    - terminate_instances:
        loop:
          for: 'step in range(0, int(get("polling_retries", 50)))'
          do:
            instances.terminate_instances:
              - identity
              - credential
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

    - describe_instances:
        do:
          instances.describe_instances:
            - identity
            - credential
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
          - FAILURE: terminate_instances

    - search_and_replace:
        do:
          strings.search_and_replace:
            - origin_string: '${instance_details}'
            - text_to_replace: xmlns
            - replace_with: xhtml
        publish:
          - replaced_string
        navigate:
          - SUCCESS: parse_ip_address
          - FAILURE: on_failure

    - parse_ip_address:
        do:
          xml.xpath_query:
            - xml_document: '${replaced_string}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='ipAddress']"
            - query_type: 'value'
        publish:
          - ip_address: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure

    - generate_unique_name:
        do:
          utils.get_unique_name:
            - instance_name_prefix
            - instance_tags_key: '${key_tags_string}'
            - instance_tags_value: '${value_tags_string}'
        publish:
          - key_tags_string
          - value_tags_string
        navigate:
          - FAILURE: terminate_instances
          - SUCCESS: is_instance_name_empty

    - is_instance_name_empty:
        do:
          strings.string_equals:
            - first_string: '${key_tags_string}'
            - second_string: ''
        navigate:
          - FAILURE: create_tags
          - SUCCESS: describe_instances

  outputs:
    - instance_id
    - ip_address
    - return_result
    - return_code
    - exception

  results:
    - SUCCESS
    - FAILURE
