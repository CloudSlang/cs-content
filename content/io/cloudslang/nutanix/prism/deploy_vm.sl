#   Copyright 2024 Open Text
#   This program and the accompanying materials
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
#! @description: This workflow deploys a virtual machine with specified configuration.
#!
#! @input hostname: The hostname for Nutanix Prism.
#! @input port: The port to connect to Nutanix Prism.
#!              Default: '9440'
#!              Optional
#! @input username: The username for Nutanix Prism.
#! @input password: The password for Nutanix Prism.
#! @input vm_name: Name of the virtual machine.
#! @input vm_description: The description of the virtual machine.
#!                        Optional
#! @input vm_memory_size: The memory amount (in GiB) attached to the virtual machine.
#! @input num_vcpus: The number of processors of the virtual machine.
#! @input num_cores_per_vcpu: The number of cores per vCPU of the virtual machine.
#! @input is_cdrom: If the value is 'true' then virtual machine creates with CD-ROM, if the value is 'false' virtual
#!                  machine creates with empty disk.
#! @input device_bus: The device bus for the virtual disk device.
#!                    Valid values: 'sata, scsi, ide, pci, spapr'.
#! @input network_uuid: The network UUID which will be attached to the virtual machine.
#! @input time_zone: The timezone for the VM's hardware clock. Any updates to the timezone will be applied during the
#!                   next VM power cycle
#!                   Default : 'UTC'
#!                   Optional
#! @input hypervisor_type: The type of hypervisor.
#!                         Example : 'ACROPOLIS'
#!                         Optional
#! @input flash_mode_enabled: State of the storage policy to pin virtual disks to the hot tier. When specified as a VM
#!                            attribute, the storage policy applies to all virtual disks of the VM unless overridden by
#!                            the same attribute specified for a virtual disk.
#!                            Default : 'false'
#!                            Optional
#! @input is_scsi_pass_through: Whether the SCSI disk should be attached in passthrough mode to pass all SCSI commands
#!                              directly to Stargate via iSCSI.
#!                              Default : 'true'
#!                              Optional
#! @input is_thin_provisioned: If the value is 'true' then virtual machine will be created with thin provision.
#!                             Default : 'false'
#!                             Optional
#! @input is_empty_disk: If the value is 'true' then virtual machine creates with an empty disk.
#!                       Default : 'true'
#!                       Optional
#! @input disk_label: The Label for the disk.
#!                    Optional
#! @input device_index: The index of the disk device.
#!                      Default : '0'
#!                      Optional
#! @input ndfs_filepath: The reference ndfs file location from which the disk creates.
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
#! @input storage_container_uuid: The reference storage container UUID on which disk will be created.
#!                                created.
#!                                Optional
#! @input vm_disk_size: The size of disk in GiB.
#!                      Default : '0'
#!                      Optional
#! @input requested_ip_address: The static IP address which assigns to the virtual machine.
#!                              Optional
#! @input is_connected: If the value of this property is 'true' the network will be connected while booting the virtual
#!                      machine.
#!                      Optional
#! @input host_uuids: The UUIDs identifying the host on which the virtual machine is currently running. If virtual
#!                    machine is powered off, then this field is empty.
#!                    Optional
#! @input agent_vm: Indicates whether the VM is an agent VM. When their host enters maintenance mode, after normal VMs
#!                  are evacuated, agent VMs are powered off. When the host is restored, agent VMs are powered on before
#!                  normal VMs are restored. In other words, agent VMs cannot be HA-protected or live migrated.
#!                  Default : 'false'
#!                  Optional
#! @input api_version: The api version for Nutanix Prism.
#!                     Default: 'v2.0'
#!                     Optional
#! @input proxy_host: Proxy server used to access the Nutanix Prism service.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Nutanix Prism service.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server username.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if it
#!                         is not issued by a trusted certification authority.
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to
#!                                 "allow_all" to skip any checking. For the value "browser_compatible", the hostname
#!                                 verifier works the same way as Curl and Firefox. The hostname must match either the
#!                                 first CN, or any of the subject-alts. A wildcard can occur in the CN and in any of
#!                                 the subject-alts. The only difference between "browser_compatible" and "strict" is
#!                                 that a wildcard (such as "*.foo.com") with "browser_compatible" matches all
#!                                 subdomains, including "a.b.foo.com".
#!                                 Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that
#!                        you expect to communicate with, or from certificate authorities that you trust to identify
#!                        other parties. If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is
#!                        'true', this input is ignored. Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystore
#!                        is empty, trustPassword default will be supplied.
#!                        Optional
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.
#!                         Default: '10000'
#!                         Optional
#! @input socket_timeout: The timeout for waiting for data (a maximum period of inactivity between two consecutive data
#!                        packets), in seconds. A socketTimeout value of '0' represents an infinite timeout.
#!                        Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls. If
#!                    keepAlive is false,an existing open connection will be used and will be closed after execution.
#!                    Default: 'true'
#!                    Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.
#!                                   Default: '2'
#!                                   Optional
#! @input connections_max_total: The maximum limit of connections in total.
#!                               Default: '20'
#!                               Optional
#!
#! @output vm_uuid: The UUID of the virtual machine.
#! @output ip_address: An IP address/es of the virtual machine.
#! @output mac_address: The MAC address/es of the virtual machine.
#! @output power_state: The power state of the virtual machine.
#! @output vm_disk_uuid: The UUID of the disk attached to the virtual machine.
#! @output vm_storage_container_uuid: The UUID of the storage containers of the virtual machine.
#! @output vm_logical_timestamp: The virtual logical timestamp of the virtual machine.
#! @output return_result: If successful, returns the complete API response. In case of an error this output will contain
#!                        the error message.
#!
#! @result FAILURE: There was an error while executing the request.
#! @result SUCCESS: The request was successfully executed.
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
    - is_cdrom
    - device_bus
    - network_uuid
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
    - is_empty_disk:
        required: false
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
            - is_empty_disk: '${is_empty_disk}'
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
          - FAILURE: on_failure
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
          - task_status
          - return_result
        navigate:
          - SUCCESS: is_task_status_succeeded
          - FAILURE: on_failure
    - is_task_status_succeeded:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${task_status}'
            - second_string: Succeeded
        publish: []
        navigate:
          - SUCCESS: get_vm_uuid
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
          - FAILURE: on_failure
    - get_vm_uuid:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result}'
            - json_path: 'entity_list[0].entity_id'
        publish:
          - vm_uuid: '${return_result}'
        navigate:
          - SUCCESS: strip_characters_from_vm_uuid
          - FAILURE: on_failure
    - strip_characters_from_vm_uuid:
        do:
          io.cloudslang.base.strings.remove:
            - origin_string: '${vm_uuid}'
            - text: '"'
        publish:
          - vm_uuid: '${new_string}'
        navigate:
          - SUCCESS: get_vm_details
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
extensions:
  graph:
    steps:
      create_vm:
        x: 45
        'y': 84
        navigate:
          2a6bff69-14fc-77fe-7fb9-049f86ebc546:
            vertices:
              - x: 129
                'y': 113
            targetId: get_task_details
            port: SUCCESS
      get_task_details:
        x: 191
        'y': 83
      is_task_status_succeeded:
        x: 390
        'y': 68
      iterate_for_task_status:
        x: 520
        'y': 250
        navigate:
          58813467-214a-55e4-1797-94d36bf55626:
            targetId: b4223651-2f25-808f-a7c7-92225676f7b5
            port: FAILURE
          e29a5996-81b5-43bc-7a4a-a7c247f6d0d0:
            targetId: b4223651-2f25-808f-a7c7-92225676f7b5
            port: NO_MORE
      wait_for_task_status_success:
        x: 201
        'y': 244
        navigate:
          23fab15a-236e-b2cd-d72e-ef004b75b23b:
            targetId: b4223651-2f25-808f-a7c7-92225676f7b5
            port: FAILURE
      get_vm_details:
        x: 798
        'y': 88
        navigate:
          e91a841a-df29-f56e-f2b4-bae56c8765e3:
            targetId: a75904d6-f6de-13c9-4949-04568d5813d3
            port: SUCCESS
      get_vm_uuid:
        x: 509
        'y': 83
      strip_characters_from_vm_uuid:
        x: 655
        'y': 84
    results:
      FAILURE:
        b4223651-2f25-808f-a7c7-92225676f7b5:
          x: 193
          'y': 416
      SUCCESS:
        a75904d6-f6de-13c9-4949-04568d5813d3:
          x: 947
          'y': 88
