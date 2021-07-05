#   (c) Copyright 2021 Micro Focus, L.P.
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
#! @description: This workflow is used to de-provision the VM.
#!
#! @input subscription_id: The ID of the Azure Subscription on which the VM should be un-deployed.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to undeploy the VM.
#! @input tenant_id: The tenantId value used to control who can sign into the application.
#! @input client_secret: The application secret that you created in the app registration portal for your app. It cannot
#!                       be used in a native app (public client), because client_secrets cannot be reliably stored on
#!                       devices. It is required for web apps and web APIs (all confidential clients),
#!                       which have the ability to store the client_secret securely on the server side.
#! @input provider_sap: Optional - The providerSAP(Service Access Point) to which requests will be sent.
#!                      Default: 'https://management.azure.com'
#! @input client_id: The Application ID assigned to your app when you registered it with Azure AD.
#! @input vm_name: The name of the virtual machine to be un-deployed.
#!                 Virtual machine name cannot contain non-ASCII or special characters.
#! @input location: The location where this VM has to be provisioned.
#! @input nic_name: This is the user entered NIC name for the VM.
#! @input public_ip_address_name: Optional - The name of public IP Address.
#! @input worker_group: Optional - A worker group is a logical collection of workers. A worker may belong to more than one group simultaneously.
#! @input connect_timeout: Optional - time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
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
#!
#! @output return_code: 0 if success, -1 if failure
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output error_message: If there is any error while running the flow, it will be populated, empty otherwise
#!
#! @result SUCCESS: The flow completed successfully.
#! @result FAILURE: Something went wrong
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure
imports:
  strings: io.cloudslang.base.strings
  ip: io.cloudslang.microsoft.azure.compute.network.public_ip_addresses
  json: io.cloudslang.base.json
  auth: io.cloudslang.microsoft.azure.authorization
  nic: io.cloudslang.microsoft.azure.compute.network.network_interface_card
  flow: io.cloudslang.base.utils
  vm: io.cloudslang.microsoft.azure.compute.virtual_machines
