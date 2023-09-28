#   Copyright 2023 Open Text
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
#! @description: Attach disks to a virtual machine. A disk drive may either be a regular disk drive or a CD-ROM drive.
#!               Only CD-ROM drives may be empty.
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
#! @input device_bus_list: The device bus list. List the device buses in the same  order that the disk UUIDs are listed,
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
#! @output return_result: If successful, returns the complete API response. In case of an error this output will contain
#!                        the error message.
#! @output exception: An error message in case there was an error while executing the request.
#! @output status_code: The HTTP status code for Nutanix Prism API request.
#! @output task_uuid: The UUID of the task that will be created in Nutanix Prism after submission of the API request.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.nutanix.prism.disks

operation:
  name: attach_disks

  inputs:
    - hostname
    - port:
        required: false
    - username
    - password:
        sensitive: true
    - vm_uuid
    - vmUUID:
        default: ${get('vm_uuid', '')}
        required: false
        private: true
    - is_cdrom_list
    - isCDROMList:
        default: ${get('is_cdrom_list', '')}
        required: false
        private: true
    - is_empty_disk_list:
        required: false
    - isEmptyDiskList:
        default: ${get('is_empty_disk_list', '')}
        required: false
        private: true
    - device_bus_list:
        required: false
    - deviceBusList:
        default: ${get('device_bus_list', '')}
        required: false
        private: true
    - device_index_list:
        required: false
    - deviceIndexList:
        default: ${get('device_index_list', '')}
        required: false
        private: true
    - source_vm_disk_uuid_list:
        required: false
    - sourceVMDiskUUIDList:
        default: ${get('source_vm_disk_uuid_list', '')}
        required: false
        private: true
    - vm_disk_minimum_size_list:
        required: false
    - vmDiskMinimumSizeList:
        default: ${get('vm_disk_minimum_size_list', '')}
        required: false
        private: true
    - ndfs_filepath_list:
        required: false
    - ndfsFilepathList:
        default: ${get('ndfs_filepath_list', '')}
        required: false
        private: true
    - device_disk_size_list:
        required: false
    - deviceDiskSizeList:
        default: ${get('device_disk_size_list', '')}
        required: false
        private: true
    - storage_container_uuid_list:
        required: false
    - storageContainerUUIDList:
        default: ${get('storage_container_uuid_list', '')}
        required: false
        private: true
    - is_scsi_pass_through_list:
        required: false
    - isSCSIPassThroughList:
        default: ${get('is_scsi_pass_through_list', '')}
        required: false
        private: true
    - is_thin_provisioned_list:
        required: false
    - isThinProvisionedList:
        default: ${get('is_thin_provisioned_list', '')}
        required: false
        private: true
    - is_flash_mode_enabled_list:
        required: false
    - isFlashModeEnabledList:
        default: ${get('is_flash_mode_enabled_list', '')}
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
    gav: 'io.cloudslang.content:cs-nutanix-prism:1.0.5'
    class_name: 'io.cloudslang.content.nutanix.prism.actions.disks.AttachDisks'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - exception: ${get('exception', '')}
    - status_code: ${get('statusCode', '')}
    - task_uuid: ${get('taskUUID', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE
