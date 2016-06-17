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
#! @input region: optional - region where the servers (instances) are. list_regions operation can be used in order to get
#!                           all regions - Default: 'us-east-1'
#! @input volume_id: optional - volume ID of the EBS volume.
#! @input group_id: optional - ID of the security group for the instance. EC2-Classic only.
#! @input host_id: optional - ID of the dedicated host on which the instance is running, if applicable.
#! @input image_id: optional - ID of the image used to launch the instance.
#! @input instance_id: optional - instance ID.
#! @input kernel_id: optional - kernel ID.
#! @input owner_id: optional - AWS account ID of the instance owner.
#! @input ramdisk_id: optional - RAM disk ID.
#! @input reservation_id: optional - instance's reservation ID. A reservation ID is created any time you launch an instance.
#!                                   A reservation ID has a one-to-one relationship with an instance launch request, but
#!                                   can be associated with more than one instance if you launch multiple instances using
#!                                   the same launch request. For example, if we launch one instance, we'll get one reservation
#!                                   ID. If will launch ten instances using the same launch request, we'll also get one
#!                                   reservation ID.
#! @input subnet_id: optional - subnet instance ID.
#! @input vpc_id: optional - ID of the VPC that the instance is running in.
#! @input allocation_id: optional - allocation ID returned when you allocated the Elastic IP address for your network interface.
#! @input association_id: optional - association ID returned when the network interface was associated with an IP address.
#! @input affinity: optional - affinity setting for an instance running on a dedicated host. Valid values: 'default' or 'host'.
#! @input architecture: optional - instance architecture. Valid values: '' (no architecture filtering), 'i386' or 'x86_64'.
#!                                 Default: ''
#! @input availability_zone: optional - Availability Zone of the instance.
#! @input attach_time: optional - attach time for an EBS volume mapped to the instance. Ex: '2010-09-15T17:15:20.000Z'
#! @input delete_on_termination: optional - a boolean that indicates whether the EBS volume is deleted on instance termination.
#! @input device_name: optional - device name for the EBS volume. Ex: '/dev/sdh' or 'xvdh'.
#! @input status: optional - status for the EBS volume. Valid values: '' (no status filtering), 'attaching', 'attached',
#!                           'detaching', 'detached'.
#! @input client_token: optional - idem-potency token that was provided when the instance was launched.
#! @input dns_name: optional - public DNS name of the instance.
#! @input group_name: optional - name of the security group for the instance. EC2-Classic only.
#! @input hypervisor: optional - hypervisor type of the instance. Valid values: '' (no architecture filtering), 'ovm', 'xen'.
#!                               Default: ''
#! @input iam_arn: optional - instance profile associated with the instance. Specified as an ARN.
#! @input instance_lifecycle: optional - indicates whether this is a Spot Instance or a Scheduled Instance.
#!                                       Valid values: '' (no architecture filtering), 'spot', 'scheduled'.
#! @input instance_state_code: optional -  instance state code, as a 16-bit unsigned integer. The high byte is an opaque
#!                                         internal value and should be ignored. The low byte is set based on the state
#!                                         represented. Valid values: '0' (pending), '16' (running), '32' (shutting-down),
#!                                         '48' (terminated), '64' (stopping) and '80' (stopped).
#! @input instance_state_name: optional -  instance name. Valid values: 'pending', 'running', 'shutting-down', 'terminated',
#!                                         'stopping', 'stopped'.
#! @input instance_type: optional - new server type to be used when updating the instance. The complete list of instance
#!                                  types can be found at: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html
#!                                  Ex: 't2.micro', 't2.medium', 'm3.large'.
#! @input instance_group_id: optional - ID of the security group for the instance.
#! @input instance_group_name: optional - name of the security group for the instance.
#! @input ip_address: optional - public IP address of the instance.
#! @input key_name: optional - name of the key pair used when the instance was launched.
#! @input launch_index: optional - when launching multiple instances, this is the index for the instance in the launch group.
#!                                 Ex: 0, 1, 2, and so on.
#! @input launch_time: optional - time when the instance was launched.
#! @input monitoring_state: optional - indicates whether monitoring is enabled for the instance. Valid values: 'disabled',
#!                                     'enabled'.
#! @input placement_group_name: optional - name of the placement group for the instance.
#! @input platform: optional - platform. Use 'windows' if you have Windows instances; otherwise, leave blank.
#!                             Valid values: '', 'windows'.
#! @input private_dns_name: optional - private DNS name of the instance.
#! @input private_ip_address: optional - private IP address of the instance.
#! @input product_code: optional - product code associated with the AMI used to launch the instance.
#! @input product_code_type: optional - product code type. Valid values: 'devpay', 'marketplace'.
#! @input reason: optional - reason for the current state of the instance. For e.g.: shows 'User Initiated [date]' when
#!                           user stops or terminates the instance. Similar to the state-reason-code filter.
#! @input requester_id: optional - ID of the entity that launched the instance on your behalf (for e.g.: 'AWS Management Console',
#!                                 'Auto Scaling', and so on).
#! @input root_device_name: optional - name of the root device for the instance. Ex: '/dev/sda1', '/dev/xvda'.
#! @input root_device_type: optional - type of root device that the instance uses. Valid values: 'ebs', 'instance-store'.
#! @input source_destination_check: optional - indicates whether the instance performs source/destination checking.
#!                                             A value of 'true' means that checking is enabled, and 'false' means checking
#!                                             is disabled. The value must be 'false' for the instance to perform network
#!                                             address translation (NAT) in your VPC.
#! @input spot_instance_request_id: optional - ID of the Spot instance request.
#! @input state_reason_code: optional - reason code for the state change.
#! @input state_reason_message: optional - a message that describes the state change.
#! @input tenancy: optional - tenancy of an instance. Valid values: 'dedicated', 'default', 'host'. Default: ''
#! @input virtualization_type: optional - virtualization type of the instance. Valid values: 'paravirtual', 'hvm'.
#! @input public_ip: optional - address of the Elastic IP address bound to the network interface.
#! @input ip_owner_id: optional - owner of the Elastic IP address associated with the network interface.
#! @input key_tags_string: optional - a string that contains: none, one or more tag keys separated by delimiter. The length
#!                                    of a key_tags_string should be the same as the length of value_tags_string. Default: ''
#! @input value_tags_string: optional - a string that contains: none, one or more tag values separated by delimiter. The
#!                                      length of a key_tags_string should be the same as the length of value_tags_string.
#!                                      Default: ''
#! @input network_interface_description: optional - description of the network interface.
#! @input network_interface_subnet_id: optional - ID of the subnet for the network interface.
#! @input network_interface_vpc_id: optional - ID of the VPC for the network interface.
#! @input network_interface_id: optional - ID of the network interface.
#! @input network_interface_owner_id: optional - ID of the owner of the network interface.
#! @input network_interface_availability_zone: optional - Availability Zone for the network interface.
#! @input network_interface_requester_id: optional - requester ID for the network interface.
#! @input network_interface_requester_managed: optional - indicates whether the network interface is being managed by AWS.
#! @input network_interface_status: optional - status of the network interface. Valid values: 'available', 'in-use'.
#! @input network_interface_mac_address: optional - MAC address of the network interface.
#! @input network_interface_private_dns_name: optional - private DNS name of the network interface.
#! @input network_interface_source_destination_check: optional - whether the network interface performs source/destination
#!                                                               checking. A value of true means checking is enabled, and
#!                                                               false means checking is disabled. The value must be false
#!                                                               for the network interface to perform network address
#!                                                               translation (NAT) in your VPC.
#! @input network_interface_group_id: optional - ID of a security group associated with the network interface.
#! @input network_interface_groupName: optional - name of a security group associated with the network interface.
#! @input network_interface_attachment_id: optional - ID of the interface attachment.
#! @input network_interface_instance_id: optional - ID of the instance to which the network interface is attached.
#! @input network_interface_instance_owner_id: optional - owner ID of the instance to which the network interface is attached.
#! @input network_interface_private_ip_address: optional - private IP address associated with the network interface.
#! @input network_interface_device_index: optional - device index to which the network interface is attached.
#! @input network_interface_attachment_status: optional - status of the attachment. Valid values: 'attaching', 'attached',
#!                                                        'detaching', 'detached'.
#! @input network_interface_attach_time: optional - time that the network interface was attached to an instance.
#! @input network_interface_delete_on_termination: optional - specifies whether the attachment is deleted when an instance
#!                                                            is terminated.
#! @input network_interface_addresses_primary: optional - specifies whether the IP address of the network interface is
#!                                                        the primary private IP address.
#! @input network_interface_public_ip: optional - ID of the association of an Elastic IP address with a network interface.
#! @input network_interface_ip_owner_id: optional - owner ID of the private IP address associated with the network interface.
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: the list with existing servers (instances) was successfully retrieved
#! @result FAILURE: an error occurred when trying to retrieve servers (instances) list
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.instances

