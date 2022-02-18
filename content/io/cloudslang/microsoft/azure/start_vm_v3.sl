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
#! @description: This workflow starts the virtual machine.
#!
#! @input vm_name: The name of the virtual machine that needs to start.
#!                 Virtual machine name cannot contain non-ASCII or special characters.
#! @input subscription_id: The ID of the Azure Subscription on which the VM should be started.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to start the VM.
#! @input tenant_id: The tenantId value used to control who can sign into the application.
#! @input client_id: The Application ID assigned to your app when you registered it with Azure AD.
#! @input client_secret: The application secret that you created in the app registration portal for your app. It cannot
#!                       be used in a native app (public client), because client_secrets cannot be reliably stored on
#!                       devices. It is required for web apps and web APIs (all confidential clients), which have the
#!                       ability to store the client_secret securely on the server side.
#! @input enable_public_ip: The value of property will be true if the VM has public IP Address
#! @input connect_timeout: Optional - time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#! @input polling_interval: Optional - Time to wait between checks.
#!                          Default: '30'
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - Username used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input x_509_hostname_verifier: Optional - specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#! @input trust_keystore: Optional - the pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - the password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input worker_group: Optional - A worker group is a logical collection of workers. A worker may belong to more than one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output output: Information about the virtual machine that has been started.
#! @output power_state: Power state of the Virtual Machine
#! @output public_ip_address: The primary IP Address of the VM
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
  name: start_vm_v3
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
    - enable_public_ip
    - connect_timeout:
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
          - SUCCESS: start_vm
          - FAILURE: on_failure
    - start_vm:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          vm.start_vm:
            - vm_name
            - subscription_id
            - resource_group_name
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
          - output
          - status_code
          - error_message
        navigate:
          - SUCCESS: get_power_state
          - FAILURE: on_failure
    - get_power_state:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          vm.get_power_state:
            - vm_name
            - subscription_id
            - resource_group_name
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
          json.get_value:
            - json_input: '${power_status}'
            - json_path: 'statuses,1,code'
        publish:
          - expected_power_state: '${return_result}'
        navigate:
          - SUCCESS: compare_power_state
          - FAILURE: on_failure
    - compare_power_state:
        worker_group: '${worker_group}'
        do:
          strings.string_equals:
            - first_string: '${expected_power_state}'
            - second_string: PowerState/running
        navigate:
          - FAILURE: sleep
          - SUCCESS: check_enable_public_ip
    - sleep:
        worker_group: '${worker_group}'
        do:
          flow.sleep:
            - seconds: '${polling_interval}'
        navigate:
          - SUCCESS: get_power_state
          - FAILURE: on_failure
    - check_enable_public_ip:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${enable_public_ip}'
            - second_string: 'true'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: get_public_ip_address_info
          - FAILURE: SUCCESS
    - set_public_ip_address:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${public_ip_details}'
            - json_path: 'properties,ipAddress'
        publish:
          - public_ip_address: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_public_ip_address_info:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.compute.network.public_ip_addresses.get_public_ip_address_info:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - auth_token: '${auth_token}'
            - public_ip_address_name: '${vm_name}'
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
          - public_ip_details: '${output}'
        navigate:
          - SUCCESS: set_public_ip_address
          - FAILURE: on_failure
  outputs:
    - output
    - power_state: '${power_state}'
    - public_ip_address
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
        x: 580
        'y': 73
        navigate:
          5434f217-8f12-03e3-8e61-2141413114bc:
            vertices:
              - x: 696
                'y': 174
            targetId: compare_power_state
            port: SUCCESS
      get_auth_token_using_web_api:
        x: 50
        'y': 80
      get_public_ip_address_info:
        x: 758
        'y': 72
      get_power_state:
        x: 383
        'y': 74
      start_vm:
        x: 202
        'y': 77
      set_public_ip_address:
        x: 933
        'y': 76
        navigate:
          75c01bd4-7e53-a612-e408-c184535c991e:
            targetId: 56d1cd55-93f0-4c69-4128-01b03b870c0c
            port: SUCCESS
            vertices:
              - x: 1048
                'y': 182
      sleep:
        x: 383
        'y': 255
        navigate:
          749737d7-bad6-2fed-b625-a2ec7b48eb62:
            vertices:
              - x: 499
                'y': 184
            targetId: get_power_state
            port: SUCCESS
      check_enable_public_ip:
        x: 766
        'y': 255
        navigate:
          fcefbbbc-6229-9b54-8255-371bfe3420cc:
            targetId: 56d1cd55-93f0-4c69-4128-01b03b870c0c
            port: FAILURE
          a399b51d-2e0e-cc8f-0ce9-80f5f8554548:
            vertices:
              - x: 876
                'y': 180
            targetId: get_public_ip_address_info
            port: SUCCESS
      compare_power_state:
        x: 585
        'y': 256
    results:
      SUCCESS:
        56d1cd55-93f0-4c69-4128-01b03b870c0c:
          x: 941
          'y': 256