flow:
  name: undeploy_vm_v2
  inputs:
    - subscription_id
    - resource_group_name
    - tenant_id
    - client_secret:
        sensitive: true
    - provider_sap:
        default: 'https://management.azure.com'
        required: false
    - client_id
    - vm_name
    - location
    - nic_name
    - public_ip_address_name:
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
    - connect_timeout:
        default: '0'
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
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
            - resource: '${provider_sap}'
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
        navigate:
          - SUCCESS: get_vm_details
          - FAILURE: on_failure
    - stop_vm:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          vm.stop_vm:
            - subscription_id
            - resource_group_name
            - auth_token
            - vm_name
            - connect_timeout
            - socket_timeout: '0'
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - x_509_hostname_verifier
            - trust_all_roots
            - trust_keystore
            - trust_password
        publish:
          - status_code
          - error_message
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_vm_details_1
    - delete_vm:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          vm.delete_vm:
            - subscription_id
            - resource_group_name
            - auth_token
            - vm_name
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
          - status_code
          - error_message
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_vm_info_1
    - delete_nic:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          nic.delete_nic:
            - subscription_id
            - resource_group_name
            - auth_token
            - nic_name: '${current_nic_name}'
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
          - status_code
          - error_message
        navigate:
          - FAILURE: on_failure
          - SUCCESS: list_iterator
    - delete_public_ip_address:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          ip.delete_public_ip_address:
            - subscription_id
            - resource_group_name
            - auth_token
            - public_ip_address_name: '${public_ip_address_name}'
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
          - status_code
          - error_message
        navigate:
          - FAILURE: on_failure
          - SUCCESS: success_message
    - get_vm_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.compute.virtual_machines.get_vm_details:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - auth_token: '${auth_token}'
            - vm_name: '${vm_name}'
            - connect_timeout: '${connect_timeout}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - proxy_port: '${proxy_port}'
            - proxy_host: '${proxy_host}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password: '${trust_password}'
        publish:
          - vm_details: '${output}'
        navigate:
          - SUCCESS: retrieve_vm_1
          - FAILURE: on_failure
    - retrieve_vm_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${vm_details}'
            - json_path: name
        publish:
          - return_deleted: '${return_result}'
        navigate:
          - SUCCESS: stop_vm
          - FAILURE: get_nic_name_info
    - get_nic_name_info:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.compute.network.network_interface_card.get_nic_name_info:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - auth_token: '${auth_token}'
            - nic_name: '${nic_name}'
            - connect_timeout: '${connect_timeout}'
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
        navigate:
          - SUCCESS: delete_nic_1
          - FAILURE: on_failure
    - delete_nic_1:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.compute.network.network_interface_card.delete_nic:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - auth_token: '${auth_token}'
            - nic_name: '${nic_name}'
            - connect_timeout: '${connect_timeout}'
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
        navigate:
          - SUCCESS: is_publicIPAddressName_null
          - FAILURE: on_failure
    - delete_public_ip_address_1:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.compute.network.public_ip_addresses.delete_public_ip_address:
            - auth_token: '${auth_token}'
            - resource_group_name: '${resource_group_name}'
            - subscription_id: '${subscription_id}'
            - connect_timeout: '${connect_timeout}'
            - public_ip_address_name: '${public_ip_address_name}'
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
        navigate:
          - SUCCESS: success_message_1
          - FAILURE: on_failure
    - success_message_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - origin_string: 'The virtual machine  '
            - text: '${vm_name}'
        publish:
          - new_string
        navigate:
          - SUCCESS: set_suucess_message_1
    - set_suucess_message_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${new_string}'
            - text: '  was deleted before your request.'
        publish:
          - success_message: '${new_string}'
        navigate:
          - SUCCESS: SUCCESS
    - get_vm_details_1:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.compute.virtual_machines.get_vm_details:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - auth_token: '${auth_token}'
            - vm_name: '${vm_name}'
            - connect_timeout: '${connect_timeout}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - proxy_port: '${proxy_port}'
            - proxy_host: '${proxy_host}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password: '${trust_password}'
        publish:
          - disk_info: '${output}'
        navigate:
          - SUCCESS: delete_vm
          - FAILURE: on_failure
    - get_vm_info_1:
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
          - error_message
        navigate:
          - SUCCESS: check_vm_state_1
          - FAILURE: is_status_code
    - check_vm_state_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${vm_info}'
            - json_path: 'properties,provisioningState'
        publish:
          - expected_vm_state: '${return_result}'
        navigate:
          - SUCCESS: compare_power_state_1
          - FAILURE: on_failure
    - compare_power_state_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${expected_vm_state}'
            - second_string: Deleting
        navigate:
          - SUCCESS: counter
          - FAILURE: list_iterator
    - counter:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.microsoft.azure.utils.counter:
            - from: '0'
            - to: '60'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: wait_before_check_1
          - NO_MORE: list_iterator
          - FAILURE: on_failure
    - wait_before_check_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: get_vm_info_1
          - FAILURE: on_failure
    - list_iterator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${nic_name}'
        publish:
          - current_nic_name: '${result_string}'
        navigate:
          - HAS_MORE: delete_nic
          - NO_MORE: is_publicIPAddressName_null_1
          - FAILURE: on_failure
    - success_message:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - origin_string: 'The virtual machine '
            - text: '${vm_name}'
        publish:
          - new_string
        navigate:
          - SUCCESS: set_success_message
    - set_success_message:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${new_string}'
            - text: ' undeployed successfully.'
        publish:
          - success_message: '${new_string}'
        navigate:
          - SUCCESS: SUCCESS
    - is_publicIPAddressName_null:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${public_ip_address_name}'
        navigate:
          - IS_NULL: success_message_1
          - IS_NOT_NULL: delete_public_ip_address_1
    - is_publicIPAddressName_null_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${public_ip_address_name}'
        navigate:
          - IS_NULL: success_message
          - IS_NOT_NULL: delete_public_ip_address
    - is_status_code:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '404'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
  outputs:
    - return_code
    - status_code
    - error_message
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_auth_token_using_web_api:
        x: 48
        'y': 118
      get_nic_name_info:
        x: 333
        'y': 328
      get_vm_details:
        x: 195
        'y': 126
      wait_before_check_1:
        x: 745
        'y': 336
      is_status_code:
        x: 1143
        'y': 132
      delete_nic_1:
        x: 332
        'y': 495
      delete_vm:
        x: 725
        'y': 131
      success_message:
        x: 1511
        'y': 152
      is_publicIPAddressName_null:
        x: 480
        'y': 341
      retrieve_vm_1:
        x: 339
        'y': 125
      set_success_message:
        x: 1707
        'y': 153
        navigate:
          1248ff06-8aa9-f7a4-c539-31117ad7968e:
            targetId: 9df3c542-8cdd-15cc-997f-50d0856054e2
            port: SUCCESS
      compare_power_state_1:
        x: 895
        'y': 328
      list_iterator:
        x: 1159
        'y': 330
      delete_public_ip_address_1:
        x: 475
        'y': 508
      check_vm_state_1:
        x: 1027
        'y': 210
      set_suucess_message_1:
        x: 612
        'y': 512
        navigate:
          73c03208-4b1d-d48b-37aa-d048667b464b:
            targetId: 360c99d8-e97e-1260-c72c-dbb05fa43c72
            port: SUCCESS
      stop_vm:
        x: 471
        'y': 126
      delete_nic:
        x: 1163
        'y': 517
      get_vm_details_1:
        x: 604
        'y': 130
      counter:
        x: 889
        'y': 500
      success_message_1:
        x: 616
        'y': 337
      is_publicIPAddressName_null_1:
        x: 1320
        'y': 145
      delete_public_ip_address:
        x: 1312
        'y': 335
      get_vm_info_1:
        x: 860
        'y': 130
    results:
      SUCCESS:
        9df3c542-8cdd-15cc-997f-50d0856054e2:
          x: 1911
          'y': 160
        360c99d8-e97e-1260-c72c-dbb05fa43c72:
          x: 749
          'y': 611

