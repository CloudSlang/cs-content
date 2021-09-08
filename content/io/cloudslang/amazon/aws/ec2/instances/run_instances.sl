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
#! @description: Performs an Amazon Web Services Elastic Compute Cloud (EC2) command to launch one ore more new instance/instances
#!
#! @input endpoint: Optional - Endpoint to which request will be sent
#!                  Default: "https://ec2.amazonaws.com"
#! @input identity: Amazon Access Key ID
#!                  Default: ""
#! @input credential: Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#!                    Default: ""
#! @input proxy_host: Optional - Proxy server used to access the provider services
#!                    Default: ""
#! @input proxy_port: Optional - Proxy server port used to access the provider services
#!                    Default: "8080"
#! @input proxy_username: Optional - proxy server user name.
#!                        Default: ""
#! @input proxy_password: Optional - proxy server password.
#!                        Default: ""
#! @input headers: Optional - string containing the headers to use for the request separated
#!                 by new line (CRLF). The header name-value pair will be separated by ":".
#!                 Format: Conforming with HTTP standard for headers (RFC 2616)
#!                 Examples: Accept:text/plain
#!                 Default: ""
#! @input query_params: Optional - string containing query parameters that will be appended to
#!                      the URL. The names and the values must not be URL encoded because if
#!                      they are encoded then a double encoded will occur. The separator between
#!                      name-value pairs is "&" symbol. The query name will be separated from query value by "=".
#!                      Examples: "parameterName1=parameterValue1&parameterName2=parameterValue2"
#!                      Default: ""
#! @input version: Optional - version of the web service to make the call against it.
#!                 Example: "2016-04-01"
#!                 Default: "2016-04-01"
#! @input delimiter: Optional - delimiter that will be used.
#!                   Default: ","
#! @input availability_zone: Optional - Specifies the placement constraints for launching instance. Amazon automatically
#!                           selects an availability zone by default
#!                           Default: ""
#! @input hostId: Optional - ID of the dedicated host on which the instance resides (as part of Placement).
#!                This parameter is not support for the <ImportInstance> command.
#!                Default: ""
#! @input image_id: ID of the AMI. For more information go to:
#!                  http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ComponentsAMIs.html
#!                  Examples: "ami-abcdef12"
#! @input instance_type: Optional - Instance type. For more information, see Instance Types in the
#!                       Amazon Elastic Compute Cloud User Guide.
#!                       Valid values: t1.micro | t2.nano | t2.micro | t2.small | t2.medium |
#!                       t2.large | m1.small | m1.medium | m1.large | m1.xlarge | m3.medium |
#!                       m3.large | m3.xlarge | m3.2xlarge | m4.large | m4.xlarge | m4.2xlarge |
#!                       m4.4xlarge | m4.10xlarge | m2.xlarge | m2.2xlarge | m2.4xlarge |
#!                       cr1.8xlarge | r3.large | r3.xlarge | r3.2xlarge | r3.4xlarge |
#!                       r3.8xlarge | x1.4xlarge | x1.8xlarge | x1.16xlarge | x1.32xlarge |
#!                       i2.xlarge | i2.2xlarge | i2.4xlarge | i2.8xlarge | hi1.4xlarge |
#!                       hs1.8xlarge | c1.medium | c1.xlarge | c3.large | c3.xlarge |
#!                       c3.2xlarge | c3.4xlarge | c3.8xlarge | c4.large | c4.xlarge |
#!                       c4.2xlarge | c4.4xlarge | c4.8xlarge | cc1.4xlarge | cc2.8xlarge |
#!                       g2.2xlarge | g2.8xlarge | cg1.4xlarge | d2.xlarge | d2.2xlarge |d2.4xlarge | d2.8xlarge"
#!                       Default: "m1.small"
#! @input host_id: Optional - ID of the kernel.
#! @input kernel_id: Optional - ID of the kernel.
#!                   Important: We recommend that you use PV-GRUB instead of kernels
#!                   and RAM disks. For more information, see PV-GRUB in the Amazon
#!                   Elastic Compute Cloud User Guide.
#!                   Default: ""
#! @input ramdisk_id: Optional - ID of the RAM disk.
#!                    Important: We recommend that you use PV-GRUB instead of kernels
#!                    and RAM disks. For more information, see PV-GRUB in the Amazon
#!                    Elastic Compute Cloud User Guide.
#!                    Default: ""
#! @input subnet_id: Optional - String that contains one or more subnet IDs. If you
#!                   launch into EC2 Classic then supply values for this input and
#!                   don"t supply values for Private IP Addresses string.
#!                   [EC2-VPC] The ID of the subnet to launch the instance into.
#!                   Default: ""
#! @input block_device_mapping_device_names_string: Optional - String that contains one or more device names, exposed
#!                                                  to the instance, separated by <delimiter>. If you want to suppress
#!                                                  the specified device included in the block device mapping of the
#!                                                  AMI then supply "NoDevice" in string.
#!                                                  Examples: "/dev/sdc,/dev/sdd", "/dev/sdh", "xvdh" or "NoDevice"
#!                                                  Default: ""
#! @input block_device_mapping_virtual_names_string: Optional - String that contains one or more virtual names separated
#!                                                   by <delimiter>. Virtual device name is "ephemeralN". Instance store
#!                                                   volumes are numbered starting from 0. An instance type with 2 available
#!                                                   instance store volumes can specify mappings for ephemeral0 and ephemeral1.
#!                                                   The number of available instance store volumes depends on the instance
#!                                                   type. After you connect to the instance, you must mount the volume.
#!                                                   Constraints: For M3 instances, you must specify instance store volumes
#!                                                   in the block device mapping for the instance. When you launch an M3
#!                                                   instance, we ignore any instance store volumes specified in the bloc
#!                                                   device mapping for the AMI.
#!                                                   Example: "ephemeral0,ephemeral1,Not relevant"
#!                                                   Default: ""
#! @input delete_on_terminations_string: Optional - String that contains one or more values that indicates
#!                                       whether a specific EBS volume will be deleted on instance termination.
#!                                       Example: For a second EBS device (from existing 4 devices), that
#!                                       should be deleted, the string will be: "false,true,false,false".
#!                                       Valid values: "true", "false"
#!                                       Default: ""
#! @input ebs_optimized: Optional - Indicates whether the instance is optimized for EBS I/O.
#!                       This optimization provides dedicated throughput to Amazon EBS and an
#!                       optimized configuration stack to provide optimal EBS I/O performance.
#!                       This optimization isn"t available with all instance types. Additional
#!                       usage charges apply when using an EBS-optimized instance.
#!                       Valid values: "true", "false"
#!                       Default: "false"
#! @input encrypted_string: Optional - String that contains one or more values that indicates
#!                          whether a specific EBS volume will be encrypted. Encrypted Amazon
#!                          EBS volumes may only be attached to instances that support Amazon
#!                          EBS encryption.
#!                          Example: For a second EBS device (from existing 4 devices), that
#!                          should be encrypted, the string will be: "0,1,0,0". If no value
#!                          provided the the default value of not encrypted will be considered
#!                          for all EBS specified devices.
#!                          Default: ""
#! @input iops_string: Optional - String that contains one or more values that specifies
#!                     the number of I/O operations per second (IOPS) that the volume supports.
#!                     For "io1", this represents the number of IOPS that are provisioned
#!                     for the volume. For "gp2", this represents the baseline performance
#!                     of the volume and the rate at which the volume accumulates I/O
#!                     credits for bursting. For more information about General Purpose
#!                     SSD baseline performance, I/O credits, and bursting, see Amazon
#!                     EBS Volume Types in the Amazon Elastic Compute Cloud User Guide.
#!                     Constraint: Range is 100-20000 IOPS for "io1" volumes and 100-10000
#!                     IOPS for "gp2" volumes.
#!                     Condition: This parameter is required for requests to create "io1"
#!                     volumes; it is not used in requests to create "gp2", "st1", "sc1",
#!                     or "standard" volumes.
#!                     Example: For a first EBS device (from existing 3 devices), with
#!                     type "io1" that should have 5000 IOPS as value the string will
#!                     be: "5000,,". If no value provided then the default value for every
#!                     single EBS device will be used.
#!                     Default: ""
#! @input snapshot_ids_string: Optional - String that contains one or more values of the snapshot
#!                             IDs to be used when creating the EBS device.
#!                             Example: For a last EBS device (from existing 3 devices), to be
#!                             created using a snapshot as image the string will be:
#!                             "Not relevant,Not relevant,snap-abcdef12". If no value provided
#!                             then no snapshot will be used when creating EBS device.
#!                             Default: ""
#! @input volume_sizes_string: Optional - String that contains one or more values of the sizes
#!                             (in GiB) for EBS devices.
#!                             Constraints: 1-16384 for General Purpose SSD ("gp2"), 4-16384 for
#!                             Provisioned IOPS SSD ("io1"), 500-16384 for Throughput Optimized
#!                             HDD ("st1"), 500-16384 for Cold HDD ("sc1"), and 1-1024 for Magnetic
#!                             ("standard") volumes. If you specify a snapshot, the volume size
#!                             must be equal to or larger than the snapshot size. If you"re creating
#!                             the volume from a snapshot and don"t specify a volume size, the
#!                             default is the snapshot size.
#!                             Examples: "Not relevant,Not relevant,100"
#!                             Default: ""
#! @input volume_types_string: Optional - String that contains one or more values that specifies
#!                             the volume types: "gp2", "io1", "st1", "sc1", or "standard". If
#!                             no value provided then the default value of "standard" for every
#!                             single EBS device type will be considered.
#!                             Default: ""
#! @input private_ip_address: Optional - [EC2-VPC] The primary IP address. You must specify a
#!                            value from the IP address range of the subnet. Only one private
#!                            IP address can be designated as primary. Therefore, you can"t
#!                            specify this parameter if <PrivateIpAddresses.n.Primary> is set
#!                            to "true" and <PrivateIpAddresses.n.PrivateIpAddress> is set to
#!                            an IP address.
#!                            Default: We select an IP address from the IP address range of the subnet.
#! @input private_ip_addresses_string: Optional - String that contains one or more private IP addresses
#!                                     to assign to the network interface. Only one private IP address
#!                                     can be designated as primary. Use this if you want to launch instances
#!                                     with many NICs attached. Separate the NICs privateIps with "|"
#!                                     Example: "10.0.0.1,20.0.0.1|30.0.0.1"
#!                                     Default: ""
#! @input iam_instance_profile_arn: Optional - Amazon Resource Name (IAM_INSTANCE_PROFILE_ARN) of the
#!                                  instance profile.
#!                                  Example: "arn:aws:iam::123456789012:user/some_user"
#!                                  Default: ""
#! @input iam_instance_profile_name: Optional - Name of the instance profile.
#!                                   Default: ""
#! @input key_pair_name: Optional - Name of the key pair. You can create a key pair using
#!                       <CreateKeyPair> or <ImportKeyPair>.
#!                       Important: If you do not specify a key pair, you can"t connect to
#!                       the instance unless you choose an AMI that is configured to allow
#!                       users another way to log in.
#!                       Default: ""
#! @input security_group_ids_string: Optional - IDs of the security groups for the network interface.
#!                                   Applies only if creating a network interface when launching an
#!                                   instance. Separate the groupIds for each NIC with "|"
#!                                   Example: "sg-01234567,sg-7654321|sg-abcdef01"
#!                                   Default: ""
#! @input security_group_names_string: Optional - String that contains one or more IDs of the security
#!                                     groups for the network interface. Applies only if creating a network
#!                                     interface when launching an instance.
#!                                     Default: ""
#! @input affinity: Optional - Affinity setting for the instance on the Dedicated Host
#!                  (as part of Placement). This parameter is not supported for the <ImportInstance> command.
#!                  Default: ""
#! @input client_token: Optional - Unique, case-sensitive identifier you provide to ensure
#!                      the idem-potency of the request. For more information, see Ensuring Idempotency.
#!                      Constraints: Maximum 64 ASCII characters
#!                      Default: ""
#! @input disable_api_termination: Optional - If you set this parameter to "true", you can"t terminate
#!                                 the instance using the Amazon EC2 console, CLI, or API; otherwise,
#!                                 you can. If you set this parameter to "true" and then later want
#!                                 to be able to terminate the instance, you must first change the
#!                                 value of the <disableApiTermination> attribute to "false" using
#!                                 <ModifyInstanceAttribute>. Alternatively, if you set <InstanceInitiatedShutdownBehavior>
#!                                 to "terminate", you can terminate the instance by running the shutdown
#!                                 command from the instance.
#!                                 Valid values: "true", "false"
#!                                 Default: "false"
#! @input instance_initiated_shutdown_behavior: Optional - Indicates whether an instance stops or terminates when
#!                                              you initiate shutdown from the instance (using the operating system
#!                                              command for system shutdown).
#!                                              Valid values: "stop", "terminate"
#!                                              Default: "stop"
#! @input max_count: Optional - The maximum number of launched instances - Default: "1"
#! @input min_count: Optional - The minimum number of launched instances - Default: "1"
#! @input monitoring: Optional - whether to enable or not monitoring for the instance.
#!                    Default: "false"
#! @input placement_group_name: Optional - Name of the placement group for the instance (as part of Placement).
#!                              Default: ""
#! @input tenancy: Optional - Tenancy of an instance (if the instance is running in a VPC - as part of Placement).
#!                 An instance with a tenancy of dedicated runs on single-tenant hardware.
#!                 The host tenancy is not supported for the ImportInstance command.
#!                 Valid values: "dedicated", "default", "host".
#! @input user_data: Optional - The user data to make available to the instance. For
#!                   more information, see Running Commands on Your Linux Instance at
#!                   Launch (Linux) and Adding User Data (Windows). If you are using
#!                   an AWS SDK or command line tool, Base64-encoding is performed for
#!                   you, and you can load the text from a file. Otherwise, you must
#!                   provide Base64-encoded text.
#!                   Default: ""
#! @input network_interface_associate_public_ip_address: Optional - String that contains one or more values that indicates
#!                                                       whether to assign a public IP address or not when you launch in
#!                                                       a VPC. The public IP address can only be assigned to a network
#!                                                       interface for eth0, and can only be assigned to a new network
#!                                                       interface, not an existing one. You cannot specify more than one
#!                                                       network interface in the request. If launching into a default subnet,
#!                                                       the default value is "true".
#!                                                       Valid values: "true", "false"
#!                                                       Default: ""
#! @input network_interface_delete_on_termination: Optional - String that contains one or more values that indicates
#!                                                  that the interface is deleted when the instance is terminated.
#!                                                  You can specify true only if creating a new network interface when
#!                                                  launching an instance.
#!                                                  Valid values: "true", "false"
#!                                                  Default: ""
#! @input network_interface_description: Optional - String that contains one or more values that describe
#!                                       the network interfaces. Applies only if creating a network interfaces
#!                                       when launching an instance.
#!                                       Default: ""
#! @input network_interface_device_index: Optional - String that contains one or more values that are indexes
#!                                        of the device on the instance for the network interface attachment.
#!                                        If you are specifying a network interface in a RunInstances request,
#!                                        you should provide the device index.
#!                                        Default: ""
#! @input network_interface_id: Optional - String that contains one or more values that are IDs of the network interfaces.
#!                              Default: ""
#! @input secondary_private_ip_address_count: Optional - The number of secondary private IP addresses. You can"t
#!                                            specify this option and specify more than one private IP address
#!                                            using the private IP addresses option. Minimum valid number is 2.
#!                                            Default: ""
#!
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output instance_id_result: id of the instance in case of success
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise
#! @output exception: exception if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: The server (instance) was successfully launched/created
#! @result FAILURE: An error occurred when trying to launch/create a server (instance)
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.instances

