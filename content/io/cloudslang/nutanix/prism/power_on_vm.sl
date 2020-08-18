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
#! @description: This workflow powers on the virtual machine. It checks the current power state of virtual
#!               machine, If virtual machine is in powered on state, workflow succeeds without any operation execution
#!               and returns the power state of the virtual machine.
#!
#! @input hostname: The hostname for Nutanix Prism.
#! @input port: The port to connect to Nutanix Prism.
#!              Default: '9440'
#!              Optional
#! @input username: The username for Nutanix Prism.
#! @input password: The password for Nutanix Prism.
#! @input vm_uuid: The UUID of the virtual machine.
#! @input host_uuid: The UUID identifying the host on which the virtual machine is currently running. If virtual machine
#!                   is powered off, then this field is empty.
#!                   Optional
#! @input vm_logical_timestamp: The virtual logical timestamp of the virtual machine.
#!                              Optional
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
#! @output return_result: If successful, returns the success message. In case of an error this output will contain
#!                        the error message.
#! @output vm_power_state: The power state of the virtual machine.
#!
#! @result FAILURE: There was an error while executing the request.
#! @result SUCCESS: The request was successfully executed.
#!!#
########################################################################################################################
namespace: io.cloudslang.nutanix.prism
flow:
  name: power_on_vm
  inputs:
    - hostname
    - port:
        required: false
    - username
    - password:
        sensitive: true
    - vm_uuid
    - host_uuid:
        required: false
    - vm_logical_timestamp:
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
          - power_state
          - vm_name
          - exception
          - return_result
        navigate:
          - SUCCESS: is_vm_powered_on
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
          - FAILURE: FAILURE
    - is_task_status_succeeded:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${task_status}'
            - second_string: Succeeded
            - ignore_case: 'true'
        publish: []
        navigate:
          - SUCCESS: success_message
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
            - origin_string: 'Successfully powered on the virtual machine : '
            - text: '${vm_name}'
        publish:
          - return_result: '${new_string}'
          - power_state: 'on'
        navigate:
          - SUCCESS: SUCCESS
    - set_vm_power_state:
        do:
          io.cloudslang.nutanix.prism.virtualmachines.set_vm_power_state:
            - hostname: '${hostname}'
            - port: '${port}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - vm_uuid: '${vm_uuid}'
            - power_state: 'ON'
            - host_uuid: '${host_uuid}'
            - vm_logical_timestamp: '${vm_logical_timestamp}'
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
          - SUCCESS: wait_for_task_status
          - FAILURE: FAILURE
    - is_vm_powered_on:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${power_state}'
            - second_string: 'ON'
            - ignore_case: 'true'
        publish: []
        navigate:
          - SUCCESS: power_success_message
          - FAILURE: set_vm_power_state
    - power_success_message:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${vm_name}'
            - text: ' is in powered on state.'
        publish:
          - return_result: '${new_string}'
        navigate:
          - SUCCESS: SUCCESS
    - wait_for_task_status:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '5'
        navigate:
          - SUCCESS: get_task_details
          - FAILURE: FAILURE
  outputs:
    - return_result: '${return_result}'
    - vm_power_state: '${power_state}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_vm_details:
        x: 37
        'y': 72
      success_message:
        x: 651
        'y': 67
        navigate:
          8d7b17a3-8379-407b-9d9d-e77fa1b0db52:
            targetId: 37cc5d3c-be99-a362-4702-c01d32a365c5
            port: SUCCESS
      set_vm_power_state:
        x: 197
        'y': 299
        navigate:
          e80ed494-f92c-3043-66c3-7865591375b4:
            targetId: 39f96542-33ce-4888-f577-05b5dcb2e7dc
            port: FAILURE
      wait_for_task_status:
        x: 345
        'y': 296
        navigate:
          cea201fb-5a92-dd29-2560-2055468d4921:
            targetId: 39f96542-33ce-4888-f577-05b5dcb2e7dc
            port: FAILURE
      is_vm_powered_on:
        x: 229
        'y': 57
      wait_for_task_status_success:
        x: 646
        'y': 303
        navigate:
          6cff6e8a-ce49-006c-986d-873fdc083a2e:
            targetId: 39f96542-33ce-4888-f577-05b5dcb2e7dc
            port: FAILURE
      power_success_message:
        x: 344
        'y': 76
        navigate:
          58fa9275-1dff-2769-a14c-c6dfeb2c21b9:
            targetId: 37cc5d3c-be99-a362-4702-c01d32a365c5
            port: SUCCESS
      iterate_for_task_status:
        x: 825
        'y': 307
        navigate:
          9e7f68b0-c8d4-87d8-074d-c0d38a4283b8:
            targetId: 39f96542-33ce-4888-f577-05b5dcb2e7dc
            port: NO_MORE
          04177c6c-251c-5bf1-0c4e-ba76ab18adf4:
            targetId: 39f96542-33ce-4888-f577-05b5dcb2e7dc
            port: FAILURE
      get_task_details:
        x: 497
        'y': 300
        navigate:
          37240950-0fd9-2b17-db7f-8afe1edbeb07:
            targetId: 39f96542-33ce-4888-f577-05b5dcb2e7dc
            port: FAILURE
      is_task_status_succeeded:
        x: 854
        'y': 58
    results:
      FAILURE:
        39f96542-33ce-4888-f577-05b5dcb2e7dc:
          x: 417
          'y': 487
      SUCCESS:
        37cc5d3c-be99-a362-4702-c01d32a365c5:
          x: 494
          'y': 70
