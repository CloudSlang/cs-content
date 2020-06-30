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
#! @description: This workflow attaches disks to virtual machine.A disk drive may either be a regular disk drive, or
#!                 a CD-ROM drive. Only CD-ROM drives may be empty.
#!
#! @input hostname: The hostname for Nutanix Prism.
#! @input port: The port to connect to Nutanix Prism.
#!              Default: '9440'
#!              Optional
#! @input username: The username for Nutanix Prism.
#! @input password: The password for Nutanix Prism.
#! @input vm_uuid: The UUID of the virtual machine.
#! @input is_cdrom_list: Whether disk drive is CD-ROM drive or disk drive. If multiple disks needs to attach to the
#!                       virtual machine, add comma separated boolean values.
#!                       Example: To create 2 CD-ROM dives need to provide input value as 'true,true'.
#! @input is_empty_disk_list: Whether the drive should be empty. This field only applies to CD-ROM drives, otherwise it
#!                            is ignored. If multiple empty CD-ROM disks needs to attach to the virtual machine, add
#!                            comma separated boolean values.
#!                            Example: To create 2 empty CD-ROM dives need to provide input value as 'true,true'.
#!                            Optional
#! @input device_bus_list: The device bus List. List the device buses in the same  order that the disk UUIDs are listed,
#!                         separated by commas.
#!                         Valid values: 'sata, scsi, ide, pci, spapr'.
#!                         Optional
#! @input device_index_list: The device indices list. List the device indices in the same order that the disk UUIDs are
#!                           listed, separated by commas.
#!                           Optional
#! @input source_vm_disk_uuid_list: The source VM disk UUID List. If multiple disks need to be attached to the virtual
#!                                  machine, add comma separated UUIDs.
#!                                  Optional
#! @input vm_disk_minimum_size_list: The minimum size of the disk. If multiple disks need to be attached to the virtual
#!                                   machine, add comma separated disk sizes in GiB.
#!                                   Optional
#! @input ndfs_filepath_list: NDFS path to existing virtual disk. List the path in the same order as of isCDROM is
#!                            listed, separated by commas.
#!                            Optional
#! @input device_disk_size_list: The size of the each disk in GiB, to be attached to the VM.
#!                               Optional
#! @input storage_container_uuid_list: The storage container UUID in which each disk is created.
#!                                     Optional
#! @input is_scsi_pass_through_list: Whether the SCSI disk should be attached in passthrough mode to pass all SCSI
#!                                   commands directly to Stargate via iSCSI. Provide a list of comma separated boolean
#!                                   values.
#!                                   Optional
#! @input is_thin_provisioned_list: If the value is 'true' then virtual machine creates with thin provision. Provide a
#!                                  list of comma separated boolean values.
#!                                  Optional
#! @input is_flash_mode_enabled_list: If the value is 'true' then flash mode will be enabled for the particular disk.
#!                                    Provide a list of comma separated boolean values.
#!                                    Optional
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
#!                    keepAlive is false, an existing open connection will be used and will be closed after execution.
#!                    Default: 'true'
#!                    Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.
#!                                   Default: '2'
#!                                   Optional
#! @input connections_max_total: The maximum limit of connections in total.
#!                               Default: '20'
#!                               Optional
#!
#! @output vm_disk_uuid: UUID of the disk attached to the virtual machine.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################
namespace: io.cloudslang.nutanix.prism
flow:
  name: attach_disks_to_vm
  inputs:
    - hostname
    - port:
        required: false
    - username
    - password:
        sensitive: true
    - vm_uuid
    - is_cdrom_list
    - is_empty_disk_list:
        required: false
    - device_bus_list:
        required: false
    - device_index_list:
        required: false
    - source_vm_disk_uuid_list:
        required: false
    - vm_disk_minimum_size_list:
        required: false
    - ndfs_filepath_list:
        required: false
    - device_disk_size_list:
        required: false
    - storage_container_uuid_list:
        required: false
    - is_scsi_pass_through_list:
        required: false
    - is_thin_provisioned_list:
        required: false
    - is_flash_mode_enabled_list:
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
    - attach_disks:
        do:
          io.cloudslang.nutanix.prism.disks.attach_disks:
            - hostname: '${hostname}'
            - port: '${port}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - vm_uuid: '${vm_uuid}'
            - is_cdrom_list: '${is_cdrom_list}'
            - is_empty_disk_list: '${is_empty_disk_list}'
            - device_bus_list: '${device_bus_list}'
            - device_index_list: '${device_index_list}'
            - source_vm_disk_uuid_list: '${source_vm_disk_uuid_list}'
            - vm_disk_minimum_size_list: '${vm_disk_minimum_size_list}'
            - ndfs_filepath_list: '${ndfs_filepath_list}'
            - device_disk_size_list: '${device_disk_size_list}'
            - storage_container_uuid_disk_list: '${storage_container_uuid_disk_list}'
            - is_scsi_pass_through_list: '${is_scsi_pass_through_list}'
            - is_thin_provisioned_list: '${is_thin_provisioned_list}'
            - is_flash_mode_enabled_list: '${is_flash_mode_enabled_list}'
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
          - task_status
        navigate:
          - SUCCESS: is_task_status_succeeded
          - FAILURE: FAILURE
    - wait_for_task_status_success:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '10'
        navigate:
          - SUCCESS: get_task_details
          - FAILURE: FAILURE
    - iterate_for_task_status:
        do:
          io.cloudslang.nutanix.prism.utils.counter:
            - from: '1'
            - to: '30'
            - increment_by: '1'
        navigate:
          - HAS_MORE: wait_for_task_status_success
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - is_task_status_succeeded:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${task_status}'
            - second_string: Succeeded
        publish: []
        navigate:
          - SUCCESS: get_vm_details
          - FAILURE: iterate_for_task_status
    - success_message:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: 'Successfully attached disk to the VM : '
            - text: '${vm_name}'
        publish:
          - return_result: '${new_string}'
        navigate:
          - SUCCESS: SUCCESS
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
          - vm_disk_uuid
          - storage_container_uuid
          - vm_name
        navigate:
          - SUCCESS: success_message
          - FAILURE: FAILURE
  outputs:
    - vm_disk_uuid: '${vm_disk_uuid}'
  results:
    - FAILURE
    - SUCCESS
