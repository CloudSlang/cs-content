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
#! @description: VM provision flow.
#!
#! @input subscription_id: Specifies the unique identifier of Azure subscription.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to deploy the VM.
#! @input tenant_id: The tenantId value used to control who can sign into the application.
#! @input client_secret: The application secret that you created in the app registration portal for your app. It cannot
#!                       be used in a native app (public client), because client_secrets cannot be reliably stored on
#!                       devices. It is required for web apps and web APIs (all confidential clients), which have the
#!                       ability to store the client_secret securely on the server side.
#! @input provider_sap: The providerSAP(Service Access Point) to which requests will be sent.
#! @input client_id: The Application ID assigned to your app when you registered it with Azure AD.
#! @input location: Specifies the supported Azure location where the virtual machine should be deployed.
#!                  This can be different from the location of the resource group.
#! @input dns_name:  Specifies the domain name of the VM.
#! @input vm_name:  Name of the VM Instance provided by the user.
#! @input vm_size: Size of the VM to be created. Options include A0 standard , A1 standard, D1 standard, D2 standard etc.
#! @input virtual_network_name: The name of the virtual network to which the created VM should be attached.
#! @input availability_set_name: Specifies information about the availability set that the virtual machine
#!                               should be assigned to. Virtual machines specified in the same availability set
#!                               are allocated to different nodes to maximize availability.
#! @input storage_account: The name of the storage account in which the OS and Storage disks of the VM should be created.
#! @input subnet_name: The name of the Subnet in which the created VM should be added.
#! @input vm_username: Specifies the name of the administrator account.
#!                     The username can't contain the \/'[]":\<>+=;,?*@ characters or end with "."
#!                     Windows-only restriction: Cannot end in "."
#!                     Disallowed values: "administrator", "admin", "user", "user1", "test", "user2", "test1",
#!                     "user3", "admin1", "1", "123", "a", "actuser", "adm", "admin2", "aspnet", "backup", "console",
#!                     "david", "guest", "john", "owner", "root", "server", "sql", "support", "support_388945a0",
#!                     "sys", "test2", "test3", "user4", "user5".
#! @input vm_password: Specifies the password of the administrator account.
#!                     Minimum-length (Windows): 8 characters
#!                     Minimum-length (Linux): 6 characters
#!                     Max-length (Windows): 123 characters
#!                     Max-length (Linux): 72 characters
#!                     Complexity requirements: 3 out of 4 conditions below need to be fulfilled
#!                     Has lower characters
#!                     Has upper characters
#!                     Has a digit
#!                     Has a special character (Regex match [\W_])
#!                     Disallowed values: "abc@123", "P@$$w0rd", "P@ssw0rd", "P@ssword123", "Pa$$word", "pass@word1",
#!                     "Password!", "Password1", "Password22", "iloveyou!"
#! @input tag_name_list: Optional - Name of the tag to be added to the virtual machine
#!                       Default: ''
#! @input tag_value_list: Optional - Value of the tag to be added to the virtual machine
#!                        Default: ''
#! @input disk_size: The size of the storage disk to be attach to the virtual machine.Note: The value must be greater
#!                   than '0'
#!                   Default:10
#! @input connect_timeout: Optional - time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#! @input image: This is a custom property that contains the operating system and application configuration name that
#!               is used to create the virtual machine.
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
#! @input disk_type: Type of disk.
#!                   Example: Managed
#! @input ssh_publicKey_name: The name of the SSH public key.
#! @input private_image_name: Name of the private Image.
#! @input storage_account_type: Type of Storage used for VM deployment.
#! @input data_disk_name: This is the name for the data disk which is a VHD that’s attached to a virtual machine to
#!                        store application data, or other data you need to keep.
#! @input os_disk_name: Name of the VM disk used as a place to store operating system, applications and data.
#! @input enable_public_ip: Create public ip of the VM if the value is true.
#! @input worker_group: worker group name
#!
#! @output output: This output returns a JSON that contains the details of the created VM.
#! @output ip_address: The IP address of the virtual machine
#! @output vm_final_name: The final virtual machine name.
#! @output status_code: Equals 200 if the request completed successfully and other status codes in case an error occurred
#! @output return_code: 0 if success, -1 if failure
#! @output error_message: If there is any error while running the flow, it will be populated, empty otherwise
#!
#! @result SUCCESS: The flow completed successfully.
#! @result FAILURE: Something went wrong.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure
imports:
  strings: io.cloudslang.base.strings
  ip: io.cloudslang.microsoft.azure.compute.network.public_ip_addresses
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  auth: io.cloudslang.microsoft.azure.authorization
  nic: io.cloudslang.microsoft.azure.compute.network.network_interface_card
  math: io.cloudslang.base.math
  flow: io.cloudslang.base.utils
  lists: io.cloudslang.base.lists
  vm: io.cloudslang.microsoft.azure.compute.virtual_machines
