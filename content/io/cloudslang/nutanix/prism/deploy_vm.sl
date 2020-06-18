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
#! @description: Deploy a Virtual Machine with specified configuration.
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
#! @input hypervisor_type: The type hypervisor.
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
#! @input is_empty: If the value is 'true' then Virtual Machine will created with EmptyDisk.
#!                  Default : 'true'
#!                  Optional
#! @input device_bus: The type of Device disk.
#!                    Allowed Values: 'SCSI, IDE, PCI, SATA, SPAPR'.
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
#! @output vm_uuid: UUID of the Virtual Machine.
#! @output ip_address: IP Address/es of the Virtual Machine.
#! @output mac_address: MAC Address/es of the Virtual Machine.
#! @output power_state: Current Power state of the Virtual Machine.
#! @output vm_disk_uuid: UUID of the disk attached to the Virtual Machine.
#! @output vm_storage_container_uuid: UUID of the storage container of the Virtual Machine.
#! @output vm_logical_timestamp: The logical timestamp of the Virtual Machine.
#! @output return_result: If successful, returns the complete API response. In case of an error this output will contain
#!                        the error message.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!
#!!#
########################################################################################################################
namespace: io.cloudslang.nutanix.prism
flow:
  name: deploy_vm
  inputs:
    - hostname
    - port:
        required: false
    - username
    - password:
        sensitive: true
    - vm_name
    - vm_description:
        required: false
    - vm_memory_size
    - num_vcpus
    - num_cores_per_vcpu
    - time_zone:
        required: false
    - hypervisor_type:
        required: false
    - flash_mode_enabled:
        required: false
    - is_scsi_pass_through:
        required: false
    - is_thin_provisioned:
        required: false
    - is_cdrom
    - is_empty:
        required: false
    - device_bus
    - disk_label:
        required: false
    - device_index:
        required: false
    - ndfs_filepath:
        required: false
    - source_vm_disk_uuid:
        required: false
    - vm_disk_minimum_size:
        required: false
    - external_disk_url:
        required: false
    - external_disk_size:
        required: false
    - storage_container_uuid:
        required: false
    - vm_disk_size:
        required: false
    - network_uuid
    - requested_ip_address:
        required: false
    - is_connected:
        required: false
    - host_uuids:
        required: false
    - agent_vm:
        required: false
    - api_version:
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
    - trust_all_roots:
        required: false
    - x_509_hostname_verifier:
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - connect_timeout:
        required: false
    - socket_timeout:
        required: false
    - keep_alive:
        required: false
    - connections_max_per_route:
        required: false
    - connections_max_total:
        required: false
  workflow:
    - create_vm:
        do:
          io.cloudslang.nutanix.prism.virtualmachines.create_vm:
            - hostname: '${hostname}'
            - port: '${port}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - vm_name: '${vm_name}'
            - vm_description: '${vm_description}'
            - vm_memory_size: '${vm_memory_size}'
            - num_vcpus: '${num_vcpus}'
            - num_cores_per_vcpu: '${num_cores_per_vcpu}'
            - time_zone: '${time_zone}'
            - hypervisor_type: '${hypervisor_type}'
            - flash_mode_enabled: '${flash_mode_enabled}'
            - is_scsi_pass_through: '${is_scsi_pass_through}'
            - is_thin_provisioned: '${is_thin_provisioned}'
            - is_cdrom: '${is_cdrom}'
            - is_empty: '${is_empty}'
            - device_bus: '${device_bus}'
            - disk_label: '${disk_label}'
            - device_index: '${device_index}'
            - ndfs_filepath: '${ndfs_filepath}'
            - source_vm_disk_uuid: '${source_vm_disk_uuid}'
            - vm_disk_minimum_size: '${vm_disk_minimum_size}'
            - external_disk_url: '${external_disk_url}'
            - external_disk_size: '${external_disk_size}'
            - storage_container_uuid: '${storage_container_uuid}'
            - vm_disk_size: '${vm_disk_size}'
            - network_uuid: '${network_uuid}'
            - requested_ip_address: '${requested_ip_address}'
            - is_connected: '${is_connected}'
            - host_uuids: '${host_uuids}'
            - agent_vm: '${agent_vm}'
            - api_version: '${api_version}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
        publish:
          - task_uuid
        navigate:
          - SUCCESS: get_task_details
          - FAILURE: FAILURE
    - get_task_details:
        do:
          io.cloudslang.nutanix.prism.tasks.get_task_details:
            - hostname: '${hostname}'
            - port: '${port}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - task_uuid: '${task_uuid}'
            - api_version: '${api_version}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
        publish:
          - vm_uuid
          - task_status
          - return_result
        navigate:
          - SUCCESS: is_task_status_succeeded
          - FAILURE: FAILURE
    - is_task_status_succeeded:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${task_status}'
            - second_string: Succeeded
        publish: []
        navigate:
          - SUCCESS: get_vm_details
          - FAILURE: iterate_for_task_status
    - iterate_for_task_status:
        do:
          io.cloudslang.nutanix.prism.utils.counter:
            - from: '1'
            - to: '30'
            - increment_by: '1'
        navigate:
          - HAS_MORE: wait_for_task_status_success
          - NO_MORE: FAILURE
          - FAILURE: FAILURE
    - wait_for_task_status_success:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '10'
        navigate:
          - SUCCESS: get_task_details
          - FAILURE: FAILURE
    - get_vm_details:
        do:
          io.cloudslang.nutanix.prism.virtualmachines.get_vm_details:
            - hostname: '${hostname}'
            - port: '${port}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - vm_uuid: '${vm_uuid}'
            - api_version: '${api_version}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
        publish:
          - vm_name
          - ip_address
          - mac_address
          - power_state
          - vm_disk_uuid
          - storage_container_uuid
          - vm_logical_timestamp
          - return_result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - vm_uuid: '${vm_uuid}'
    - ip_address: '${ip_address}'
    - mac_address: '${mac_address}'
    - power_state: '${power_state}'
    - vm_disk_uuid: '${vm_disk_uuid}'
    - vm_storage_container_uuid: '${storage_container_uuid}'
    - vm_logical_timestamp: '${vm_logical_timestamp}'
    - return_result: '${return_result}'
  results:
    - FAILURE
    - SUCCESS
