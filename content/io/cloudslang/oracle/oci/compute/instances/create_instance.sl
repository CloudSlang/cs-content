#   (c) Copyright 2022 Micro Focus, L.P.
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
#! @description: Creates a new instance in the specified compartment and availability domain.
#!
#! @input tenancy_ocid: Oracle creates a tenancy for your company, which is a secure and isolated partition where you
#!                      can create, organize, and administer your cloud resources. This is the ID of the tenancy.
#! @input user_ocid: The ID of an individual employee or system that needs to manage or use your company’s Oracle Cloud
#!                   Infrastructure resources.
#! @input finger_print: The finger print of the public key generated for the OCI account.
#! @input private_key_file: The path to the private key file on the machine where the worker is.
#! @input compartment_ocid: Compartments are a fundamental component of the Oracle Cloud Infrastructure for organizing
#!                          and isolating your cloud resources. This is the ID of the compartment.
#! @input api_version: Version of the API of OCI.
#!                     Default: '20160918'
#!                     Optional
#! @input region: The region's name.
#!                Example: ap-sydney-1, ap-melbourne-1, sa-saopaulo-1, etc.
#! @input availability_domain: The availability domain of the instance.
#! @input shape: The shape of an instance. The shape determines the number of CPUs, amount of memory, and other
#!               resources allocated to the instance.
#!               Example: VM.Standard2.1,VM.Standard2.2, etc.
#! @input subnet_id: The OCID of the subnet in which the VNIC will be created.
#! @input source_type: The source type for the instance. Use image when specifying the image OCID. Use bootVolume when
#!                     specifying the boot volume OCID.
#! @input image_id: The OCID of the image used to boot the instance. If the sourceType is 'image', then this value is
#!                  required.
#!                  Optional
#! @input boot_volume_size_in_gbs: The size of the boot volume in GBs. Minimum value is 50 GB and maximum value is
#!                                  16384 GB (16TB).
#!                                  Optional
#! @input kms_key_id: The OCID of the Key Management Service key that is assigned as the master encryption key for the
#!                    boot volume.
#!                    Optional
#! @input boot_volume_id: The OCID of the boot volume used to boot the instance. If the sourceType is 'bootVolume', then
#!                        this value is required.
#!                        Optional
#! @input dedicated_vm_host_id: The OCID of the dedicated VM host.
#!                              Optional
#! @input display_name: A user-friendly name that does not have to be unique and changeable. Ex: My bare metal instance
#!                      Optional
#! @input defined_tags: Defined tags for a resource. Each key is predefined and scoped to a namespace.
#!                      Example: {"Operations": {"CostCenter": "42"}}
#!                      Optional
#! @input freeform_tags: Free-form tags for a resource. Each tag is a simple key-value pair with no predefined name,
#!                       type, or namespace.
#!                       Example: {"Department": "Finance"}
#!                       Optional
#! @input ssh_authorized_keys: Provide one or more public SSH keys  for the default user on the instance. Use a newline
#!                             character to separate multiple keys.
#!                             Optional
#! @input userdata: Provide your own base64-encoded data to be used by Cloud-Init to run custom scripts or provide
#!                  custom Cloud-Init configuration.
#!                  Optional
#! @input extended_metadata: Additional metadata key/value pairs that you provide. They serve the same purpose and
#!                           functionality as fields in the 'metadata' object.
#!                           They are distinguished from 'metadata'
#!                           fields in that these can be nested JSON objects (whereas 'metadata' fields are
#!                           string/string maps only).
#!                           Optional
#! @input launch_mode: Specifies the configuration mode for launching virtual machine (VM) instances. The configuration
#!                     modes are:
#!                     NATIVE - VM instances launch with iSCSI boot and VFIO devices. The default value for
#!                     Oracle-provided images.
#!                     EMULATED - VM instances launch with emulated devices, such as the E1000
#!                     network driver and emulated SCSI disk controller.
#!                     PARAVIRTUALIZED - VM instances launch with
#!                     paravirtualized devices using virtio drivers.
#!                     CUSTOM - VM instances launch with custom
#!                     configuration settings specified in the LaunchOptions parameter.
#!                     Optional
#! @input fault_domain: A fault domain is a grouping of hardware and infrastructure within an availability domain. Each
#!                      availability domain contains three fault domains. Fault domains let you distribute your
#!                      instances so that they are not on the same physical hardware within a single availability
#!                      domain. A hardware failure or Compute hardware maintenance that affects one fault domain does
#!                      not affect instances in other fault domains.
#!                      If you do not specify the fault domain, the system
#!                      selects one for you. 
#!                      Optional
#! @input is_pv_encryption_in_transit_enabled: Whether to enable in-transit encryption for the data volume's
#!                                             paravirtualized attachment.
#!                                             Default: 'false'
#!                                             Optional
#! @input ipxe_script: When a bare metal or virtual machine instance boots, the iPXE firmware that runs on the instance
#!                     is configured to run an iPXE script to continue the boot process.
#!                     If you want more control over
#!                     the boot process, you can provide your own custom iPXE script that will run when the instance
#!                     boots; however, you should be aware that the same iPXE script will run every time an instance
#!                     boots and not only after the initial LaunchInstance call.
#!                     Optional
#! @input vnic_display_name: A user-friendly name for the VNIC that does not have to be unique.
#!                           Optional
#! @input hostname_label: The hostname for the VNIC's primary private IP. Used for DNS. The value is the hostname
#!                        portion of the primary private IP's fully qualified domain name.
#!                        Optional
#! @input assign_public_ip: Whether the VNIC should be assigned a public IP address. Defaults to whether the subnet is
#!                          public or private.
#!                          Optional
#! @input vnic_defined_tags: Defined tags for VNIC. Each key is predefined and scoped to a namespace.
#!                           Example: {"Operations": {"CostCenter": "42"}}
#!                           Optional
#! @input vnic_freeform_tags: Free-form tags for VNIC. Each tag is a simple key-value pair with no predefined name,
#!                            type, or namespace.
#!                            Example: {"Department": "Finance"}
#!                            Optional
#! @input network_security_group_ids: A list of the OCIDs of the network security groups (NSGs) to add the VNIC to.
#!                                    Maximum allowed security groups are 5
#!                                    Example: [nsg1,nsg2]
#!                                    Optional
#! @input private_ip: A private IP address of your choice to assign to the VNIC. Must be an available IP address within
#!                    the subnet's CIDR. If you don't specify a value, Oracle automatically assigns a private IP address
#!                    from the subnet. This is the VNIC's primary private IP address.
#!                    Optional
#! @input skip_source_dest_check: Whether the source/destination check is disabled on the VNIC.
#!                                Default: 'false'
#!                                Optional
#! @input ocpus: The total number of OCPUs available to the instance.
#!               Optional
#! @input boot_volume_type: Emulation type for volume.
#!                          ISCSI - ISCSI attached block storage device.
#!                          SCSI - Emulated SCSI disk.
#!                          IDE - Emulated IDE disk.
#!                          VFIO - Direct attached Virtual Function storage. This is the
#!                          default option for Local data volumes on Oracle provided images.
#!                          PARAVIRTUALIZED -
#!                          Paravirtualized disk. This is the default for Boot Volumes and Remote Block Storage volumes
#!                          on Oracle provided images.
#!                          Optional
#! @input firmware: Firmware used to boot VM. Select the option that matches your operating system.
#!                  BIOS - Boot VM using
#!                  BIOS style firmware. This is compatible with both 32 bit and 64 bit operating systems that boot
#!                  using MBR style bootloaders.
#!                  UEFI_64 - Boot VM using UEFI style firmware compatible with 64 bit
#!                  operating systems. This is the default for Oracle provided images.
#!                  Optional
#! @input is_consistent_volume_naming_enabled: Whether to enable consistent volume naming feature.
#!                                             Default: 'false'
#!                                             Optional
#! @input network_type: Emulation type for the physical network interface card (NIC).
#!                      E1000 - Emulated Gigabit ethernet
#!                      controller. Compatible with Linux e1000 network driver.
#!                      VFIO - Direct attached Virtual Function
#!                      network controller. This is the networking type when you launch an instance using
#!                      hardware-assisted (SR-IOV) networking.
#!                      PARAVIRTUALIZED - VM instances launch with
#!                      paravirtualized devices using virtio drivers.
#!                      Optional
#! @input remote_data_volume_type: Emulation type for volume.
#!                                 ISCSI - ISCSI attached block storage device.
#!                                 SCSI -
#!                                 Emulated SCSI disk.
#!                                 IDE - Emulated IDE disk.
#!                                 VFIO - Direct attached Virtual Function
#!                                 storage. This is the default option for Local data volumes on Oracle provided
#!                                 images.
#!                                 PARAVIRTUALIZED - Paravirtualized disk.This is the default for Boot Volumes
#!                                 and Remote Block Storage volumes on Oracle provided images.
#!                                 Optional
#! @input is_management_disabled: Whether the agent running on the instance can run all the available management
#!                                plugins.
#!                                Default: 'false'
#!                                Optional
#! @input is_monitoring_disabled: Whether the agent running on the instance can gather performance metrics and monitor
#!                                the instance
#!                                Default: 'false'
#!                                Optional
#! @input proxy_host: Proxy server used to access the OCI.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the OCI.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.
#!                         Default: '10000'
#!                         Optional
#! @input socket_timeout: The timeout for waiting for data (a maximum period of inactivity between two consecutive data
#!                        packets), in seconds. A socketTimeout value of '0' represents an infinite timeout.
#!                        Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls. If
#!                    keepAlive is false, an existing open connection is used and the connection will be closed after
#!                    execution.
#!                    Default: 'true'
#!                    Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.
#!                                   Default: '2'
#!                                   Optional
#! @input connections_max_total: The maximum limit of connections in total.
#!                               Default: '20'
#!                               Optional
#!
#! @output return_result: If successful, returns the complete API response. In case of an error this output will contain
#!                        the error message.
#! @output exception: An error message in case there was an error while executing the request.
#! @output instance_id: The OCID of the instance.
#! @output instance_name: The instance name.
#! @output status_code: The HTTP status code for OCI API request.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.oracle.oci.compute.instances

operation:
  name: create_instance

  inputs: 
    - tenancy_ocid    
    - tenancyOcid: 
        default: ${get('tenancy_ocid', '')}
        private: true 
    - user_ocid    
    - userOcid: 
        default: ${get('user_ocid', '')}
        private: true 
    - finger_print:    
        sensitive: true
    - fingerPrint: 
        default: ${get('finger_print', '')}
        private: true 
        sensitive: true
    - private_key_file
    - privateKeyFile:
        default: ${get('private_key_file', '')}
        private: true
    - compartment_ocid    
    - compartmentOcid: 
        default: ${get('compartment_ocid', '')}
        private: true 
    - api_version:  
        required: false  
    - apiVersion: 
        default: ${get('api_version', '')}  
        required: false 
        private: true 
    - region    
    - availability_domain
    - availabilityDomain:
        default: ${get('availability_domain', '')}
        private: true 
    - shape    
    - subnet_id    
    - subnetId: 
        default: ${get('subnet_id', '')}
        private: true 
    - source_type:
        required: false
    - sourceType: 
        default: ${get('source_type', '')}  
        required: false 
        private: true 
    - image_id:  
        required: false  
    - imageId: 
        default: ${get('image_id', '')}  
        required: false 
        private: true 
    - boot_volume_size_in_gbs:
        required: false  
    - bootVolumeSizeInGBs: 
        default: ${get('boot_volume_size_in_gbs', '')}
        required: false 
        private: true 
    - kms_key_id:  
        required: false  
    - kmsKeyId: 
        default: ${get('kms_key_id', '')}  
        required: false 
        private: true 
    - boot_volume_id:  
        required: false  
    - bootVolumeId: 
        default: ${get('boot_volume_id', '')}  
        required: false 
        private: true 
    - dedicated_vm_host_id:  
        required: false  
    - dedicatedVmHostId: 
        default: ${get('dedicated_vm_host_id', '')}  
        required: false 
        private: true 
    - display_name:  
        required: false  
    - displayName: 
        default: ${get('display_name', '')}  
        required: false 
        private: true 
    - defined_tags:  
        required: false  
    - definedTags: 
        default: ${get('defined_tags', '')}  
        required: false 
        private: true 
    - freeform_tags:  
        required: false  
    - freeformTags: 
        default: ${get('freeform_tags', '')}  
        required: false 
        private: true 
    - ssh_authorized_keys:  
        required: false  
        sensitive: true
    - sshAuthorizedKeys: 
        default: ${get('ssh_authorized_keys', '')}  
        required: false 
        private: true 
        sensitive: true
    - userdata:  
        required: false  
    - extended_metadata:  
        required: false  
    - extendedMetadata: 
        default: ${get('extended_metadata', '')}  
        required: false 
        private: true 
    - launch_mode:  
        required: false  
    - launchMode: 
        default: ${get('launch_mode', '')}  
        required: false 
        private: true 
    - fault_domain:  
        required: false  
    - faultDomain: 
        default: ${get('fault_domain', '')}  
        required: false 
        private: true 
    - is_pv_encryption_in_transit_enabled:  
        required: false  
    - isPvEncryptionInTransitEnabled: 
        default: ${get('is_pv_encryption_in_transit_enabled', '')}  
        required: false 
        private: true 
    - ipxe_script:  
        required: false  
    - ipxeScript: 
        default: ${get('ipxe_script', '')}  
        required: false 
        private: true 
    - vnic_display_name:  
        required: false  
    - vnicDisplayName: 
        default: ${get('vnic_display_name', '')}  
        required: false 
        private: true 
    - hostname_label:  
        required: false  
    - hostnameLabel: 
        default: ${get('hostname_label', '')}  
        required: false 
        private: true 
    - assign_public_ip:  
        required: false  
    - assignPublicIP: 
        default: ${get('assign_public_ip', '')}  
        required: false 
        private: true 
    - vnic_defined_tags:  
        required: false  
    - vnicDefinedTags: 
        default: ${get('vnic_defined_tags', '')}  
        required: false 
        private: true 
    - vnic_freeform_tags:  
        required: false  
    - vnicFreeformTags: 
        default: ${get('vnic_freeform_tags', '')}  
        required: false 
        private: true 
    - network_security_group_ids:  
        required: false  
    - networkSecurityGroupIds: 
        default: ${get('network_security_group_ids', '')}  
        required: false 
        private: true 
    - private_ip:  
        required: false  
    - privateIP: 
        default: ${get('private_ip', '')}  
        required: false 
        private: true 
    - skip_source_dest_check:  
        required: false  
    - skipSourceDestCheck: 
        default: ${get('skip_source_dest_check', '')}  
        required: false 
        private: true 
    - ocpus:  
        required: false  
    - boot_volume_type:  
        required: false  
    - bootVolumeType: 
        default: ${get('boot_volume_type', '')}  
        required: false 
        private: true 
    - firmware:  
        required: false  
    - is_consistent_volume_naming_enabled:  
        required: false  
    - isConsistentVolumeNamingEnabled: 
        default: ${get('is_consistent_volume_naming_enabled', '')}  
        required: false 
        private: true 
    - network_type:  
        required: false  
    - networkType: 
        default: ${get('network_type', '')}  
        required: false 
        private: true 
    - remote_data_volume_type:  
        required: false  
    - remoteDataVolumeType: 
        default: ${get('remote_data_volume_type', '')}  
        required: false 
        private: true 
    - is_management_disabled:  
        required: false  
    - isManagementDisabled: 
        default: ${get('is_management_disabled', '')}  
        required: false 
        private: true 
    - is_monitoring_disabled:  
        required: false  
    - isMonitoringDisabled: 
        default: ${get('is_monitoring_disabled', '')}  
        required: false 
        private: true 
    - proxy_host:  
        required: false  
    - proxyHost: 
        default: ${get('proxy_host', '')}  
        required: false 
        private: true 
    - proxy_port:  
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
        required: false 
        private: true 
        sensitive: true
    - connect_timeout:  
        required: false  
    - connectTimeout: 
        default: ${get('connect_timeout', '')}  
        required: false 
        private: true 
    - socket_timeout:  
        required: false  
    - socketTimeout: 
        default: ${get('socket_timeout', '')}  
        required: false 
        private: true 
    - keep_alive:  
        required: false  
    - keepAlive: 
        default: ${get('keep_alive', '')}  
        required: false 
        private: true 
    - connections_max_per_route:  
        required: false  
    - connectionsMaxPerRoute: 
        default: ${get('connections_max_per_route', '')}  
        required: false 
        private: true 
    - connections_max_total:  
        required: false  
    - connectionsMaxTotal: 
        default: ${get('connections_max_total', '')}  
        required: false 
        private: true 

  java_action: 
    gav: 'io.cloudslang.content:cs-oracle-cloud:1.0.2'
    class_name: 'io.cloudslang.content.oracle.oci.actions.instances.CreateInstance'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - exception: ${get('exception', '')} 
    - instance_id: ${get('instance_id', '')}
    - instance_name: ${get('instance_name', '')}
    - status_code: ${get('statusCode', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
