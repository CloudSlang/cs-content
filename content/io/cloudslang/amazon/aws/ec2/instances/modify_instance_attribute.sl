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
#! @description: Performs an Amazon Web Services Elastic Compute Cloud (EC2) command to update the type of a
#!               specified instance
#!               Notes: security_group_ids_string, instance_initiated_shutdown_behavior, instance_type,
#!                      source_destination_check are mutually exclusive
#!
#! @input endpoint: Optional - Endpoint to which first request will be sent
#!                  Default: 'https://ec2.amazonaws.com'
#! @input identity: The Amazon Access Key ID
#! @input credential: The Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#! @input proxy_host: Optional - The proxy server used to access the provider services
#! @input proxy_port: Optional - The proxy server port used to access the provider services
#!                    Default: '8080'
#! @input proxy_username: Optional - Proxy server user name.
#! @input proxy_password: Optional - Proxy server password associated with the proxy_username input value.
#! @input headers: Optional - A string containing the headers to use for the request separated by new line (CRLF). The
#!                 header name-value pair will be separated by ":".
#!                 Format: Conforming with HTTP standard for headers (RFC 2616)
#!                 Examples: 'Accept:text/plain'
#!                 Default: ''
#! @input query_params: Optional - A string containing query parameters that will be appended to
#!                      the URL. The names and the values must not be URL encoded because if
#!                      they are encoded then a double encoded will occur. The separator between
#!                      name-value pairs is "&" symbol. The query name will be separated from
#!                      query value by "=".
#!                      Examples: "parameterName1=parameterValue1&parameterName2=parameterValue2"
#!                      Default: ''
#! @input version: Version of the web service to made the call against it.
#!                 Example: '2016-09-15'
#!                 Default: '2016-09-15'
#! @input delimiter: Optional - Delimiter that will be used.
#!                   Default: ','
#! @input attribute: Optional - Name of the attribute.
#!                   Valid values: "instanceType | kernel | ramdisk | userData | disableApiTermination |
#!                   instanceInitiatedShutdownBehavior | rootDeviceName | blockDeviceMapping |
#!                   productCodes | sourceDestCheck | groupSet | ebsOptimized | sriovNetSupport |
#!                   enaSupport"
#! @input attribute_value: Optional - A new value for the attribute. Use only with: "kernel", "ramdisk",
#!                         "userData", "disableApiTermination", or "instanceInitiatedShutdownBehavior"
#!                         attributes.
#!                         Default: ''
#! @input block_device_mapping_device_names_string: Optional - String that contains one or more device names, exposed to
#!                                                  the instance, separated by <delimiter>.
#!                                                  Examples: "/dev/sdh,xvdh"
#!                                                  Default: ""
#! @input block_device_mapping_virtual_names_string: Optional - String that contains one or more virtual names separated
#!                                                   by <delimiter>. Virtual device name is "ephemeralN". Instance store
#!                                                   volumes are numbered starting from 0. An instance type with 2 available
#!                                                   instance store volumes can specify mappings for ephemeral0 and ephemeral1.
#!                                                   The number of available instance store volumes depends on the instance
#!                                                   type. After you connect to the instance, you must mount the volume.
#!                                                   Constraints: For M3 instances, you must specify instance store volumes
#!                                                   in the block device mapping for the instance. When you launch an M3
#!                                                   instance, we ignore any instance store volumes specified in the block
#!                                                   device mapping for the AMI.
#!                                                   Example: 'ephemeral0,ephemeral1,Not relevant'
#!                                                   Default: ''
#! @input delete_on_terminations_string: Optional - String that contains one or more values that indicates
#!                                       whether a specific EBS volume will be deleted on instance termination.
#!                                       Example: For a third EBS device (from existing 4 devices), that
#!                                       should be deleted, the string will be: "false,false,true,false".
#!                                       Valid values: 'true', 'false'
#!                                       Default: ''
#! @input volume_ids_string: Optional - String that contains one or more values that indicates
#!                           volume Ids.
#!                           Default: ''
#! @input no_devices_string: Optional - String that contains one or more values that indicates
#!                           if a certain specified device included in the block device mapping
#!                           will be suppressed.
#!                           Example: For a second EBS device (from existing 4 devices), that
#!                           should be suppressed, the string will be: ",No device,,".
#!                           Default: ''
#! @input disable_api_termination: Optional - If the value is "true", you can't terminate the instance
#!                                 using the Amazon EC2 console, CLI, or API; otherwise, you can. You
#!                                 cannot use this paramater for Spot Instances.
#!                                 Valid values: 'true', 'false'
#!                                 Default: 'false'
#! @input ebs_optimized: Optional - Specifies whether the instance is optimized for EBS I/O. This
#!                       optimization provides dedicated throughput to Amazon EBS and an optimized
#!                       configuration stack to provide optimal EBS I/O performance. This optimization
#!                       isn't available with all instance types. Additional usage charges apply
#!                       when using an EBS Optimized instance.
#!                       Valid values: 'true', 'false'
#!                       Default: 'false'
#! @input ena_support: Optional - Set to "true" to enable enhanced networking with ENA for the
#!                     instance. This option is supported only for HVM instances. Specifying
#!                     this option with a PV instance can make it unreachable.
#!                     Valid values: 'true', 'false'
#!                     Default: 'false'
#! @input security_group_ids_string: Optional - [EC2-VPC] Changes the security groups of the instance. You
#!                                   must specify at least one security group, even if it's just the default
#!                                   security group for the VPC. You must specify the security group IDs,
#!                                   not the security group names.
#!                                   Default: ''
#! @input instance_id: ID of the instance.
#!                     Example: 'i-12345678'
#! @input instance_initiated_shutdown_behavior: Optional - Specifies whether an instance stops or terminates when you
#!                                              initiate shutdown from the instance (using the operating system command
#!                                              for system shutdown).
#!                                              Valid values: "stop", "terminate"
#!                                              Default: "stop"
#! @input instance_type: Optional - Changes the instance type to the specified value. If the
#!                       instance type is not valid, the error returned is InvalidInstanceAttributeValue.
#!                       For more information, see Instance Types in the Amazon Elastic Compute
#!                       Cloud User Guide.
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
#!                       g2.2xlarge | g2.8xlarge | cg1.4xlarge | d2.xlarge | d2.2xlarge |
#!                       d2.4xlarge | d2.8xlarge"
#!                       Default: "m1.small"
#! @input kernel: Optional - Changes the instance's kernel to the specified value. We
#!                recommend that you use PV-GRUB instead of kernels and RAM disks.
#!                For more information, see PV-GRUB: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/UserProvidedKernels.html
#!                Default: ""
#! @input source_destination_check: Optional - Specifies whether source/destination checking is enabled.
#!                                  A value of "true" means that checking is enabled, and "false" means
#!                                  checking is disabled. This value must be "false" for a NAT instance to
#!                                  perform NAT.
#!                                  Valid values: "true", "false"
#!                                  Default: "false"
#! @input sriov_net_support: Optional - Set to "simple" to enable enhanced networking with the Intel
#!                           82599 Virtual Function interface for the instance. There is no way to
#!                           disable enhanced networking with the Intel 82599 Virtual Function interface
#!                           at this time. This option is supported only for HVM instances. Specifying
#!                           this option with a PV instance can make it unreachable.
#!                           Default: ""
#! @input user_data: Optional - Changes the instance's user data to the specified value.
#!                   If you are using an AWS SDK or command line tool, Base64-encoding is
#!                   performed for you, and you can load the text from a file. Otherwise,
#!                   you must provide Base64-encoded text.
#!                   Default: ""
#!
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output exception: exception if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: The server (instance) was successfully updated
#! @result FAILURE: An error occurred when trying to update a server (instance)
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.instances