operation:
  name: run_instances

  inputs:
   -  endpoint:
         default: 'https://ec2.amazonaws.com'
         required: false
   -  identity
   -  credential:
         sensitive: true
   -  proxy_host:
         required: false
   -  proxyHost:
         default: ${get("proxy_host", "")}
         required: false
         private: true
   -  proxy_port:
         required: false
   -  proxyPort:
         default: ${get("proxy_port", "")}
         required: false
         private: true
   -  proxy_username:
         required: false
   -  proxyUsername:
         default: ${get("proxy_username", "")}
         required: false
         private: true
   -  proxy_password:
         required: false
         sensitive: true
   -  proxyPassword:
         default: ${get("proxy_password", "")}
         required: false
         private: true
         sensitive: true
   -  headers:
         required: false
   -  query_params:
         required: false
   -  queryParams:
         default: ${get("query_params", "")}
         required: false
         private: true
   -  version:
         default: "2016-04-01"
         required: false
   -  delimiter:
         default: ","
         required: false
   -  availability_zone:
         required: false
   -  availabilityZone:
         default: ${get("availability_zone", "")}
         required: false
         private: true
   -  host_id:
         required: false
   -  hostId:
         default: ${get("host_id", "")}
         required: false
         private: true
   -  image_id
   -  imageId:
         default: ${get("image_id", "")}
         required: false
         private: true
   -  instance_type:
         required: false
   -  instanceType:
         default: ${get("instance_type", "")}
         required: false
         private: true
   -  kernel_id:
         required: false
   -  kernelId:
         default: ${get("kernel_id", "")}
         required: false
         private: true
   -  ramdisk_id:
         required: false
   -  ramdiskId:
         default: ${get("ramdisk_id", "")}
         required: false
         private: true
   -  subnet_id:
         required: false
   -  subnetId:
         default: ${get("subnet_id", "")}
         required: false
         private: true
   -  block_device_mapping_device_names_string:
         required: false
   -  blockDeviceMappingDeviceNamesString:
         default: ${get("block_device_mapping_device_names_string", "")}
         required: false
         private: true
   -  block_device_mapping_virtual_names_string:
         required: false
   -  blockDeviceMappingVirtualNamesString:
         default: ${get("block_device_mapping_virtual_names_string", "")}
         required: false
         private: true
   -  delete_on_terminations_string:
         required: false
   -  deleteOnTerminationsString:
         default: ${get("delete_on_terminations_string", "")}
         required: false
         private: true
   -  ebs_optimized:
         required: false
   -  ebsOptimized:
         default: ${get("ebs_optimized", "")}
         required: false
         private: true
   -  encrypted_string:
         required: false
   -  encryptedString:
         default: ${get("encrypted_string", "")}
         required: false
         private: true
   -  iops_string:
         required: false
   -  iopsString:
         default: ${get("iops_string", "")}
         required: false
         private: true
   -  snapshot_ids_string:
         required: false
   -  snapshotIdsString:
         default: ${get("snapshot_ids_string", "")}
         required: false
         private: true
   -  volume_sizes_string:
         required: false
   -  volumeSizesString:
         default: ${get("volume_sizes_string", "")}
         required: false
         private: true
   -  volume_types_string:
         required: false
   -  volumeTypesString:
         default: ${get("volume_types_string", "")}
         required: false
         private: true
   -  private_ip_address:
         required: false
   -  privateIpAddress:
         default: ${get("private_ip_address", "")}
         required: false
         private: true
   -  private_ip_addresses_string:
         required: false
   -  privateIpAddressesString:
         default: ${get("private_ip_addresses_string", "")}
         required: false
         private: true
   -  iam_instance_profile_arn:
         required: false
   -  iamInstanceProfileArn:
         default: ${get("iam_instance_profile_arn", "")}
         required: false
         private: true
   -  iam_instance_profile_name:
         required: false
   -  iamInstanceProfileName:
         default: ${get("iam_instance_profile_name", "")}
         required: false
         private: true
   -  key_pair_name:
         required: false
   -  keyPairName:
         default: ${get("key_pair_name", "")}
         required: false
         private: true
   -  security_group_ids_string:
         required: false
   -  securityGroupIdsString:
         default: ${get("security_group_ids_string", "")}
         required: false
         private: true
   -  affinity:
         required: false
   -  client_token:
         required: false
   -  clientToken:
         default: ${get("client_token", "")}
         required: false
         private: true
   -  disable_api_termination:
         required: false
   -  disableApiTermination:
         default: ${get("disable_api_termination", "")}
         required: false
         private: true
   -  instance_initiated_shutdown_behavior:
         required: false
   -  instanceInitiatedShutdownBehavior:
         default: ${get("instance_initiated_shutdown_behavior", "")}
         required: false
         private: true
   -  max_count:
         required: false
   -  maxCount:
         default: ${get("max_count", "")}
         required: false
         private: true
   -  min_count:
         required: false
   -  minCount:
         default: ${get("min_count", "")}
         required: false
         private: true
   -  monitoring:
         required: false
   -  placement_group_name:
         required: false
   -  placementGroupName:
         default: ${get("placement_group_name", "")}
         required: false
         private: true
   -  tenancy:
         required: false
   -  user_data:
         required: false
   -  userData:
         default: ${get("user_data", "")}
         required: false
         private: true
   -  network_interface_associate_public_ip_address:
         required: false
   -  networkInterfaceAssociatePublicIpAddress:
         default: ${get("network_interface_associate_public_ip_address", "")}
         required: false
         private: true
   -  network_interface_delete_on_termination:
         required: false
   -  networkInterfaceDeleteOnTermination:
         default: ${get("network_interface_delete_on_termination", "")}
         required: false
         private: true
   -  network_interface_description:
         required: false
   -  networkInterfaceDescription:
         default: ${get("network_interface_description", "")}
         required: false
         private: true
   -  network_interface_device_index:
         required: false
   -  networkInterfaceDeviceIndex:
         default: ${get("network_interface_device_index", "")}
         required: false
         private: true
   -  network_interface_id:
         required: false
   -  networkInterfaceId:
         default: ${get("network_interface_id", "")}
         required: false
         private: true
   -  secondary_private_ip_address_count:
         required: false
   -  secondaryPrivateIpAddressCount:
         default: ${get("secondary_private_ip_address_count", "")}
         required: false
         private: true

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.18'
    class_name: io.cloudslang.content.amazon.actions.instances.RunInstancesAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}
    - instance_id_result: ${get("instanceIdResult", "")}

  results:
    - SUCCESS: ${returnCode == "0"}
    - FAILURE