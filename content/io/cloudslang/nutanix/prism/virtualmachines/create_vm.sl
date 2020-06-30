#   (c) Copyright 2020 Micro Focus, L.P.
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
#! @description: Create a Virtual Machine with specified configuration.This is an asynchronous operation that results in
#!               the creation of a task object. The UUID of this task object is returned as the response of this
#!               operation. This task can be monitored by using the /tasks/poll API.
#!
#! @input hostname: The hostname for Nutanix.
#! @input port: The port to connect to Nutanix.
#!              Default: '9440'
#!              Optional
#! @input username: The username for Nutanix.
#! @input password: The password for Nutanix.
#! @input vm_name: Name of the Virtual Machine that will be created.
#! @input vm_description: The description of the Virtual Machine that will be created.
#!                        Optional
#! @input vm_memory_size: The memory amount (in GiB) attached to the virtual machine that will will be created.
#! @input num_vcpus: The number that indicates how many processors will have the virtual machine that will be created.
#! @input num_cores_per_vcpu: This is the number of cores per vCPU.
#! @input time_zone: The timezone in which the Virtual Machine will be created.
#!                   Example : 'Asia/Calcutta'
#!                   Optional
#! @input hypervisor_type: The type of hypervisor.
#!                         Example : 'ACROPOLIS'
#!                         Optional
#! @input flash_mode_enabled: State of the storage policy to pin virtual disks to the hot tier. When specified as a VM
#!                            attribute, the storage policy applies to all virtual disks of the VM unless overridden by
#!                            the same attribute specified for a virtual disk.
#!                            Default : 'false'
#!                            Optional
#! @input is_scsi_pass_through: If the value is 'true' Disks on the SCSI bus will be configured for passthrough on
#!                              platforms that support iSCSI.
#!                              Default : 'false'
#!                              Optional
#! @input is_thin_provisioned: If the value is 'true' then Virtual Machine will be created with thin provision.
#!                             Default : 'true'
#!                             Optional
#! @input is_cdrom: If the value is 'true' then Virtual Machine needs to create with CDROM otherwise Virtual Machine will
#!                  be created with Empty Disk.
#! @input is_empty_disk: If the value is 'true' then Virtual Machine will created with EmptyDisk.
#!                  Default : 'true'
#!                  Optional
#! @input device_bus: The type of Device disk.
#!                    Allowed Values: SCSI, IDE, PCI, SATA, SPAPR.
#! @input disk_label: The Label for the disk that will be created
#!                    Optional
#! @input device_index: The Index of the disk device.
#!                      Default : '0'
#!                      Optional
#! @input ndfs_filepath: The refernece ndfs file location from which the disk will be created.
#!                       Optional
#! @input source_vm_disk_uuid: The reference disk UUID from which new disk will be created.
#!                             Optional
#! @input vm_disk_minimum_size: The size of reference disk.
#!                              Default : '0'
#!                              Optional
#! @input external_disk_url: The URL of the external reference disk which will be used to create a new disk.
#!                           Optional
#! @input external_disk_size: The size of the external disk to be created.
#!                            Default : '0'
#!                            Optional
#! @input storage_container_uuid: The reference storage container UUID from which the new storage container will be
#!                                created.
#!                                Optional
#! @input vm_disk_size: The size (in GiB) of the new storage container to be created.
#!                      Default : '0'
#!                      Optional
#! @input network_uuid: The network UUID which will be attached to the Virtual Machine.
#! @input requested_ip_address: The static IP address which will be assigned to the Virtual Machine.
#!                              Optional
#! @input is_connected: If the value of this property is 'true' the network will be connected while booting the Virtual
#!                      Machine.
#!                      Optional
#! @input host_uuids: UUIDs identifying the host on which the Virtual Machine is currently running. If Virtual Machine
#!                    is powered off, then this field is empty.
#!                    Optional
#! @input agent_vm: Indicates whether the VM is an agent VM. When their host enters maintenance mode, after normal VMs
#!                  are evacuated, agent VMs are powered off. When the host is restored, agent VMs are powered on before
#!                  normal VMs are restored. In other words, agent VMs cannot be HA-protected or live migrated.
#!                  Default : 'false'
#!                  Optional
#! @input api_version: The api version for Nutanix.
#!                     Default: 'v2.0'
#!                     Optional
#! @input proxy_host: Proxy server used to access the Nutanix service.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Nutanix service.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no
#!                         trusted certification authority issued it.
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to
#!                                 "allow_all" to skip any checking. For the value "browser_compatible" the hostname
#!                                 verifier works the same way as Curl and Firefox. The hostname must match either the
#!                                 first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of
#!                                 the subject-alts. The only difference between "browser_compatible" and "strict" is
#!                                 that a wildcard (such as "*.foo.com") with "browser_compatible" matches all
#!                                 subdomains, including "a.b.foo.com".
#!                                 Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that
#!                        you expect to communicate with, or from Certificate Authorities that you trust to identify
#!                        other parties.  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is
#!                        'true' this input is ignored. Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystore
#!                        is empty, trustPassword default will be supplied.
#!                        Optional
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.
#!                         Default: '10000'
#!                         Optional
#! @input socket_timeout: The timeout for waiting for data (a maximum period inactivity between two consecutive data
#!                        packets), in seconds. A socketTimeout value of '0' represents an infinite timeout.
#!                        Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls. If
#!                    keepAlive is false, the already open connection will be used and after execution it will close
#!                    it.
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
#! @output status_code: The HTTP status code for Nutanix API request.
#! @output task_uuid: The UUID of the Task that will be created in Nutanix after submission of the API request.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.nutanix.prism.virtualmachines