operation:
  name: modify_instance_attribute

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
        default: "8080"
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
        required: false
        private: true
        sensitive: true
    - headers:
        required: false
    - query_params:
        required: false
    - version:
        default: "2016-09-15"
        required: false
    - delimiter:
        default: ","
        required: false
    - attribute:
        required: false
    - attribute_value:
        required: false
    - attributeValue:
        default: ${get("attribute_value", "")}
        required: false
        private: true
    - block_device_mapping_device_names_string:
        required: false
    - blockDeviceMappingDeviceNamesString:
        default: ${get("block_device_mapping_device_names_string", "")}
        required: false
        private: true
    - block_device_mapping_virtual_names_string:
        required: false
    - blockDeviceMappingVirtualNamesString:
        default: ${get("block_device_mapping_virtual_names_string", "")}
        required: false
        private: true
    - delete_on_terminations_string:
        required: false
    - deleteOnTerminationsString:
        default: ${get("delete_on_terminations_string", "")}
        required: false
        private: true
    - volume_ids_string:
        required: false
    - volumeIdsString:
        default: ${get("volume_ids_string", "")}
        required: false
        private: true
    - no_devices_string:
        required: false
    - noDevicesString:
        default: ${get("no_devices_string", "")}
        required: false
        private: true
    - disable_api_termination:
        default: "false"
        required: false
    - disableApiTermination:
        default: ${get("disable_api_termination", "")}
        required: false
        private: true
    - ebs_optimized:
        default: "false"
        required: false
    - ebsOptimized:
        default: ${get("ebs_optimized", "")}
        required: false
        private: true
    - ena_support:
        default: "false"
        required: false
    - enaSupport:
        default: ${get("ena_support", "")}
        required: false
        private: true
    - security_group_ids_string:
        required: false
    - securityGroupIdsString:
        default: ${get("security_group_ids_string", "")}
        required: false
        private: true
    - instance_id
    - instanceId:
        default: ${get("instance_id", "")}
        required: false
        private: true
    - instance_initiated_shutdown_behavior:
        required: false
    - instanceInitiatedShutdownBehavior:
        default: ${get("instance_initiated_shutdown_behavior", "")}
        required: false
        private: true
    - instance_type:
        required: false
    - instanceType:
        default: ${get("instance_type", "")}
        required: false
        private: true
    - kernel:
        required: false
    - source_destination_check:
        required: false
    - sourceDestinationCheck:
        default: ${get("source_destination_check", "")}
        required: false
        private: true
    - sriov_net_support:
        required: false
    - sriovNetSupport:
        default: ${get("sriov_net_support", "")}
        required: false
        private: true
    - user_data:
        required: false
    - userData:
        default: ${get("user_data", "")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.18'
    class_name: io.cloudslang.content.amazon.actions.instances.ModifyInstanceAttributeAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
