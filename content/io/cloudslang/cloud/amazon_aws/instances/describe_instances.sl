#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Performs an Amazon Web Services Elastic Compute Cloud (EC2) command to list the instances within a cloud
#!               region with advance filtering support. If value for input filter is not supplied than that filter is ignored.
#! @input provider: cloud provider on which the instance is - Default: 'amazon'
#! @input endpoint: endpoint to which first request will be sent - Default: 'https://ec2.amazonaws.com'
#! @input identity: optional - Amazon Access Key ID
#! @input credential: optional - Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#! @input proxy_host: optional - proxy server used to access the provider services
#! @input proxy_port: optional - proxy server port used to access the provider services - Default: '8080'
#! @input delimiter: optional - delimiter that will be used - Default: ','
#! @input debug_mode: optional - If 'true' then the execution logs will be shown in CLI console - Default: 'false'
#! @input region: optional - region where the servers (instances) are. list_regions operation can be used in order to get
#!                           all regions - Default: 'us-east-1'
#! @input volume_id: optional - volume ID of the EBS volume - Default: ''
#! @input group_id: optional - ID of the security group for the instance. EC2-Classic only - Default: ''
#! @input host_id: optional - ID of the dedicated host on which the instance is running, if applicable - Default: ''
#! @input image_id: optional - ID of the image used to launch the instance - Default: ''
#! @input instance_id: optional - instance ID - Default: ''
#! @input kernel_id: optional - kernel ID - Default: ''
#! @input owner_id: optional - AWS account ID of the instance owner - Default: ''
#! @input ramdisk_id: optional - RAM disk ID - Default: ''
#! @input reservation_id: optional - instance's reservation ID. A reservation ID is created any time you launch an instance.
#!                                   A reservation ID has a one-to-one relationship with an instance launch request, but
#!                                   can be associated with more than one instance if you launch multiple instances using
#!                                   the same launch request. For example, if we launch one instance, we'll get one reservation
#!                                   ID. If will launch ten instances using the same launch request, we'll also get one
#!                                   reservation ID - Default: ''
#! @input subnet_id: optional - subnet instance ID - Default: ''
#! @input vpc_id: optional - ID of the VPC that the instance is running in - Default: ''
#! @input allocation_id: optional - allocation ID returned when you allocated the Elastic IP address for your network interface.
#!                                - Default: ''
#! @input association_id: optional - association ID returned when the network interface was associated with an IP address.
#!                                 - Default: ''
#! @input architecture: optional - instance architecture. Valid values: '' (no architecture filtering), 'i386' or 'x86_64'.
#!                                 Default: ''
#! @input block_device_mapping_status: optional - status for the EBS volume - Valid values: '' (no block_device_mapping_status
#!                                                filtering), 'attaching', 'attached', 'detaching', 'detached'.
#! @input delete_on_termination: optional - a boolean that indicates whether the EBS volume is deleted on instance termination.
#!                                        - Valid values: '' (no delete_on_termination filtering) 'true', 'false' - Default: ''
#! @input block_mapping_device_name: optional - device name for the EBS volume. Ex: '/dev/sdh' or 'xvdh' - Default: ''
#! @input hypervisor: optional - hypervisor type of the instance. Valid values: '' (no hypervisor filtering), 'ovm', 'xen'.
#!                             - Default: ''
#! @input platform: optional - platform. Use 'windows' if you have Windows instances; otherwise, leave blank.
#!                           - Valid values: '', 'windows'.
#! @input product_code: optional - product code associated with the AMI used to launch the instance - Default: ''
#! @input product_code_type: optional - product code type. Valid values: '' (no product_code_type filtering), 'devpay',
#!                                      'marketplace' - Default: ''
#! @input root_device_name: optional - name of the root device for the instance. Ex: '/dev/sda1', '/dev/xvda' - Default: ''
#! @input root_device_type: optional - type of root device that the instance uses. Valid values: '' (no root_device_type
#!                                     filtering), 'ebs', 'instance-store' - Default: ''
#! @input state_reason_code: optional - reason code for the state change - Default: ''
#! @input state_reason_message: optional - a message that describes the state change - Default: ''
#! @input key_tags_string: optional - a string that contains: none, one or more tag keys separated by delimiter. The length
#!                                    of a key_tags_string should be the same as the length of value_tags_string - Default: ''
#! @input value_tags_string: optional - a string that contains: none, one or more tag values separated by delimiter. The
#!                                      length of a key_tags_string should be the same as the length of value_tags_string.
#!                                    - Default: ''
#! @input virtualization_type: optional - virtualization type of the instance. Valid values: '' (no virtualization_type
#!                                        filtering), 'paravirtual', 'hvm' - Default: ''
#! @input affinity: optional - affinity setting for an instance running on a dedicated host. Valid values: '' (no affinity
#!                             filtering), 'default' or 'host' - Default: ''
#! @input availability_zone: optional - availability zone of the instance - Default: ''
#! @input attach_time: optional - attach time for an EBS volume mapped to the instance. Ex: '2010-09-15T17:15:20.000Z'
#!                              - Default: ''
#! @input client_token: optional - idem-potency token that was provided when the instance was launched - Default: ''
#! @input dns_name: optional - public DNS name of the instance - Default: ''
#! @input group_name: optional - name of the security group for the instance. EC2-Classic only - Default: ''
#! @input iam_arn: optional - instance profile associated with the instance. Specified as an ARN - Default: ''
#! @input instance_lifecycle: optional - indicates whether this is a Spot Instance or a Scheduled Instance.
#!                                     - Valid values: '' (no instance_lifecycle filtering), 'spot', 'scheduled'.
#! @input instance_state_code: optional - instance state code, as a 16-bit unsigned integer. The high byte is an opaque
#!                                        internal value and should be ignored. The low byte is set based on the state
#!                                        represented. Valid values: '' (no instance_state_code filtering), '0' (pending),
#!                                        '16' (running), '32' (shutting-down), '48' (terminated), '64' (stopping) and
#!                                        '80' (stopped) - Default: ''
#! @input instance_state_name: optional - instance name. Valid values: '' (no instance_state_name filtering), 'pending',
#!                                        'running', 'shutting-down', 'terminated', 'stopping', 'stopped' - Default: ''
#! @input instance_type: optional - new server type to be used when updating the instance. The complete list of instance
#!                                  types can be found at: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html
#!                                  Ex: 't2.micro', 't2.medium', 'm3.large'  - Default: ''
#! @input instance_group_id: optional - ID of the security group for the instance  - Default: ''
#! @input instance_group_name: optional - name of the security group for the instance  - Default: ''
#! @input ip_address: optional - public IP address of the instance - Default: ''
#! @input key_name: optional - name of the key pair used when the instance was launched  - Default: ''
#! @input launch_index: optional - when launching multiple instances, this is the index for the instance in the launch group.
#!                                 Ex: 0, 1, 2, and so on  - Default: ''
#! @input launch_time: optional - time when the instance was launched - Default: ''
#! @input monitoring_state: optional - indicates whether monitoring is enabled for the instance.
#!                                   - Valid values: '' (no monitoring_state filtering), 'disabled', 'enabled' - Default: ''
#! @input placement_group_name: optional - name of the placement group for the instance - Default: ''
#! @input private_dns_name: optional - private DNS name of the instance - Default: ''
#! @input private_ip_address: optional - private IP address of the instance - Default: ''
#! @input reason: optional - reason for the current state of the instance. For e.g.: shows 'User Initiated [date]' when
#!                           user stops or terminates the instance. Similar to the state-reason-code filter - Default: ''
#! @input requester_id: optional - ID of the entity that launched the instance on your behalf (for e.g.: 'AWS Management Console',
#!                                 'Auto Scaling', and so on) - Default: ''
#! @input source_destination_check: optional - indicates whether the instance performs source/destination checking.
#!                                             A value of 'true' means that checking is enabled, and 'false' means checking
#!                                             is disabled. The value must be 'false' for the instance to perform network
#!                                             address translation (NAT) in your VPC - Default: ''
#! @input spot_instance_request_id: optional - ID of the Spot instance request - Default: ''
#! @input tenancy: optional - tenancy of an instance. Valid values: '' (no tenancy filtering), 'dedicated',
#!                            'default', 'host' - Default: ''
#! @input public_ip: optional - address of the Elastic IP address bound to the network interface - Default: ''
#! @input ip_owner_id: optional - owner of the Elastic IP address associated with the network interface - Default: ''
#! @input network_interface_description: optional - description of the network interface - Default: ''
#! @input network_interface_subnet_id: optional - ID of the subnet for the network interface - Default: ''
#! @input network_interface_vpc_id: optional - ID of the VPC for the network interface - Default: ''
#! @input network_interface_id: optional - ID of the network interface - Default: ''
#! @input network_interface_owner_id: optional - ID of the owner of the network interface - Default: ''
#! @input network_interface_availability_zone: optional - Availability Zone for the network interface - Default: ''
#! @input network_interface_requester_id: optional - requester ID for the network interface - Default: ''
#! @input network_interface_requester_managed: optional - indicates whether the network interface is being managed by AWS
#!                                                      - Default: ''
#! @input network_interface_status: optional - status of the network interface. Valid values: '' (no network_interface_status filtering),
#!                                             'available', 'in-use' - Default: ''
#! @input network_interface_mac_address: optional - MAC address of the network interface - Default: ''
#! @input network_interface_private_dns_name: optional - private DNS name of the network interface - Default: ''
#! @input network_interface_source_destination_check: optional - whether the network interface performs source/destination
#!                                                               checking. A value of true means checking is enabled, and
#!                                                               false means checking is disabled. The value must be false
#!                                                               for the network interface to perform network address
#!                                                               translation (NAT) in your VPC - Default: ''
#! @input network_interface_group_id: optional - ID of a security group associated with the network interface - Default: ''
#! @input network_interface_groupName: optional - name of a security group associated with the network interface - Default: ''
#! @input network_interface_attachment_id: optional - ID of the interface attachment - Default: ''
#! @input network_interface_instance_id: optional - ID of the instance to which the network interface is attached - Default: ''
#! @input network_interface_instance_owner_id: optional - owner ID of the instance to which the network interface is attached.
#!                                                      - Default: ''
#! @input network_interface_private_ip_address: optional - private IP address associated with the network interface - Default: ''
#! @input network_interface_device_index: optional - device index to which the network interface is attached - Default: ''
#! @input network_interface_attachment_status: optional - status of the attachment. Valid values: '' (no network_interface_attachment_status
#!                                                        filtering),'attaching', 'attached', 'detaching', 'detached'.
#!                                                      - Default: ''
#! @input network_interface_attach_time: optional - time that the network interface was attached to an instance - Default: ''
#! @input network_interface_delete_on_termination: optional - specifies whether the attachment is deleted when an instance
#!                                                            is terminated - Default: ''
#! @input network_interface_addresses_primary: optional - specifies whether the IP address of the network interface is
#!                                                        the primary private IP address - Default: ''
#! @input network_interface_public_ip: optional - ID of the association of an Elastic IP address with a network interface.
#!                                              - Default: ''
#! @input network_interface_ip_owner_id: optional - owner ID of the private IP address associated with the network interface.
#!                                                - Default: ''
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: the list with existing servers (instances) was successfully retrieved
#! @result FAILURE: an error occurred when trying to retrieve servers (instances) list
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.instances

