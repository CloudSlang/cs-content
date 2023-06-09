#   (c) Copyright 2023 Micro Focus, L.P.
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
#! @description: This workflow is used to update or resize the virtual machine.
#!
#! @input vm_name: The name of the virtual machine to be restarted.
#!                 Virtual machine name cannot contain non-ASCII or special characters.
#! @input subscription_id: The ID of the Azure Subscription on which the VM should be restarted.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to restart the VM.
#! @input tenant_id: The tenantId value used to control who can sign into the application.
#! @input client_id: The Application ID assigned to your app when you registered it with Azure AD.
#! @input client_secret: The application secret that you created in the app registration portal for your app. It cannot
#!                       be used in a native app (public client), because client_secrets cannot be reliably stored on
#!                       devices. It is required for web apps and web APIs (all confidential clients), which have the
#!                       ability to store the client_secret securely on the server side.
#! @input location: The location in which VM resides.
#! @input vm_size: The new size of the VM.
#! @input connect_timeout: Optional - time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#! @input socket_timeout: Optional - time in seconds to wait for data to be retrievedDefault: '0' (infinite)
#! @input polling_interval: Time to wait between checks
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - Username used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input x_509_hostname_verifier: Optional - specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#!                                 Default: 'strict'
#! @input trust_keystore: Optional - the pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - the password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#!
#! @output output: Information about the virtual machine that has been resized
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output return_code: 0 if success, -1 if failure
#! @output error_message: If there is any error while running the flow, it will be populated, empty otherwise
#!
#! @result SUCCESS: The flow completed successfully.
#! @result FAILURE: There was an error while trying to run every step of the flow.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings
  flow: io.cloudslang.base.utils
  auth: io.cloudslang.microsoft.azure.authorization
  vm: io.cloudslang.microsoft.azure.compute.virtual_machines
flow:
  name: azure_update_vm_size
  inputs:
    - vm_name
    - subscription_id
    - resource_group_name
    - tenant_id:
        required: true
        sensitive: false
    - client_id:
        required: true
        sensitive: false
    - client_secret:
        required: true
        sensitive: true
    - location
    - vm_size
    - connect_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
        required: false
    - polling_interval:
        default: '30'
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - get_auth_token_using_web_api:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.microsoft.azure.authorization.get_auth_token_using_web_api:
            - tenant_id: '${tenant_id}'
            - client_id: '${client_id}'
            - client_secret:
                value: '${client_secret}'
                sensitive: true
            - resource: 'https://management.azure.com/'
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
        publish:
          - auth_token:
              value: '${auth_token}'
              sensitive: true
          - return_code
          - error_message: '${exception}'
        navigate:
          - SUCCESS: get_power_state
          - FAILURE: on_failure
    - resize_vm:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.compute.virtual_machines.resize_vm:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - resource_group_name: '${resource_group_name}'
            - subscription_id: '${subscription_id}'
            - vm_name: '${vm_name}'
            - location: '${location}'
            - vm_size: '${vm_size}'
            - api_version: null
            - worker_group: '${worker_group}'
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
        publish:
          - return_result
          - status_code
          - json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_vm_info
    - get_vm_info:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.compute.virtual_machines.get_vm_details:
            - subscription_id
            - resource_group_name
            - vm_name: '${vm_name}'
            - auth_token
            - connect_timeout
            - socket_timeout: '0'
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - vm_info: '${output}'
          - status_code
          - return_result: '${error_message}'
        navigate:
          - SUCCESS: check_vm_state
          - FAILURE: on_failure
    - check_vm_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${vm_info}'
            - json_path: 'properties,provisioningState'
        publish:
          - expected_vm_state: '${return_result}'
        navigate:
          - SUCCESS: compare_power_state_succeded
          - FAILURE: on_failure
    - compare_power_state_succeded:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${expected_vm_state}'
            - second_string: Succeeded
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: compare_power_state
    - compare_power_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${expected_vm_state}'
            - second_string: Failed
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: counter
    - counter:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.microsoft.azure.utils.counter:
            - from: '1'
            - to: '60'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: wait_before_check
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - wait_before_check:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: get_vm_info
          - FAILURE: on_failure
    - get_power_state:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.compute.virtual_machines.get_power_state:
            - vm_name
            - subscription_id
            - resource_group_name
            - auth_token
            - proxy_host
            - proxy_port
            - connect_timeout
            - socket_timeout: '0'
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - power_state: '${power_state}'
          - power_status: '${output}'
          - status_code
          - error_message
        navigate:
          - SUCCESS: check_power_state
          - FAILURE: on_failure
    - check_power_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${power_status}'
            - json_path: 'statuses,1,code'
        publish:
          - expected_power_state: '${return_result}'
        navigate:
          - SUCCESS: compare_power_state_1
          - FAILURE: on_failure
    - stop_vm_v2:
        do:
          io.cloudslang.microsoft.azure.stop_vm_v2:
            - vm_name: '${vm_name}'
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - tenant_id: '${tenant_id}'
            - client_id: '${client_id}'
            - client_secret:
                value: '${client_secret}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - worker_group: '${worker_group}'
        navigate:
          - SUCCESS: resize_vm
          - FAILURE: on_failure
    - compare_power_state_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${expected_power_state}'
            - second_string: PowerState/stopped
        navigate:
          - SUCCESS: resize_vm
          - FAILURE: stop_vm_v2
  outputs:
    - output
    - status_code
    - return_code
    - error_message
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      check_power_state:
        x: 80
        'y': 480
      get_auth_token_using_web_api:
        x: 80
        'y': 80
      check_vm_state:
        x: 360
        'y': 80
      compare_power_state_succeded:
        x: 640
        'y': 80
        navigate:
          db1b5306-af0f-15b5-c492-a2ace6fe84c1:
            targetId: c04448b4-a5b6-9697-3e88-ed8cb683af22
            port: SUCCESS
      resize_vm:
        x: 400
        'y': 480
      stop_vm_v2:
        x: 240
        'y': 80
      get_vm_info:
        x: 480
        'y': 240
      get_power_state:
        x: 80
        'y': 240
      compare_power_state_1:
        x: 240
        'y': 480
      wait_before_check:
        x: 600
        'y': 360
      counter:
        x: 800
        'y': 360
        navigate:
          3aaf1dd4-9ce4-76fc-829e-defb2b23f92d:
            targetId: 49187da1-453b-9f14-f9cc-38356cca1fff
            port: NO_MORE
      compare_power_state:
        x: 800
        'y': 160
        navigate:
          82fb8784-16d7-1d0c-d35a-925649fc1717:
            targetId: c04448b4-a5b6-9697-3e88-ed8cb683af22
            port: SUCCESS
    results:
      SUCCESS:
        c04448b4-a5b6-9697-3e88-ed8cb683af22:
          x: 960
          'y': 80
      FAILURE:
        49187da1-453b-9f14-f9cc-38356cca1fff:
          x: 960
          'y': 360