flow:
  name: deploy_vm_v2
  inputs:
    - subscription_id
    - resource_group_name
    - tenant_id
    - client_secret:
        sensitive: true
    - provider_sap:
        required: true
    - client_id
    - location
    - dns_name:
        required: false
    - vm_name:
        required: true
    - vm_size
    - virtual_network_name
    - availability_set_name:
        required: false
    - storage_account:
        required: false
    - subnet_name
    - os_platform:
        required: false
    - vm_username
    - vm_password:
        required: false
        sensitive: true
    - tag_name_list:
        default: ''
        required: false
    - tag_value_list:
        default: ''
        required: false
    - disk_size:
        default: '10'
        required: false
    - connect_timeout:
        default: '0'
        required: false
    - image:
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
    - disk_type:
        required: false
    - ssh_publicKey_name:
        required: false
    - private_image_name:
        required: false
    - storage_account_type:
        required: false
    - data_disk_name:
        required: false
    - os_disk_name:
        required: false
    - enable_public_ip: 'true'
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - get_auth_token_using_web_api:
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
          - auth_token
        navigate:
          - SUCCESS: get_azure_image_details
          - FAILURE: on_failure
    - create_public_ip:
        do:
          ip.create_public_ip_address:
            - vm_name: '${vm_tmp_name}'
            - location
            - subscription_id
            - resource_group_name
            - public_ip_address_name: "${vm_name + '-ip'}"
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
          - ip_state: '${output}'
          - status_code
          - error_message
          - public_ip_address_name
        navigate:
          - SUCCESS: create_network_interface
          - FAILURE: on_failure
    - create_network_interface:
        do:
          nic.create_nic:
            - vm_name: '${vm_tmp_name}'
            - nic_name: "${vm_name + '-nic'}"
            - location
            - subscription_id
            - resource_group_name
            - public_ip_address_name: "${vm_name + '-ip'}"
            - virtual_network_name
            - subnet_name
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
          - nic_state: '${output}'
          - status_code
          - error_message: '${error_message}'
          - nic_name
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_vm
    - random_number_generator:
        do:
          math.random_number_generator:
            - min: '10000'
            - max: '99999'
        publish:
          - random_number: '${random_number}'
        navigate:
          - SUCCESS: append_vm_prefix
          - FAILURE: random_number_generator
    - get_vm_details_1:
        do:
          vm.get_vm_details:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - auth_token: '${auth_token}'
            - vm_name: '${vm_tmp_name}'
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
          - SUCCESS: remove_vm_prefix
          - FAILURE: string_occurrence_counter
    - append_vm_prefix:
        do:
          strings.append:
            - vm_name
            - origin_string: '${vm_name}'
            - text: '${random_number}'
        publish:
          - vm_tmp_name: "${new_string if vm_name == '' else vm_name }"
        navigate:
          - SUCCESS: get_vm_details_1
    - string_occurrence_counter:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: '${vm_details}'
            - string_to_find: ResourceNotFound
        publish: []
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: check_enable_public_ip
    - remove_vm_prefix:
        do:
          strings.remove:
            - vm_name
            - origin_string: '${vm_tmp_name}'
            - text: '${random_number}'
        publish:
          - vm_tmp_name: "${new_string if vm_name == '' else vm_name }"
        navigate:
          - SUCCESS: check_if_vm_name_alerady_exists
    - check_if_vm_name_alerady_exists:
        do:
          json.json_path_query:
            - json_object: '${vm_details}'
            - json_path: $.name
        publish:
          - vm_to_check: '${return_result}'
        navigate:
          - SUCCESS: check_if_same_name
          - FAILURE: random_number_generator
    - check_if_same_name:
        do:
          strings.string_equals:
            - string_in_which_to_search: '${vm_to_check}'
            - string_to_find: '${vm_tmp_name}'
            - ignore_case: 'true'
        publish: []
        navigate:
          - SUCCESS: same_name_error_msg
          - FAILURE: same_name_error_msg
    - same_name_error_msg:
        do:
          strings.append:
            - origin_string: "${'A virtual machine with the name \"' + vm_tmp_name + '\" already exists.'}"
            - text: ''
        publish:
          - error_message: '${new_string}'
        navigate:
          - SUCCESS: FAILURE
    - create_vm:
        do:
          io.cloudslang.azure.compute.virtualmachines.create_vm:
            - subscription_id: '${subscription_id}'
            - azure_protocol: https
            - azure_host: management.azure.com
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - api_version: '2019-07-01'
            - location: '${location}'
            - resource_group_name: '${resource_group_name}'
            - nic_name: '${nic_name}'
            - vm_size: '${vm_size}'
            - vm_name: '${vm_name}'
            - admin_username: '${vm_username}'
            - availability_set_name: '${availability_set_name}'
            - disk_type: '${disk_type}'
            - admin_password:
                value: '${vm_password}'
                sensitive: true
            - ssh_public_key_name: '${ssh_publicKey_name}'
            - storage_account: '${storage_account}'
            - storage_account_type: '${storage_account_type}'
            - publisher: '${publisher}'
            - offer: '${offer}'
            - sku: '${sku}'
            - image_version: '${version}'
            - plan: '${plan}'
            - private_image_name: '${private_image_name}'
            - data_disk_name: '${data_disk_name}'
            - os_disk_name: '${os_disk_name}'
            - disk_size_in_gb: '${disk_size}'
            - tag_key_list: '${tag_name_list}'
            - tag_value_list: '${tag_value_list}'
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
          - create_vm_return_result: '${return_result}'
          - status_code
          - exception
        navigate:
          - SUCCESS: get_vm_info_1
          - FAILURE: FAILURE
    - counter:
        do:
          io.cloudslang.microsoft.azure.utils.counter:
            - from: '0'
            - to: '60'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: wait_before_check_1
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - wait_before_check_1:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: get_vm_info_1
          - FAILURE: on_failure
    - get_vm_info_1:
        do:
          io.cloudslang.microsoft.azure.compute.virtual_machines.get_vm_details:
            - subscription_id
            - resource_group_name
            - vm_name: '${vm_tmp_name}'
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
          - FAILURE: on_failure
    - check_vm_state_1:
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
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${expected_vm_state}'
            - second_string: Succeeded
        navigate:
          - SUCCESS: set_data_disk_name
          - FAILURE: compare_power_state_1_1
    - compare_power_state_1_1:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${expected_vm_state}'
            - second_string: Failed
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: counter
    - set_data_disk_name:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${vm_info}'
            - json_path: 'properties,storageProfile,dataDisks,0,name'
        publish:
          - disk_name: '${return_result}'
        navigate:
          - SUCCESS: set_vm_id
          - FAILURE: on_failure
    - set_vm_id:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${vm_info}'
            - json_path: 'properties,vmId'
        publish:
          - vm_id: '${return_result}'
        navigate:
          - SUCCESS: set_os_type
          - FAILURE: on_failure
    - set_os_type:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${vm_info}'
            - json_path: 'properties,storageProfile,osDisk,osType'
        publish:
          - os_type: '${return_result}'
        navigate:
          - SUCCESS: check_os_type
          - FAILURE: on_failure
    - check_os_type:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${os_type}'
            - second_string: Linux
            - ignore_case: 'true'
        navigate:
          - SUCCESS: set_unix_os_type
          - FAILURE: set_resource_id
    - set_unix_os_type:
        do:
          io.cloudslang.base.utils.do_nothing:
            - os_type: Unix
        publish:
          - os_type
        navigate:
          - SUCCESS: set_resource_id
          - FAILURE: on_failure
    - set_resource_id:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${vm_info}'
            - json_path: id
        publish:
          - resource_id: '${return_result}'
        navigate:
          - SUCCESS: check_enable_public_ip_1
          - FAILURE: on_failure
    - check_enable_public_ip:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${enable_public_ip}'
            - second_string: 'true'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: create_public_ip
          - FAILURE: create_nic_without_public_ip
    - create_nic_without_public_ip:
        do:
          nic.create_nic_without_public_ip:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - auth_token: '${auth_token}'
            - nic_name: '${nic_name}'
            - virtual_network_name: '${virtual_network_name}'
            - subnet_name: '${subnet_name}'
            - location: '${location}'
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
            - worker_group: '${worker_group}'
        publish:
          - nic_state: '${output}'
        navigate:
          - SUCCESS: create_vm
          - FAILURE: on_failure
    - get_vm_public_ip_address:
        do:
          io.cloudslang.microsoft.azure.compute.network.public_ip_addresses.list_public_ip_addresses_within_resource_group:
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
          - ip_details: '${output}'
          - status_code
          - error_message: '${error_message}'
        navigate:
          - SUCCESS: update_public_ip_address
          - FAILURE: on_failure
    - check_enable_public_ip_1:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${enable_public_ip}'
            - second_string: 'true'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: get_vm_public_ip_address
          - FAILURE: get_nic_name_info
    - update_public_ip_address:
        do:
          ip.update_public_ip_address:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - auth_token: '${auth_token}'
            - location: '${location}'
            - public_ip_address_name: '${public_ip_address_name}'
            - dns_name: '${dns_name}'
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
            - worker_group: '${worker_group}'
        publish:
          - public_ip_json
        navigate:
          - SUCCESS: set_public_ip_address
          - FAILURE: on_failure
    - set_dns_name:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${public_ip_json}'
            - json_path: 'properties,dnsSettings,fqdn'
        publish:
          - dns_name: '${return_result}'
        navigate:
          - SUCCESS: get_nic_name_info
          - FAILURE: on_failure
    - get_nic_name_info:
        do:
          io.cloudslang.microsoft.azure.compute.network.network_interface_card.get_nic_name_info:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - auth_token: '${auth_token}'
            - nic_name: '${nic_name}'
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
          - nic_info_json: '${output}'
        navigate:
          - SUCCESS: set_mac_address
          - FAILURE: on_failure
    - set_mac_address:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${nic_info_json}'
            - json_path: 'properties,macAddress'
        publish:
          - mac_address: '${return_result}'
        navigate:
          - SUCCESS: set_internal_fqdn
          - FAILURE: on_failure
    - set_internal_fqdn:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${nic_info_json}'
            - json_path: 'properties,dnsSettings,internalFqdn'
        publish:
          - internal_fqdn: '${return_result}'
        navigate:
          - SUCCESS: set_private_ip_address
          - FAILURE: on_failure
    - set_private_ip_address:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${nic_info_json}'
            - json_path: 'properties,ipConfigurations,0,properties,privateIPAddress'
        publish:
          - private_ip_address: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - set_public_ip_address:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${public_ip_json}'
            - json_path: 'properties,ipAddress'
        publish:
          - public_ip_address: '${return_result}'
        navigate:
          - SUCCESS: set_dns_name
          - FAILURE: on_failure
    - get_azure_image_details:
        do:
          io.cloudslang.base.utils.do_nothing:
            - image: '${image}'
        publish:
          - publisher: '${image.split("#")[0]}'
          - offer: '${image.split("#")[1]}'
          - sku: '${image.split("#")[2]}'
          - version: '${image.split("#")[3]}'
          - plan: '${image.split("#")[4]}'
        navigate:
          - SUCCESS: random_number_generator
          - FAILURE: on_failure
  outputs:
    - output
    - ip_address
    - vm_final_name: '${vm_tmp_name}'
    - status_code
    - return_code
    - error_message: '${error_message}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_auth_token_using_web_api:
        x: 21
        'y': 347
      compare_power_state_1_1:
        x: 2889
        'y': 167
        navigate:
          ffc760a4-e499-e21e-254c-0ee4acdd9808:
            targetId: ce5e0e5a-2ae1-1138-2524-2de4fa9dd750
            port: SUCCESS
      get_nic_name_info:
        x: 4009.2578125
        'y': 480.5
      wait_before_check_1:
        x: 2754
        'y': 188
      get_azure_image_details:
        x: 186
        'y': 359
      create_network_interface:
        x: 1830
        'y': 411
      set_vm_id:
        x: 3526
        'y': 49
      set_mac_address:
        x: 3996.2578125
        'y': 272.6171875
      check_enable_public_ip_1:
        x: 3561
        'y': 498
      create_nic_without_public_ip:
        x: 1791.7578125
        'y': 652.5
      compare_power_state_1:
        x: 3085
        'y': 133
      same_name_error_msg:
        x: 2190
        'y': 168
        navigate:
          d4cbcaa3-e77e-ad75-6955-92b0a6425e9c:
            targetId: 6c84f1c7-298c-cde4-c621-674d21335b86
            port: SUCCESS
      set_resource_id:
        x: 3782
        'y': 314
      check_vm_state_1:
        x: 2988
        'y': 17
      get_vm_public_ip_address:
        x: 3196
        'y': 534
      check_if_vm_name_alerady_exists:
        x: 1299
        'y': 16
      set_private_ip_address:
        x: 4176
        'y': 424
        navigate:
          7d5d0728-e549-6c2e-3113-f7de06dec563:
            targetId: 9f545f21-e07c-ac50-3b6f-d0fbd0c39e83
            port: SUCCESS
      get_vm_details_1:
        x: 1000
        'y': 350
      set_public_ip_address:
        x: 3569
        'y': 698
      append_vm_prefix:
        x: 700
        'y': 350
      set_data_disk_name:
        x: 3238
        'y': 43
      check_enable_public_ip:
        x: 1554
        'y': 547
      set_os_type:
        x: 3569.2578125
        'y': 229.5
      random_number_generator:
        x: 400
        'y': 350
      check_if_same_name:
        x: 1900
        'y': 175
      create_vm:
        x: 2364
        'y': 111
        navigate:
          996601b1-4e09-3f24-6a07-1c6482907e57:
            targetId: 1b6ae514-478c-4191-827c-e1cda268cd24
            port: FAILURE
      set_internal_fqdn:
        x: 4110.2578125
        'y': 178.6171875
      create_public_ip:
        x: 1559
        'y': 207
      set_unix_os_type:
        x: 3881.2578125
        'y': 78.5
      string_occurrence_counter:
        x: 1300
        'y': 525
        navigate:
          dc71ab97-b555-703e-2833-55c59a4ea1d7:
            targetId: 3d3fa1b4-8779-d68b-1ac4-1e4d50f29ce4
            port: FAILURE
      counter:
        x: 3106
        'y': 385
        navigate:
          7a280867-369a-5ae0-17cf-b2e47605dbc4:
            targetId: ce5e0e5a-2ae1-1138-2524-2de4fa9dd750
            port: NO_MORE
      update_public_ip_address:
        x: 3240
        'y': 731
      check_os_type:
        x: 3656
        'y': 86
      set_dns_name:
        x: 3918.5078125
        'y': 659.5
      get_vm_info_1:
        x: 2604
        'y': 82
      remove_vm_prefix:
        x: 1300
        'y': 175
    results:
      SUCCESS:
        9f545f21-e07c-ac50-3b6f-d0fbd0c39e83:
          x: 4244
          'y': 725
      FAILURE:
        3d3fa1b4-8779-d68b-1ac4-1e4d50f29ce4:
          x: 1285
          'y': 730
        1b6ae514-478c-4191-827c-e1cda268cd24:
          x: 2657
          'y': 306
        ce5e0e5a-2ae1-1138-2524-2de4fa9dd750:
          x: 3308.7578125
          'y': 242.5
        6c84f1c7-298c-cde4-c621-674d21335b86:
          x: 1950.0078125
          'y': 28.500003814697266
