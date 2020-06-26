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
#! @description: Update a virtual machine with specified configuration.
#!
#! @input hostname: The hostname for Nutanix Prism.
#! @input port: The port to connect to Nutanix Prism.
#!              Default: '9440'
#!              Optional
#! @input username: The username for Nutanix Prism.
#! @input password: The password for Nutanix Prism.
#! @input vm_uuid: Id of the virtual machine Prism.
#! @input update_vm_name: Name of the virtual machine that will be updated.
#!                 Optional
#! @input update_vm_description: The description of the virtual machine that will be updated.
#!                        Optional
#! @input update_vm_memory_size: The memory amount (in GiB) attached to the virtual machine that will will be updated.
#!                        Optional
#! @input update_num_vcpus: The number that indicates how many processors will have the virtual machine that will be updated.
#!                    Optional
#! @input update_num_cores_per_vcpu: This is the number of cores per vCPU.
#!                            Optional
#! @input update_time_zone: The timezone in which the virtual machine will be updated.Example : 'Asia/Calcutta'
#!                   Optional
#! @input update_host_uuids: The Host UUIDs for which virtual machine will be mapped.
#!                     Optional
#! @input update_agent_vm: Indicates whether the VM is an agent VM. When their host enters maintenance mode, after normal VMs
#!                  are evacuated, agent VMs are powered off. When the host is restored, agent VMs are powered on before
#!                  normal VMs are restored. In other words, agent VMs cannot be HA-protected or live migrated.Default :
#!                  'false'
#!                  Optional
#! @input api_version: The api version for Nutanix.
#!                      Default: 'v2.0'
#!                      Optional
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
#! @output vm_name: Name of the virtual machine that will be updated.
#! @output host_uuids: UUIDs identifying the host on which the virtual machine is currently running.
#! @output vm_memory_size: The memory amount (in GiB) attached to the virtual machine that will will be created.
#! @output num_vcpus: The number that indicates how many processors will have the virtual machine that will be created.
#! @output num_cores_per_vcpu: This is the number of cores per vCPU.
#! @output time_zone: The timezone in which the virtual machine will be created.
#! @output agent_vm: Indicates whether the VM is an agent VM.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################
namespace: io.cloudslang.nutanix.prism
flow:
  name: update_vm
  inputs:
    - hostname
    - port:
        required: false
    - username
    - password:
        sensitive: true
    - vm_uuid
    - update_vm_name:
        required: false
    - update_vm_description:
        required: false
    - update_vm_memory_size:
        required: false
    - update_num_vcpus:
        required: false
    - update_num_cores_per_vcpu:
        required: false
    - update_time_zone:
        required: false
    - update_host_uuids:
        required: false
    - update_agent_vm:
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
    - update_vm:
        do:
          io.cloudslang.nutanix.prism.virtualmachines.update_vm:
            - hostname: '${hostname}'
            - port: '${port}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - vm_uuid: '${vm_uuid}'
            - vm_name: '${update_vm_name}'
            - vm_description: '${update_vm_description}'
            - vm_memory_size: '${update_vm_memory_size}'
            - num_vcp_us: '${update_num_vcpus}'
            - num_cores_per_vcpu: '${update_num_cores_per_vcpu}'
            - time_zone: '${update_time_zone}'
            - host_uui_ds: '${update_host_uuids}'
            - agent_vm: '${update_agent_vm}'
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
        navigate:
          - SUCCESS: is_task_status_succeeded
          - FAILURE: on_failure
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
          - FAILURE: on_failure
    - wait_for_task_status_success:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '10'
        navigate:
          - SUCCESS: get_task_details
          - FAILURE: on_failure
    - get_updated_vm_details:
        do:
          io.cloudslang.nutanix.prism.utils.get_updated_vm_details:
            - vm_json_object: '${vm_return_result}'
        publish:
          - vm_name
          - host_uuids
          - vm_memory
          - num_vcpus
          - num_cores_per_vcpu
          - time_zone
          - agent_vm
        navigate:
          - FAILURE: on_failure
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
          - vm_return_result: '${return_result}'
        navigate:
          - SUCCESS: get_updated_vm_details
          - FAILURE: on_failure
  outputs:
    - vm_name: '${vm_name}'
    - host_uuids: '${host_uuids}'
    - agent_vm: '${agent_vm}'
    - num_cores_per_vcpu: '${num_cores_per_vcpu}'
    - num_vcpus: '${num_vcpus}'
    - vm_memory_size: '${vm_memory}'
    - time_zone: '${time_zone}'
  results:
    - SUCCESS
    - FAILURE
