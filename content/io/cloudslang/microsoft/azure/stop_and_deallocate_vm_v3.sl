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
#! @description: This workflow stops the virtual machine and deallocates the public IP address from the virtual machine.
#!
#! @input vm_name: The name of the virtual machine which needs to stop.
#!                 Virtual machine name cannot contain non-ASCII or special characters.
#! @input subscription_id: The ID of the Azure Subscription on which the VM should be stopped.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to stop the VM.
#! @input tenant_id: The tenantId value used to control who can sign into the application.
#! @input client_id: The Application ID assigned to your app when you registered it with Azure AD.
#! @input client_secret: The application secret that you created in the app registration portal for your app. It cannot
#!                       be used in a native app (public client), because client_secrets cannot be reliably stored on
#!                       devices. It is required for web apps and web APIs (all confidential clients), which have the
#!                       ability to store the client_secret securely on the server side.
#! @input enable_public_ip: The value of property will be true if the VM has public IP Address.
#! @input worker_group: Optional - A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#! @input connect_timeout: Optional - time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#! @input socket_timeout: Optional - time in seconds to wait for data to be retrieved
#!                        Default: '0' (infinite)
#! @input polling_interval: Optional - Time to wait between checks
#!                          Default: '30'
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
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
#!
#! @output output: Information about the virtual machine that has been stopped and de-allocated
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
  name: stop_and_deallocate_vm_v3
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
    - worker_group:
        default: RAS_Operator_Path
        required: false
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
          - SUCCESS: stop_and_deallocate_vm
          - FAILURE: on_failure
    - stop_and_deallocate_vm:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          vm.stop_and_deallocate_vm:
            - vm_name
            - subscription_id
            - resource_group_name
            - auth_token
            - connect_timeout
            - socket_timeout
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - keystore
            - keystore_password
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
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - keystore
            - keystore_password
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
            - second_string: PowerState/deallocated
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
          - SUCCESS: set_public_ip_address
          - FAILURE: SUCCESS
    - set_public_ip_address:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - vm_name: '${vm_name}'
        publish:
          - public_ip_address: '${vm_name}'
        navigate:
          - SUCCESS: SUCCESS
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
      get_auth_token_using_web_api:
        x: 75
        'y': 77
      stop_and_deallocate_vm:
        x: 238
        'y': 81
      get_power_state:
        x: 403
        'y': 81
        navigate:
          85693064-1e95-0fce-1217-8de604ebe36b:
            vertices:
              - x: 518
                'y': 182
            targetId: check_power_state
            port: SUCCESS
      check_power_state:
        x: 397
        'y': 253
      compare_power_state:
        x: 588
        'y': 253
        navigate:
          a9181551-5321-de44-06fe-fe97bcc86cd0:
            vertices:
              - x: 671
                'y': 187
            targetId: sleep
            port: FAILURE
      sleep:
        x: 589
        'y': 84
      set_public_ip_address:
        x: 763
        'y': 82
        navigate:
          34bde543-ae21-d7ae-85d1-a864bb9296a2:
            targetId: ed75296e-4be9-0934-4b4c-eaaedc5b4961
            port: SUCCESS
      check_enable_public_ip:
        x: 772
        'y': 258
        navigate:
          a802e42c-8840-7760-f32d-79b560cc0f20:
            targetId: ed75296e-4be9-0934-4b4c-eaaedc5b4961
            port: FAILURE
          68f2aeac-04c2-28d5-f878-64684c260e79:
            vertices:
              - x: 858
                'y': 187
            targetId: set_public_ip_address
            port: SUCCESS
    results:
      SUCCESS:
        ed75296e-4be9-0934-4b4c-eaaedc5b4961:
          x: 964
          'y': 154