operation:
  name: describe_instances

  inputs:
    - provider: 'amazon'
    - endpoint: 'https://ec2.amazonaws.com'
    - identity:
        required: false
        sensitive: true
    - credential:
        required: false
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
        default: ${get("proxy_port", "8080")}
        private: true
    - delimiter:
        default: ','
        required: false
    - debug_mode:
        required: false
    - debugMode:
        default: ${get("debug_mode", "false")}
        private: true
    - region:
        default: 'us-east-1'
        required: false
    - volume_id:
        required: false
    - volumeId:
        default: ${get("volume_id", "")}
        private: true
        required: false
    - group_id:
        required: false
    - groupId:
        default: ${get("group_id", "")}
        private: true
        required: false
    - host_id:
        required: false
    - hostId:
        default: ${get("host_id", "")}
        private: true
        required: false
    - image_id:
        required: false
    - imageId:
        default: ${get("image_id", "")}
        private: true
    - instance_id:
        required: false
    - instanceId:
        default: ${get("instance_id", "")}
        private: true
        required: false
    - kernel_id:
        required: false
    - kernelId:
        default: ${get("kernel_id", "")}
        private: true
        required: false
    - owner_id:
        required: false
    - ownerId:
        default: ${get("owner_id", "")}
        private: true
        required: false
    - ramdisk_id:
        required: false
    - ramdiskId:
        default: ${get("ramdisk_id", "")}
        private: true
        required: false
    - reservation_id:
        required: false
    - reservationId:
        default: ${get("reservation_id", "")}
        private: true
        required: false
    - subnet_id:
        required: false
    - subnetId:
        default: ${get("subnet_id", "")}
        private: true
        required: false
    - vpc_id:
        required: false
    - vpcId:
        default: ${get("vpc_id", "")}
        private: true
        required: false
    - allocation_id:
        required: false
    - allocationId:
        default: ${get("allocation_id", "")}
        private: true
        required: false
    - association_id:
        required: false
    - associationId:
        default: ${get("association_id", "")}
        private: true
        required: false
    - architecture:
        default: ''
        required: false
    - block_device_mapping_status:
        required: false
    - blockDeviceMappingStatus:
        default: ${get("block_device_mapping_status", "")}
        private: true
        required: false
    - delete_on_termination:
        required: false
    - deleteOnTermination:
        default: ${get("delete_on_termination", "")}
        private: true
        required: false
    - block_mapping_device_name:
        required: false
    - blockMappingDeviceName:
        default: ${get("block_mapping_device_name", "")}
        private: true
        required: false
    - hypervisor:
        default: ''
        required: false
    - platform:
        required: false
        default: ''
    - product_code:
        required: false
    - productCode:
        default: ${get("product_code", "")}
        private: true
        required: false
    - product_code_type:
        required: false
    - productCodeType:
        default: ${get("product_code_type", "")}
        private: true
        required: false
    - root_device_name:
        required: false
    - rootDeviceName:
        default: ${get("root_device_name", "")}
        private: true
        required: false
    - root_device_type:
        required: false
    - rootDeviceType:
        default: ${get("root_device_type", "")}
        private: true
        required: false
    - key_tags_string:
        required: false
    - keyTagsString:
        default: ${get("key_tags_string", "")}
        private: true
        required: false
    - value_tags_string:
        required: false
    - valueTagsString:
        default: ${get("value_tags_string", "")}
        private: true
        required: false
    - virtualization_type:
        required: false
    - virtualizationType:
        default: ${get("virtualization_type", "")}
        private: true
        required: false
    - affinity:
        default: ''
        required: false
    - availability_zone:
        required: false
    - availabilityZone:
        default: ${get("availability_zone", "")}
        private: true
        required: false
    - attach_time:
        required: false
    - attachTime:
        default: ${get("attach_time", "")}
        private: true
        required: false
    - client_token:
        required: false
    - clientToken:
        default: ${get("client_token", "")}
        private: true
        required: false
    - dns_name:
        required: false
    - dnsName:
        default: ${get("dns_name", "")}
        private: true
        required: false
    - group_name:
        required: false
    - groupName:
        default: ${get("group_name", "")}
        private: true
        required: false
    - iam_arn:
        required: false
    - iamArn:
        default: ${get("iam_arn", "")}
        private: true
        required: false
    - instance_lifecycle:
        required: false
    - instanceLifecycle:
        default: ${get("instance_lifecycle", "")}
        private: true
        required: false
    - instance_state_code:
        required: false
    - instanceStateCode:
        default: ${get("instance_state_code", "")}
        private: true
        required: false
    - instance_state_name:
        required: false
    - instanceStateName:
        default: ${get("instance_state_name", "")}
        private: true
        required: false
    - instance_type:
        required: false
    - instanceType:
        default: ${get("instance_type", "")}
        private: true
        required: false
    - instance_group_id:
        required: false
    - instanceGroupId:
        default: ${get("instance_group_id", "")}
        private: true
        required: false
    - instance_group_name:
        required: false
    - instanceGroupName:
        default: ${get("instance_group_name", "")}
        private: true
        required: false
    - ip_address:
        required: false
    - ipAddress:
        default: ${get("ip_address", "")}
        private: true
        required: false
    - key_name:
        required: false
    - keyName:
        default: ${get("key_name", "")}
        private: true
        required: false
    - launch_index:
        required: false
    - launchIndex:
        default: ${get("launch_index", "")}
        private: true
        required: false
    - launch_time:
        required: false
    - launchTime:
        default: ${get("launch_time", "")}
        private: true
        required: false
    - monitoring_state:
        required: false
    - monitoringState:
        default: ${get("monitoring_state", "")}
        private: true
        required: false
    - placement_group_name:
        required: false
    - placementGroupName:
        default: ${get("placement_group_name", "")}
        private: true
        required: false
    - private_dns_name:
        required: false
    - privateDnsName:
        default: ${get("private_dns_name", "")}
        private: true
        required: false
    - private_ip_address:
        required: false
    - privateIpAddress:
        default: ${get("private_ip_address", "")}
        private: true
        required: false
    - reason:
        required: false
        default: ''
    - requester_id:
        required: false
    - requesterId:
        default: ${get("requester_id", "")}
        private: true
        required: false
    - source_destination_check:
        required: false
    - sourceDestinationCheck:
        default: ${get("source_destination_check", "")}
        private: true
        required: false
    - spot_instance_request_id:
        required: false
    - spotInstanceRequestId:
        default: ${get("spot_instance_request_id", "")}
        private: true
        required: false
    - tenancy:
        default: ''
        required: false
    - public_ip:
        required: false
    - publicIp:
        default: ${get("public_ip", "")}
        private: true
        required: false
    - ip_owner_id:
        required: false
    - ipOwnerId:
        default: ${get("ip_owner_id", "")}
        private: true
        required: false
    - network_interface_description:
        required: false
    - networkInterfaceDescription:
        default: ${get("network_interface_description", "")}
        private: true
        required: false
    - network_interface_subnet_id:
        required: false
    - networkInterfaceSubnetId:
        default: ${get("network_interface_subnet_id", "")}
        private: true
        required: false
    - network_interface_vpc_id:
        required: false
    - networkInterfaceVpcId:
        default: ${get("network_interface_vpc_id", "")}
        private: true
        required: false
    - network_interface_id:
        required: false
    - networkInterfaceId:
        default: ${get("network_interface_id", "")}
        private: true
        required: false
    - network_interface_owner_id:
        required: false
    - networkInterfaceOwnerId:
        default: ${get("network_interface_owner_id", "")}
        private: true
        required: false
    - network_interface_availability_zone:
        required: false
    - networkInterfaceAvailabilityZone:
        default: ${get("network_interface_availability_zone", "")}
        private: true
        required: false
    - network_interface_requester_id:
        required: false
    - networkInterfaceRequesterId:
        default: ${get("network_interface_requester_id", "")}
        private: true
        required: false
    - network_interface_requester_managed:
        required: false
    - networkInterfaceRequesterManaged:
        default: ${get("network_interface_requester_managed", "")}
        private: true
        required: false
    - network_interface_status:
        required: false
    - networkInterfaceStatus:
        default: ${get("network_interface_status", "")}
        private: true
        required: false
    - network_interface_mac_address:
        required: false
    - networkInterfaceMacAddress:
        default: ${get("network_interface_mac_address", "")}
        private: true
        required: false
    - network_interface_private_dns_name:
        required: false
    - networkInterfacePrivateDnsName:
        default: ${get("network_interface_private_dns_name", "")}
        private: true
        required: false
    - network_interface_source_destination_check:
        required: false
    - networkInterfaceSourceDestinationCheck:
        default: ${get("network_interface_source_destination_check", "")}
        private: true
        required: false
    - network_interface_group_id:
        required: false
    - networkInterfaceGroupId:
        default: ${get("network_interface_group_id", "")}
        private: true
        required: false
    - network_interface_groupName:
        required: false
    - networkInterfaceGroupName:
        default: ${get("network_interface_groupName", "")}
        private: true
        required: false
    - network_interface_attachment_id:
        required: false
    - networkInterfaceAttachmentId:
        default: ${get("network_interface_attachment_id", "")}
        private: true
        required: false
    - network_interface_instance_id:
        required: false
    - networkInterfaceInstanceId:
        default: ${get("network_interface_instance_id", "")}
        private: true
        required: false
    - network_interface_instance_owner_id:
        required: false
    - networkInterfaceInstanceOwnerId:
        default: ${get("network_interface_instance_owner_id", "")}
        private: true
        required: false
    - network_interface_private_ip_address:
        required: false
    - networkInterfacePrivateIpAddress:
        default: ${get("network_interface_private_ip_address", "")}
        private: true
        required: false
    - network_interface_device_index:
        default: ${get("network_interface_device_index", "")}
        private: true
        required: false
    - network_interface_attachment_status:
        required: false
    - networkInterfaceAttachmentStatus:
        default: ${get("network_interface_attachment_status", "")}
        private: true
        required: false
    - network_interface_attach_time:
        required: false
    - networkInterfaceAttachTime:
        default: ${get("network_interface_attach_time", "")}
        private: true
        required: false
    - network_interface_delete_on_termination:
        required: false
    - networkInterfaceDeleteOnTermination:
        default: ${get("network_interface_delete_on_termination", "")}
        private: true
        required: false
    - network_interface_addresses_primary:
        required: false
    - networkInterfaceAddressesPrimary:
        default: ${get("network_interface_addresses_primary", "")}
        private: true
        required: false
    - network_interface_public_ip:
        required: false
    - networkInterfacePublicIp:
        default: ${get("network_interface_public_ip", "")}
        private: true
        required: false
    - network_interface_ip_owner_id:
        required: false
    - networkInterfaceIpOwnerId:
        default: ${get("network_interface_ip_owner_id", "")}
        private: true
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-jClouds:0.0.6'
    class_name: io.cloudslang.content.jclouds.actions.instances.DescribeInstancesAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${exception if exception in locals() else ''}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE