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
#! @description: This workflow detaches the disks from the virtual machine.
#!
#! @input hostname: The hostname for Nutanix Prism.
#! @input port: The port to connect to Nutanix Prism.
#!              Default: '9440'
#!              Optional
#! @input username: The username for Nutanix Prism.
#! @input password: The password for Nutanix Prism.
#! @input vm_uuid: The UUID of the virtual machine.
#! @input vm_disk_uuid_list: The virtual machine disk UUID list. If multiple disks need to be removed, add
#!                           comma-separated UUIDs.
#! @input device_bus_list: The device bus list for the virtual disk device. List the device buses in the same order
#!                         that the disk UUIDs are listed, separated by commas.
#!                         Valid values: 'sata, scsi, ide, pci, spapr'.
#! @input device_index_list: The indices of the device on the adapter type. List the device indices in the same order
#!                           that the disk UUIDs are listed, separated by commas.
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
#! @output return_result: If successful, returns the success message. In case of an error this output will contain
#!                        the error message.
#! @output vm_disk_uuid: The updated disk uuid/s of the virtual machine.
#!
#! @result FAILURE: There was an error while executing the request.
#! @result SUCCESS: The request was successfully executed.
#!!#
########################################################################################################################
namespace: io.cloudslang.nutanix.prism
flow:
  name: detach_disks_from_vm
  inputs:
    - hostname
    - port:
        required: false
    - username
    - password:
        sensitive: true
    - vm_uuid
    - vm_disk_uuid_list
    - device_bus_list
    - device_index_list
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
    - detach_disks:
        do:
          io.cloudslang.nutanix.prism.disks.detach_disks:
            - hostname: '${hostname}'
            - port: '${port}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - vm_uuid: '${vm_uuid}'
            - vm_disk_uuid_list: '${vm_disk_uuid_list}'
            - device_bus_list: '${device_bus_list}'
            - device_index_list: '${device_index_list}'
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
          - return_result
          - exception
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
          - return_result
        navigate:
          - SUCCESS: is_task_status_succeeded
          - FAILURE: FAILURE
    - is_task_status_succeeded:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${task_status}'
            - second_string: Succeeded
            - ignore_case: 'true'
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
    - success_message:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: 'Successfully detached disk/s from the VM :  '
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
          - vm_name
          - vm_disk_uuid
          - return_result
          - exception
        navigate:
          - SUCCESS: success_message
          - FAILURE: FAILURE
  outputs:
    - return_result: '${return_result}'
    - vm_disk_uuid: '${vm_disk_uuid}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      detach_disks:
        x: 39
        'y': 76
        navigate:
          d6dca7e1-5ab3-fe77-993f-73481649fa70:
            vertices:
              - x: 119
                'y': 119
            targetId: get_task_details
            port: SUCCESS
      get_task_details:
        x: 237
        'y': 83
      is_task_status_succeeded:
        x: 510
        'y': 67
      iterate_for_task_status:
        x: 1019
        'y': 518
        navigate:
          75361473-5ffc-2f77-7a38-1482bad49df3:
            targetId: 546dc45b-eb93-96c3-fbc7-99977d3aa8c2
            port: NO_MORE
          f1ba6eea-aaf3-f5f2-cd28-5fe843347133:
            targetId: 546dc45b-eb93-96c3-fbc7-99977d3aa8c2
            port: FAILURE
      wait_for_task_status_success:
        x: 243
        'y': 510
        navigate:
          e412acca-22fa-1386-8b10-4b3e0da0049b:
            targetId: 546dc45b-eb93-96c3-fbc7-99977d3aa8c2
            port: FAILURE
      success_message:
        x: 987
        'y': 81
        navigate:
          795a04b4-12e3-7d4c-fe01-e13f2d25282e:
            targetId: 33f1712a-3a6a-f91a-1ca6-78c73ddfa879
            port: SUCCESS
      get_vm_details:
        x: 713
        'y': 82
    results:
      FAILURE:
        546dc45b-eb93-96c3-fbc7-99977d3aa8c2:
          x: 540
          'y': 295
      SUCCESS:
        33f1712a-3a6a-f91a-1ca6-78c73ddfa879:
          x: 1191
          'y': 88