operation: 
  name: create_vm
  
  inputs: 
    - hostname    
    - port:  
        required: false  
    - username    
    - password:    
        sensitive: true
    - vm_name    
    - vmName: 
        default: ${get('vm_name', '')}  
        required: false 
        private: true 
    - vm_description:  
        required: false  
    - vmDescription: 
        default: ${get('vm_description', '')}  
        required: false 
        private: true 
    - vm_memory_size    
    - vmMemorySize: 
        default: ${get('vm_memory_size', '')}  
        required: false 
        private: true 
    - num_vcpus
    - numVCPUs: 
        default: ${get('num_vcpus', '')}
        required: false 
        private: true 
    - num_cores_per_vcpu    
    - numCoresPerVCPU: 
        default: ${get('num_cores_per_vcpu', '')}  
        required: false 
        private: true
    - time_zone:
        required: false
    - timeZone: 
        default: ${get('time_zone', '')}  
        required: false 
        private: true 
    - hypervisor_type:  
        required: false  
    - hypervisorType: 
        default: ${get('hypervisor_type', '')}  
        required: false 
        private: true 
    - flash_mode_enabled:  
        required: false  
    - flashModeEnabled: 
        default: ${get('flash_mode_enabled', '')}  
        required: false 
        private: true 
    - is_scsi_pass_through:  
        required: false  
    - isSCSIPassThrough: 
        default: ${get('is_scsi_pass_through', '')}  
        required: false 
        private: true 
    - is_thin_provisioned:  
        required: false  
    - isThinProvisioned: 
        default: ${get('is_thin_provisioned', '')}  
        required: false 
        private: true 
    - is_cdrom    
    - isCDROM: 
        default: ${get('is_cdrom', '')}  
        required: false
        private: true
    - is_empty_disk:
        required: false
    - isEmptyDisk:
        default: ${get('is_empty_disk', '')}
        required: false 
        private: true 
    - device_bus    
    - deviceBus: 
        default: ${get('device_bus', '')}  
        required: false 
        private: true 
    - disk_label:  
        required: false  
    - diskLabel: 
        default: ${get('disk_label', '')}  
        required: false 
        private: true 
    - device_index:  
        required: false  
    - deviceIndex: 
        default: ${get('device_index', '')}  
        required: false 
        private: true 
    - ndfs_filepath:  
        required: false  
    - ndfsFilepath: 
        default: ${get('ndfs_filepath', '')}  
        required: false 
        private: true 
    - source_vm_disk_uuid:  
        required: false  
    - sourceVMDiskUUID: 
        default: ${get('source_vm_disk_uuid', '')}  
        required: false 
        private: true 
    - vm_disk_minimum_size:  
        required: false  
    - vmDiskMinimumSize: 
        default: ${get('vm_disk_minimum_size', '')}  
        required: false 
        private: true 
    - external_disk_url:  
        required: false  
    - externalDiskUrl: 
        default: ${get('external_disk_url', '')}  
        required: false 
        private: true 
    - external_disk_size:  
        required: false  
    - externalDiskSize: 
        default: ${get('external_disk_size', '')}  
        required: false 
        private: true 
    - storage_container_uuid:  
        required: false  
    - storageContainerUUID: 
        default: ${get('storage_container_uuid', '')}  
        required: false 
        private: true 
    - vm_disk_size:  
        required: false  
    - vmDiskSize: 
        default: ${get('vm_disk_size', '')}  
        required: false 
        private: true 
    - network_uuid    
    - networkUUID: 
        default: ${get('network_uuid', '')}  
        required: false 
        private: true 
    - requested_ip_address:  
        required: false  
    - requestedIPAddress: 
        default: ${get('requested_ip_address', '')}  
        required: false 
        private: true 
    - is_connected:  
        required: false  
    - isConnected: 
        default: ${get('is_connected', '')}  
        required: false 
        private: true 
    - host_uuids:
        required: false  
    - hostUUIDs: 
        default: ${get('host_uuids', '')}
        required: false 
        private: true 
    - agent_vm:  
        required: false  
    - agentVM: 
        default: ${get('agent_vm', '')}  
        required: false 
        private: true 
    - api_version:  
        required: false  
    - apiVersion: 
        default: ${get('api_version', '')}  
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
    - trust_all_roots:  
        required: false  
    - trustAllRoots:
        default: ${get('trust_all_roots', '')}
        required: false 
        private: true 
    - x_509_hostname_verifier:  
        required: false  
    - x509HostnameVerifier:
        default: ${get('x_509_hostname_verifier', '')}
        required: false 
        private: true 
    - trust_keystore:  
        required: false  
    - trustKeystore: 
        default: ${get('trust_keystore', '')}  
        required: false 
        private: true 
    - trust_password:  
        required: false  
        sensitive: true
    - trustPassword: 
        default: ${get('trust_password', '')}  
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
    gav: 'io.cloudslang.content:cs-nutanix-prism:1.0.0-RC13'
    class_name: 'io.cloudslang.content.nutanix.prism.actions.virtualmachines.CreateVM'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - exception: ${get('exception', '')} 
    - status_code: ${get('statusCode', '')} 
    - task_uuid: ${get('taskUUID', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
