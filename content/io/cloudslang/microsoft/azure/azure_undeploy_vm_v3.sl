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
#! @description: This workflow is used to de-provision the VM.
#!
#! @input subscription_id: The ID of the Azure Subscription on which the VM should be un-deployed.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to undeploy the VM.
#! @input tenant_id: The tenantId value used to control who can sign into the application.
#! @input client_secret: The application secret that you created in the app registration portal for your app. It cannot
#!                       be used in a native app (public client), because client_secrets cannot be reliably stored on
#!                       devices. It is required for web apps and web APIs (all confidential clients),
#!                       which have the ability to store the client_secret securely on the server side.
#! @input provider_sap: The providerSAP(Service Access Point) to which requests will be sent.
#!                      Default: 'https://management.azure.com'
#!                      Optional
#! @input client_id: The Application ID assigned to your app when you registered it with Azure AD.
#! @input vm_name: The name of the virtual machine to be un-deployed.
#!                 Virtual machine name cannot contain non-ASCII or special characters.
#! @input location: The location where this VM has to be provisioned.
#! @input nic_name: This is the user entered NIC name for the VM.
#! @input infrastructure_options: Type of the infrastructure.Allowed Values: noInfrastructure, availabilitySet
#! @input availability_options: If "noInfrastructure" is specified for infrastructure_options, then enter either Managedor Unmanaged options. If "availabilitySet" is specified for infrastructure_options, thenenter availability set name.
#! @input type_of_storage: Type of Storage used for VM deployment. If aligned availability set or Managed option isentered for availability_options, then specify storage account types. If classic availabilityset or Unmanaged option is entered for availability_options, then enter storage accounts name.
#! @input public_ip_address_name: The name of public IP Address.
#!                                Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Optional
#! @input connect_timeout: Time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#!                         Optional
#! @input proxy_host: Proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: Proxy server port.
#!                    Optional
#! @input proxy_username: Username used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#!                                 Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
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
  name: azure_undeploy_vm_v3
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
    - infrastructure_options
    - availability_options
    - type_of_storage
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
            - resource: 'https://management.azure.com'
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
          - SUCCESS: check_azure_infra_type
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
          - IS_NULL: check_azure_infra_type
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
    - check_azure_infra_type:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${infrastructure_options}'
            - second_string: availabilitySet
            - ignore_case: 'true'
        navigate:
          - SUCCESS: get_availability_set_details
          - FAILURE: check_azure_availability_type
    - check_azure_availability_type:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${availability_options}'
            - second_string: Managed
            - ignore_case: 'true'
        navigate:
          - SUCCESS: data_disk_list
          - FAILURE: get_storage_account_keys
    - get_availability_set_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.compute.virtual_machines.availability_sets.get_availability_set_details:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - auth_token: '${auth_token}'
            - availability_set_name: '${availability_options}'
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
          - av_json_info: '${output}'
        navigate:
          - SUCCESS: set_av_type
          - FAILURE: on_failure
    - set_av_type:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${av_json_info}'
            - json_path: 'sku,name'
        publish:
          - av_sku_type: '${return_result}'
        navigate:
          - SUCCESS: check_azure_availability_type_1
          - FAILURE: on_failure
    - check_azure_availability_type_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${av_sku_type}'
            - second_string: Aligned
            - ignore_case: 'true'
        navigate:
          - SUCCESS: data_disk_list
          - FAILURE: get_storage_account_keys
    - data_disk_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${disk_info}'
            - json_path: 'properties.storageProfile.dataDisks[*].name'
        publish:
          - data_disk_list: "${return_result.replace(\"[\",\"\").replace(\"]\",\"\").replace(\"\\\"\",\"\")}"
        navigate:
          - SUCCESS: is_data_disk_list_empty
          - FAILURE: on_failure
    - list_iterator_for_data_disks:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${data_disk_list}'
        publish:
          - data_disk_name: '${result_string}'
        navigate:
          - HAS_MORE: delete_data_disk
          - NO_MORE: os_disk_info
          - FAILURE: on_failure
    - delete_data_disk:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.compute.disks.delete_disk:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - auth_token: '${auth_token}'
            - disk_name: '${data_disk_name}'
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
        navigate:
          - SUCCESS: list_iterator_for_data_disks
          - FAILURE: on_failure
    - is_data_disk_list_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${data_disk_list}'
        navigate:
          - SUCCESS: os_disk_info
          - FAILURE: list_iterator_for_data_disks
    - os_disk_info:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${disk_info}'
            - json_path: properties.storageProfile.osDisk.name
        publish:
          - os_disk_name: "${return_result.replace(\"\\\"\",\"\")}"
        navigate:
          - SUCCESS: delete_os_disk
          - FAILURE: on_failure
    - delete_os_disk:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.compute.disks.delete_disk:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - auth_token: '${auth_token}'
            - disk_name: '${os_disk_name}'
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
        navigate:
          - SUCCESS: success_message
          - FAILURE: on_failure
    - data_disk_list_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${disk_info}'
            - json_path: 'properties.storageProfile.dataDisks[*].vhd.uri'
        publish:
          - data_disk_list: "${return_result.replace(\"[\",\"\").replace(\"]\",\"\").replace(\"\\\"\",\"\")}"
        navigate:
          - SUCCESS: is_data_disk_list_empty_1
          - FAILURE: on_failure
    - is_data_disk_list_empty_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${data_disk_list}'
        navigate:
          - SUCCESS: os_disk_info_1
          - FAILURE: list_iterator_for_data_disks_1
    - get_storage_account_keys:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.compute.storage.get_storage_account_keys:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - auth_token: '${auth_token}'
            - storage_account: '${type_of_storage}'
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
          - storage_key: '${key}'
        navigate:
          - SUCCESS: data_disk_list_1
          - FAILURE: on_failure
    - list_iterator_for_data_disks_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${data_disk_list}'
        publish:
          - data_disk_name: '${result_string}'
        navigate:
          - HAS_MORE: get_container_name_and_blob_name
          - NO_MORE: os_disk_info_1
          - FAILURE: on_failure
    - delete_blob:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.microsoft.azure.compute.storage.blobs.delete_blob:
            - storage_account: '${type_of_storage}'
            - key:
                value: '${storage_key}'
                sensitive: true
            - container_name: '${container_name}'
            - blob_name: '${blob_name}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - exception
          - return_code
        navigate:
          - SUCCESS: list_iterator_for_data_disks_1
          - FAILURE: on_failure
    - get_container_name_and_blob_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - origin_string: '${data_disk_name}'
        publish:
          - container_name: '${origin_string.split("/")[3]}'
          - blob_name: '${origin_string.split("/")[4]}'
        navigate:
          - SUCCESS: delete_blob
          - FAILURE: on_failure
    - os_disk_info_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${disk_info}'
            - json_path: properties.storageProfile.osDisk.vhd.uri
        publish:
          - os_disk_name: "${return_result.replace(\"[\",\"\").replace(\"]\",\"\").replace(\"\\\"\",\"\")}"
        navigate:
          - SUCCESS: get_container_name_and_blob_name_1
          - FAILURE: on_failure
    - get_container_name_and_blob_name_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - origin_string: '${os_disk_name}'
        publish:
          - container_name: '${origin_string.split("/")[3]}'
          - blob_name: '${origin_string.split("/")[4]}'
        navigate:
          - SUCCESS: delete_blob_1
          - FAILURE: on_failure
    - delete_blob_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.microsoft.azure.compute.storage.blobs.delete_blob:
            - storage_account: '${type_of_storage}'
            - key:
                value: '${storage_key}'
                sensitive: true
            - container_name: '${container_name}'
            - blob_name: '${blob_name}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - exception
          - return_code
        navigate:
          - SUCCESS: success_message
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
      is_data_disk_list_empty_1:
        x: 2348
        'y': 578
      get_nic_name_info:
        x: 226
        'y': 342
      delete_blob_1:
        x: 2697
        'y': 577
      get_vm_details:
        x: 219
        'y': 122
      delete_os_disk:
        x: 2508
        'y': 125
      wait_before_check_1:
        x: 746
        'y': 350
      is_status_code:
        x: 1232
        'y': 129
      delete_nic_1:
        x: 225
        'y': 553
      list_iterator_for_data_disks:
        x: 2333
        'y': 384
      set_av_type:
        x: 1768
        'y': 121
      os_disk_info_1:
        x: 2351
        'y': 822
      check_azure_availability_type_1:
        x: 1935
        'y': 129
        navigate:
          25bb9364-39f2-2dd6-bfe4-f436e4678df5:
            vertices:
              - x: 1811
                'y': 350
            targetId: get_storage_account_keys
            port: FAILURE
      get_container_name_and_blob_name_1:
        x: 2701
        'y': 823
      get_availability_set_details:
        x: 1596
        'y': 121
      delete_vm:
        x: 880
        'y': 127
      data_disk_list:
        x: 2149
        'y': 123
      success_message:
        x: 2690
        'y': 130
      is_publicIPAddressName_null:
        x: 391
        'y': 358
      retrieve_vm_1:
        x: 374
        'y': 127
      set_success_message:
        x: 2870
        'y': 127
        navigate:
          1248ff06-8aa9-f7a4-c539-31117ad7968e:
            targetId: 9df3c542-8cdd-15cc-997f-50d0856054e2
            port: SUCCESS
      is_data_disk_list_empty:
        x: 2343
        'y': 128
      compare_power_state_1:
        x: 898
        'y': 396
      list_iterator:
        x: 1226
        'y': 385
      check_azure_infra_type:
        x: 1593
        'y': 378
      delete_public_ip_address_1:
        x: 390
        'y': 556
      delete_blob:
        x: 1926
        'y': 825
      check_vm_state_1:
        x: 1053
        'y': 297
      set_suucess_message_1:
        x: 576
        'y': 557
        navigate:
          73c03208-4b1d-d48b-37aa-d048667b464b:
            targetId: 360c99d8-e97e-1260-c72c-dbb05fa43c72
            port: SUCCESS
      get_storage_account_keys:
        x: 1929
        'y': 581
      stop_vm:
        x: 535
        'y': 131
      delete_nic:
        x: 1223
        'y': 579
      get_vm_details_1:
        x: 703
        'y': 126
      os_disk_info:
        x: 2509
        'y': 380
      check_azure_availability_type:
        x: 1923
        'y': 377
      get_container_name_and_blob_name:
        x: 2041
        'y': 664
      list_iterator_for_data_disks_1:
        x: 2165
        'y': 825
      counter:
        x: 892
        'y': 574
      data_disk_list_1:
        x: 2151
        'y': 575
      success_message_1:
        x: 576
        'y': 352
      is_publicIPAddressName_null_1:
        x: 1409
        'y': 129
      delete_public_ip_address:
        x: 1409
        'y': 386
      delete_data_disk:
        x: 2151
        'y': 380
      get_vm_info_1:
        x: 1052
        'y': 129
    results:
      SUCCESS:
        9df3c542-8cdd-15cc-997f-50d0856054e2:
          x: 3050
          'y': 132
        360c99d8-e97e-1260-c72c-dbb05fa43c72:
          x: 749
          'y': 559