operation:
  name: describe_instances_in_region

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
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get("proxy_port", "8080")}
        private: true
    - delimiter:
        default: ','
        required: false
    - region:
        default: 'us-east-1'
        required: false
    - volume_id:
        required: false
    - volumeId:
        default: ${get("volume_id", "")}
        private: true
    - group_id:
        required: false
    - groupId:
        default: ${get("group_id", "")}
        private: true
    - host_id:
        required: false
    - hostId:
        default: ${get("host_id", "")}
        private: true
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
    - kernel_id:
        required: false
    - kernelId:
        default: ${get("kernel_id", "")}
        private: true
    - owner_id:
        required: false
    - ownerId:
        default: ${get("owner_id", "")}
        private: true
    - ramdisk_id:
        required: false
    - ramdiskId:
        default: ${get("ramdisk_id", "")}
        private: true
    - reservation_id:
        required: false
    - reservationId:
        default: ${get("reservation_id", "")}
        private: true
    - subnet_id:
        required: false
    - subnetId:
        default: ${get("subnet_id", "")}
        private: true
    - vpc_id:
        required: false
    - vpcId:
        default: ${get("vpc_id", "")}
        private: true
    - allocation_id:
        required: false
    - allocationId:
        default: ${get("allocation_id", "")}
        private: true
    - association_id:
        required: false
    - associationId:
        default: ${get("association_id", "")}
        private: true
    - affinity:
        default: ''
        required: false
    - architecture:
        default: ''
        required: false
    - availability_zone:
        required: false
    - availabilityZone:
        default: ${get("availability_zone", "")}
    - attach_time:
        required: false
    - attachTime:
        default: ${get("attach_time", "")}
    - delete_on_termination:
        required: false
    - deleteOnTermination:
        default: ${get("delete_on_termination", "")}
    - device_name:
        required: false
    - deviceName:
        default: ${get("device_name", "")}
    - status:
        default: ''
        required: false
    - client_token:
        required: false
    - clientToken:
        default: ${get("client_token", "")}
    - dns_name:
        required: false
    - dnsName:
        default: ${get("dns_name", "")}
    - group_name:
        required: false
    - groupName:
        default: ${get("group_name", "")}
    - hypervisor:
        default: ''
        required: false
    - iam_arn:
        required: false
    - iamArn:
        default: ${get("iam_arn", "")}
    - instance_lifecycle:
        required: false
    - instanceLifecycle:
        default: ${get("instance_lifecycle", "")}
    - instance_state_code:
        required: false
    - instanceStateCode:
        default: ${get("instance_state_code", "")}
    - instance_state_name:
        required: false
    - instanceStateName:
        default: ${get("instance_state_name", "")}
    - instance_type:
        required: false
    - instanceType:
        default: ${get("instance_type", "")}
    - instance_group_id:
        required: false
    - instanceGroupId:
        default: ${get("instance_group_id", "")}
    - instance_group_name:
        required: false
    - instanceGroupName:
        default: ${get("instance_group_name", "")}
    - ip_address:
        required: false
    - ipAddress:
        default: ${get("ip_address", "")}
    - key_name:
        required: false
    - keyName:
        default: ${get("key_name", "")}
    - launch_index:
        required: false
    - launchIndex:
        default: ${get("launch_index", "")}
    - launch_time:
        required: false
    - launchTime:
        default: ${get("launch_time", "")}
    - monitoring_state:
        required: false
    - monitoringState:
        default: ${get("monitoring_state", "")}
    - placement_group_name:
        required: false
    - placementGroupName:
        default: ${get("placement_group_name", "")}
    - platform:
        required: false
        default: ''
    - private_dns_name:
        required: false
    - privateDnsName:
        default: ${get("private_dns_name", "")}
    - private_ip_address:
        required: false
    - privateIpAddress:
        default: ${get("private_ip_address", "")}
    - productCode:
        required: false
    - productCode:
        default: ${get("productCode", "")}
    - product_code_type:
        required: false
    - productCodeType:
        default: ${get("product_code_type", "")}
    - reason:
        required: false
        default: ''
    - requester_id:
        required: false
    - requesterId:
        default: ${get("requester_id", "")}
    - root_device_name:
        required: false
    - rootDeviceName:
        default: ${get("root_device_name", "")}
    - root_device_type:
        required: false
    - rootDeviceType:
        default: ${get("root_device_type", "")}
    - source_destination_check:
        required: false
    - sourceDestinationCheck:
        default: ${get("source_destination_check", "")}
    - spot_instance_request_id:
        required: false
    - spotInstanceRequestId:
        default: ${get("spot_instance_request_id", "")}
    - state_reason_code:
        required: false
    - stateReasonCode:
        default: ${get("state_reason_code", "")}
    - state_reason_message:
        required: false
    - stateReasonMessage:
        default: ${get("state_reason_message", "")}
    - tenancy:
        required: false
    - virtualization_type:
        required: false
    - virtualizationType:
        default: ${get("virtualization_type", "")}
    - public_ip:
        required: false
    - publicIp:
        default: ${get("public_ip", "")}
    - ip_owner_id:
        required: false
    - ipOwnerId:
        default: ${get("ip_owner_id", "")}
    - key_tags_string:
        required: false
    - keyTagsString:
        default: ${get("key_tags_string", "")}
    - value_tags_string:
        required: false
    - valueTagsString:
        default: ${get("value_tags_string", "")}
    - network_interface_description:
        required: false
    - networkInterfaceDescription:
        default: ${get("network_interface_description", "")}
    - network_interface_subnet_id:
        required: false
    - networkInterfaceSubnetId:
        default: ${get("network_interface_subnet_id", "")}
    - network_interface_vpc_id:
        required: false
    - networkInterfaceVpcId:
        default: ${get("network_interface_vpc_id", "")}
    - network_interface_id:
        required: false
    - networkInterfaceId:
        default: ${get("network_interface_id", "")}
    - network_interface_owner_id:
        required: false
    - networkInterfaceOwnerId:
        default: ${get("network_interface_owner_id", "")}
    - network_interface_availability_zone:
        required: false
    - networkInterfaceAvailabilityZone:
        default: ${get("network_interface_availability_zone", "")}
    - network_interface_requester_id:
        required: false
    - networkInterfaceRequesterId:
        default: ${get("network_interface_requester_id", "")}
    - network_interface_requester_managed:
        required: false
    - networkInterfaceRequesterManaged:
        default: ${get("network_interface_requester_managed", "")}
    - network_interface_status:
        required: false
    - networkInterfaceStatus:
        default: ${get("network_interface_status", "")}
    - network_interface_mac_address:
        required: false
    - networkInterfaceMacAddress:
        default: ${get("network_interface_mac_address", "")}
    - network_interface_private_dns_name:
        required: false
    - networkInterfacePrivateDnsName:
        default: ${get("network_interface_private_dns_name", "")}
    - network_interface_source_destination_check:
        required: false
    - networkInterfaceSourceDestinationCheck:
        default: ${get("network_interface_source_destination_check", "")}
    - network_interface_group_id:
        required: false
    - networkInterfaceGroupId:
        default: ${get("network_interface_group_id", "")}
    - network_interface_groupName:
        required: false
    - networkInterfaceGroupName:
        default: ${get("network_interface_groupName", "")}
    - network_interface_attachment_id:
        required: false
    - networkInterfaceAttachmentId:
        default: ${get("network_interface_attachment_id", "")}
    - network_interface_instance_id:
        required: false
    - networkInterfaceInstanceId:
        default: ${get("network_interface_instance_id", "")}
    - network_interface_instance_owner_id:
        required: false
    - networkInterfaceInstanceOwnerId:
        default: ${get("network_interface_instance_owner_id", "")}
    - network_interface_private_ip_address:
        required: false
    - networkInterfacePrivateIpAddress:
        default: ${get("network_interface_private_ip_address", "")}
    - network_interface_device_index:
        required: false
    - network_interface_device_index:
        default: ${get("network_interface_device_index", "")}
    - network_interface_attachment_status:
        required: false
    - networkInterfaceAttachmentStatus:
        default: ${get("network_interface_attachment_status", "")}
    - network_interface_attach_time:
        required: false
    - networkInterfaceAttachTime:
        default: ${get("network_interface_attach_time", "")}
    - network_interface_delete_on_termination:
        required: false
    - networkInterfaceDeleteOnTermination:
        default: ${get("network_interface_delete_on_termination", "")}
    - network_interface_addresses_primary:
        required: false
    - networkInterfaceAddressesPrimary:
        default: ${get("network_interface_addresses_primary", "")}
    - network_interface_public_ip:
        required: false
    - networkInterfacePublicIp:
        default: ${get("network_interface_public_ip", "")}
    - network_interface_ip_owner_id:
        required: false
    - networkInterfaceIpOwnerId:
        default: ${get("network_interface_ip_owner_id", "")}


  java_action:
    gav: 'io.cloudslang.content:score-jClouds:0.0.4'
    class_name: io.cloudslang.content.jclouds.actions.instances.DescribeInstancesAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${exception if exception in locals() else ''}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
