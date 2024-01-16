#   Copyright 2024 Open Text
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
#! @description: This workflow is used to provision VM in Azure.
#!
#! @input provider_sap: The providerSAP(Service Access Point) to which requests will be sent.
#!                      Default: 'https://management.azure.com'
#!                      Optional
#! @input subscription_id: The ID of the Azure Subscription on which the VM should be deployed.
#! @input tenant_id: The tenantId value used to control who can sign into the application.
#! @input client_secret: The application secret that you created in the app registration portal for your app. It cannot
#!                       be used in a native app (public client), because client_secrets cannot be reliably stored on
#!                       devices. It is required for web apps and web APIs (all confidential clients),
#!                       which have the ability to store the client_secret securely on the server side.
#! @input client_id: The Application ID assigned to your app when you registered it with Azure AD.
#! @input location: Specifies the supported Azure location where the virtual machine should be deployed.
#!                  This can be different from the location of the resource group.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to deploy the VM.
#! @input vm_name: The name of the virtual machine to be deployed. Virtual machine name cannot contain non-ASCII or special
#!                 characters.
#! @input vm_size: The name of the standard Azure VM size to be applied to the VM.
#!                 Example: 'Standard_DS1_v2','Standard_D2_v2','Standard_D3_v2'
#! @input virtual_network_name: The name of the virtual network to which the created VM should be attached.
#! @input subnet_name: The name of the Subnet in which the created VM should be added.
#! @input infrastructure_options: Type of the infrastructure.
#!                                Allowed Values: noInfrastructure, availabilitySet
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#! @input availability_options: If "noInfrastructure" is specified for infrastructure_options, then enter either Managed
#!                              or Unmanaged options. If "availabilitySet" is specified for infrastructure_options, then
#!                              enter availability set name.
#! @input type_of_storage: Type of Storage used for VM deployment. If aligned availability set or Managed option is
#!                         entered for availability_options, then specify storage account types. If classic availability
#!                         set or Unmanaged option is entered for availability_options, then enter storage accounts name.
#! @input vm_username: Specifies the name of the administrator account.
#!                     The username can't contain the \/'[]":\<>+=;,?*@ characters or end with "."
#!                     Windows-only restriction: Cannot end in "."
#!                     Disallowed values: "administrator", "admin", "user", "user1", "test", "user2", "test1",
#!                     "user3", "admin1", "1", "123", "a", "actuser", "adm", "admin2", "aspnet", "backup", "console",
#!                     "david", "guest", "john", "owner", "root", "server", "sql", "support", "support_388945a0",
#!                     "sys", "test2", "test3", "user4", "user5".
#! @input image: This is a custom property that contains the operating system and application configuration name that
#!               is used to create the virtual machine. You can enter either public image or private image name.
#! @input enable_public_ip: Create public ip for the VM if the value is true.
#! @input api_version: The API version used to create calls to Azure.Default: '2021-04-01'
#! @input dns_name: Specifies the domain name of the VM.
#!                  Optional
#! @input os_platform: Name of the operating system that will be installed
#!                     Valid values: 'Windows,'Linux'
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
#!                     Optional
#! @input ssh_publicKey_name: The name of the SSH public key.
#!                            Optional
#! @input disk_size: The size of the storage disk to be attach to the virtual machine.
#!                   Note: The value must be greater than '0'
#!                   Example: '1'
#!                   Optional
#! @input os_disk_name: Name of the VM disk used as a place to store operating system, applications and data.
#!                      Optional
#! @input data_disk_name: This is the name for the data disk which is a VHD that’s attached to a virtual machine to
#!                        store application data, or other data you need to keep.
#!                        Optional
#! @input tag_name_list: Name of the tag to be added to the virtual machine
#!                       Default: ''
#!                       Optional
#! @input tag_value_list: Value of the tag to be added to the virtual machine
#!                        Default: ''
#!                        Optional
#! @input connect_timeout: Time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#!                         Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
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
#!
#! @output vm_final_name: The final virtual machine name.
#! @output disk_name: Name of the data disk.
#! @output primary_dns_name: Specifies the domain name of the VM.
#! @output internal_fqdn: Fully qualified DNS name supporting internal communications between VMs in the same virtual network.
#! @output public_ip_address: This is the primary IP Address of the newly created VM
#! @output mac_address: Represents the primary MAC address of the VM.
#! @output nic_name: NIC name for the VM.
#! @output os_type: OS type of the VM.
#! @output power_state: Power state of the VM
#! @output private_ip_address: Private IP address of the IP configuration.
#! @output public_ip_address_name: Public IP Address name of the VM
#! @output vm_id: Unique id of the VM.
#! @output vm_resource_id: Resource Id of the VM.
#! @output return_result: It will contain the return result either success or failure
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
  avset: io.cloudslang.microsoft.azure.compute.virtual_machines.availability_sets
  flow: io.cloudslang.base.utils
  lists: io.cloudslang.base.lists
  vm: io.cloudslang.microsoft.azure.compute.virtual_machines
flow:
  name: azure_deploy_vm_v5
  inputs:
    - provider_sap:
        default: 'https://management.azure.com'
        required: true
    - subscription_id
    - tenant_id
    - client_secret:
        sensitive: true
    - client_id
    - location
    - resource_group_name
    - vm_name:
        required: true
    - vm_size
    - virtual_network_name
    - subnet_name
    - infrastructure_options
    - trust_password:
        required: false
        sensitive: true
    - availability_options
    - type_of_storage
    - vm_username
    - image
    - enable_public_ip: 'true'
    - api_version: '2021-04-01'
    - business_unit
    - product_id
    - product_name
    - environment
    - dns_name:
        required: false
    - os_platform:
        required: false
    - vm_password:
        required: false
        sensitive: true
    - ssh_publicKey_name:
        required: false
    - disk_size:
        default: '10'
        required: false
    - os_disk_name:
        required: false
    - data_disk_name:
        required: false
    - tag_name_list:
        required: false
    - tag_value_list:
        required: false
    - connect_timeout:
        default: '0'
        required: false
    - worker_group:
        default: RAS_Operator_Path
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
  workflow:
    - check_tagnames_tagvalues_equal:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.microsoft.azure.utils.check_tagnames_tagvalues_equal:
            - tag_name_list: '${tag_name_list}'
            - tag_value_list: '${tag_value_list}'
        publish:
          - return_result: '${error_message}'
        navigate:
          - SUCCESS: form_tags_json
          - FAILURE: FAILURE
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
          - SUCCESS: string_occurrence_counter_for_image
          - FAILURE: on_failure
    - create_public_ip:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          ip.create_public_ip_address:
            - vm_name: '${vm_name}'
            - location
            - subscription_id
            - resource_group_name
            - public_ip_address_name: '${vm_name}'
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
          - return_result: '${error_message}'
          - public_ip_address_name
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_network_interface
    - create_network_interface:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          nic.create_nic:
            - vm_name: '${vm_name}'
            - nic_name: '${vm_name}'
            - location
            - subscription_id
            - resource_group_name
            - public_ip_address_name: '${public_ip_address_name}'
            - virtual_network_name
            - subnet_name
            - dns_json: ''
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
          - return_result: '${error_message}'
          - nic_name
        navigate:
          - FAILURE: on_failure
          - SUCCESS: check_if_null_else_add_tags_1
    - random_number_generator:
        worker_group: '${worker_group}'
        do:
          math.random_number_generator:
            - min: '10000'
            - max: '99999'
        publish:
          - random_number
        navigate:
          - FAILURE: random_number_generator
          - SUCCESS: set_random_number
    - get_vm_details_1:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          vm.get_vm_details:
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
          - FAILURE: string_occurrence_counter
          - SUCCESS: check_if_vm_name_alerady_exists
    - string_occurrence_counter:
        worker_group: '${worker_group}'
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: '${vm_details}'
            - string_to_find: ResourceNotFound
        publish: []
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: check_dns_name
    - check_if_vm_name_alerady_exists:
        worker_group: '${worker_group}'
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
        worker_group: '${worker_group}'
        do:
          strings.string_equals:
            - string_in_which_to_search: '${vm_to_check}'
            - string_to_find: '${vm_name}'
            - ignore_case: 'true'
        publish: []
        navigate:
          - SUCCESS: same_name_error_msg
          - FAILURE: same_name_error_msg
    - same_name_error_msg:
        worker_group: '${worker_group}'
        do:
          strings.append:
            - origin_string: "${'A virtual machine with the name \"' + vm_name + '\" already exists.'}"
            - text: ''
        publish:
          - return_result: '${new_string}'
        navigate:
          - SUCCESS: FAILURE
    - create_vm:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.microsoft.azure.compute.virtual_machines.create_vm:
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
            - image_version: "${get('version', '')}"
            - plan: '${plan}'
            - private_image_name: '${private_image_name}'
            - data_disk_name: '${data_disk_name}'
            - os_disk_name: '${os_disk_name}'
            - disk_size_in_gb: '${disk_size}'
            - tag_key_list: '${key_list}'
            - tag_value_list: '${value_list}'
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
        navigate:
          - SUCCESS: get_vm_info
          - FAILURE: FAILURE
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
          - SUCCESS: check_vm_state_1
          - FAILURE: on_failure
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
            - second_string: Succeeded
        navigate:
          - SUCCESS: set_data_disk_name
          - FAILURE: compare_power_state
    - compare_power_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${expected_vm_state}'
            - second_string: Failed
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: counter
    - set_data_disk_name:
        worker_group: '${worker_group}'
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
        worker_group: '${worker_group}'
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
        worker_group: '${worker_group}'
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
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${os_type}'
            - second_string: Linux
            - ignore_case: 'true'
        navigate:
          - SUCCESS: set_unix_os_type
          - FAILURE: set_resource_id
    - set_unix_os_type:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - os_type: Unix
        publish:
          - os_type
        navigate:
          - SUCCESS: set_resource_id
          - FAILURE: on_failure
    - set_resource_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${vm_info}'
            - json_path: id
        publish:
          - vm_resource_id: '${return_result}'
        navigate:
          - SUCCESS: check_enable_public_ip_1
          - FAILURE: on_failure
    - check_enable_public_ip:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${enable_public_ip}'
            - second_string: 'true'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: create_public_ip
          - FAILURE: create_nic_without_public_ip
    - get_vm_public_ip_address:
        worker_group:
          value: '${worker_group}'
          override: true
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
          - return_result: '${error_message}'
        navigate:
          - SUCCESS: update_public_ip_address
          - FAILURE: on_failure
    - check_enable_public_ip_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${enable_public_ip}'
            - second_string: 'true'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: get_vm_public_ip_address
          - FAILURE: get_nic_name_info
    - update_public_ip_address:
        worker_group:
          value: '${worker_group}'
          override: true
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
        publish:
          - public_ip_json: '${update_public_ip_json}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: check_if_null_else_add_tags_2
    - set_dns_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${public_ip_json}'
            - json_path: 'properties,dnsSettings,fqdn'
        publish:
          - primary_dns_name: '${return_result}'
        navigate:
          - SUCCESS: get_nic_name_info
          - FAILURE: on_failure
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
        worker_group: '${worker_group}'
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
        worker_group: '${worker_group}'
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
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${nic_info_json}'
            - json_path: 'properties,ipConfigurations,0,properties,privateIPAddress'
        publish:
          - private_ip_address: '${return_result}'
        navigate:
          - SUCCESS: get_power_state
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
    - get_availability_set_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          avset.get_availability_set_details:
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
    - check_azure_availability_type:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${availability_options}'
            - second_string: Managed
            - ignore_case: 'true'
        navigate:
          - SUCCESS: set_storage_account_type_1
          - FAILURE: set_storage_type
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
    - set_storage_account_type:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - storage_account_type: '${type_of_storage}'
            - availability_set_name: '${availability_options}'
        publish:
          - storage_account_type
          - availability_set_name
        navigate:
          - SUCCESS: get_vm_details_1
          - FAILURE: on_failure
    - set_storage_type:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - storage_account: '${type_of_storage}'
            - disk_type: '${availability_options}'
        publish:
          - storage_account
          - disk_type
        navigate:
          - SUCCESS: get_vm_details_1
          - FAILURE: on_failure
    - set_storage_type_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - storage_account: '${type_of_storage}'
            - availability_set_name: '${availability_options}'
        publish:
          - storage_account
          - availability_set_name
        navigate:
          - SUCCESS: get_vm_details_1
          - FAILURE: on_failure
    - set_storage_account_type_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - storage_account_type: '${type_of_storage}'
            - disk_type: '${availability_options}'
        publish:
          - storage_account_type
          - disk_type
        navigate:
          - SUCCESS: get_vm_details_1
          - FAILURE: on_failure
    - set_random_number:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - vm_name: '${vm_name+random_number}'
        publish:
          - vm_name
          - vm_final_name: '${vm_name}'
        navigate:
          - SUCCESS: check_azure_infra_type
          - FAILURE: on_failure
    - get_azure_image_details:
        worker_group: '${worker_group}'
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
    - check_dns_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${dns_name}'
        navigate:
          - SUCCESS: set_default_dns_name
          - FAILURE: format_dns_name
    - set_default_dns_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - dns_name: '${vm_name.lower()}'
        publish:
          - dns_name
        navigate:
          - SUCCESS: check_enable_public_ip
          - FAILURE: on_failure
    - set_public_ip_address:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${public_ip_json}'
            - json_path: 'properties,ipAddress'
        publish:
          - public_ip_address: '${return_result}'
        navigate:
          - SUCCESS: set_dns_name
          - FAILURE: on_failure
    - create_nic_without_public_ip:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.compute.network.network_interface_card.create_nic_without_public_ip:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - nic_name: '${vm_name}'
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
            - dns_json: ''
        publish:
          - nic_state: '${output}'
          - nic_name
        navigate:
          - SUCCESS: check_if_null_else_add_tags
          - FAILURE: on_failure
    - get_power_state:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.compute.virtual_machines.get_power_state:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - auth_token: '${auth_token}'
            - vm_name: '${vm_name}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - proxy_port: '${proxy_port}'
            - proxy_host: '${proxy_host}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - power_state
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - string_occurrence_counter_for_image:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_occurrence_counter:
            - string_in_which_to_search: '${image}'
            - string_to_find: '#'
        publish:
          - image_count: '${return_result}'
        navigate:
          - SUCCESS: string_equals
          - FAILURE: set_private_image_name
    - string_equals:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${image_count}'
            - second_string: '4'
        navigate:
          - SUCCESS: get_azure_image_details
          - FAILURE: set_private_image_name
    - set_private_image_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - private_image_name: '${image}'
        publish:
          - private_image_name
        navigate:
          - SUCCESS: random_number_generator
          - FAILURE: on_failure
    - check_azure_availability_type_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${av_sku_type}'
            - second_string: Aligned
            - ignore_case: 'true'
        navigate:
          - SUCCESS: set_storage_account_type
          - FAILURE: set_storage_type_1
    - format_dns_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - dns_name: '${dns_name+random_number}'
        publish:
          - dns_name
        navigate:
          - SUCCESS: check_enable_public_ip
          - FAILURE: on_failure
    - check_if_null_else_add_tags:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.utils.check_if_null_else_add_tags:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - api_version: '${api_version}'
            - json_input_to_extract_res_id: '${nic_state}'
            - tag_name_list: '${key_list}'
            - tag_value_list: '${value_list}'
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
          - SUCCESS: create_vm
          - FAILURE: on_failure
    - check_if_null_else_add_tags_1:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.utils.check_if_null_else_add_tags:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - api_version: '${api_version}'
            - json_input_to_extract_res_id: '${nic_state}'
            - tag_name_list: '${key_list}'
            - tag_value_list: '${value_list}'
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
          - SUCCESS: create_vm
          - FAILURE: on_failure
    - check_if_null_else_add_tags_2:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.utils.check_if_null_else_add_tags:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - api_version: '${api_version}'
            - json_input_to_extract_res_id: '${public_ip_json}'
            - tag_name_list: '${key_list}'
            - tag_value_list: '${value_list}'
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
          - SUCCESS: set_public_ip_address
          - FAILURE: on_failure
    - form_tags_json:
        do:
          io.cloudslang.microsoft.azure.utils.form_tags_json:
            - tag_key_list: '${tag_name_list}'
            - tag_value_list: '${tag_value_list}'
            - organizational_key_list: 'business_unit,product_id,product_name,environment'
            - organizational_value_list: "${business_unit+','+product_id+','+product_name+','+environment}"
        publish:
          - tags_json
          - key_list
          - value_list
        navigate:
          - SUCCESS: get_auth_token_using_web_api
  outputs:
    - vm_final_name
    - disk_name
    - primary_dns_name
    - internal_fqdn
    - public_ip_address
    - mac_address
    - nic_name
    - os_type
    - power_state
    - private_ip_address
    - public_ip_address_name
    - vm_id
    - vm_resource_id
    - return_result
    - tags_json
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_auth_token_using_web_api:
        x: 40
        'y': 200
      string_occurrence_counter_for_image:
        x: 200
        'y': 360
      check_if_null_else_add_tags_1:
        x: 2680
        'y': 80
      get_nic_name_info:
        x: 4124
        'y': 421
      check_if_null_else_add_tags_2:
        x: 4600
        'y': 80
      get_azure_image_details:
        x: 575
        'y': 54
      create_network_interface:
        x: 2360
        'y': 40
      set_vm_id:
        x: 3276
        'y': 72
      set_mac_address:
        x: 4384
        'y': 428
      set_av_type:
        x: 1296
        'y': 63
      set_random_number:
        x: 733
        'y': 59
      set_private_image_name:
        x: 440
        'y': 480
      check_azure_availability_type_1:
        x: 1495
        'y': 65
      format_dns_name:
        x: 1929
        'y': 436
      check_enable_public_ip_1:
        x: 3977
        'y': 239
      get_availability_set_details:
        x: 1115
        'y': 61
      create_nic_without_public_ip:
        x: 2320
        'y': 200
      set_storage_type_1:
        x: 1687
        'y': 54
      set_storage_account_type:
        x: 1501
        'y': 266
      get_vm_info:
        x: 2880
        'y': 360
      string_equals:
        x: 360
        'y': 160
      get_power_state:
        x: 4989
        'y': 421
        navigate:
          d94e7007-27f0-efd5-326e-39456a688257:
            targetId: 82c1913f-cdac-2e76-7f3e-2101ef8159b2
            port: SUCCESS
      compare_power_state_1:
        x: 3120
        'y': 280
      same_name_error_msg:
        x: 1200
        'y': 640
        navigate:
          093c9e4c-4235-da76-0dc5-e9916e55281a:
            targetId: 71542ed1-a12e-a78a-93dc-0ab395ab81dd
            port: SUCCESS
      set_resource_id:
        x: 3774
        'y': 429
      check_azure_infra_type:
        x: 913
        'y': 62
      check_if_null_else_add_tags:
        x: 2560
        'y': 240
      check_vm_state_1:
        x: 3000
        'y': 360
      wait_before_check:
        x: 2880
        'y': 560
      get_vm_public_ip_address:
        x: 4121
        'y': 74
      form_tags_json:
        x: 40
        'y': 480
      check_if_vm_name_alerady_exists:
        x: 800
        'y': 400
      set_private_ip_address:
        x: 4790
        'y': 419
      get_vm_details_1:
        x: 1507
        'y': 462
        navigate:
          55f37d7c-bfc7-6aaa-af99-9096a1f8e04e:
            vertices:
              - x: 1200
                'y': 640
            targetId: check_if_vm_name_alerady_exists
            port: SUCCESS
      set_public_ip_address:
        x: 4800
        'y': 240
      set_data_disk_name:
        x: 3120
        'y': 80
      check_tagnames_tagvalues_equal:
        x: 40
        'y': 640
        navigate:
          04ce1317-aa66-cc7f-db14-ee4ea65c949c:
            targetId: 5a2a4ebe-486b-725e-ecac-a9a93fd49521
            port: FAILURE
      check_azure_availability_type:
        x: 916
        'y': 269
      check_dns_name:
        x: 1818
        'y': 267
      check_enable_public_ip:
        x: 2080
        'y': 200
      set_os_type:
        x: 3471
        'y': 72
      random_number_generator:
        x: 680
        'y': 520
      check_if_same_name:
        x: 919
        'y': 552
      create_vm:
        x: 2640
        'y': 480
        navigate:
          08656d34-125d-be06-5c89-d0cdd60a0349:
            targetId: 71542ed1-a12e-a78a-93dc-0ab395ab81dd
            port: FAILURE
      set_internal_fqdn:
        x: 4592
        'y': 420
      create_public_ip:
        x: 2200
        'y': 40
      set_unix_os_type:
        x: 3771
        'y': 71
      set_storage_type:
        x: 1125
        'y': 443
      string_occurrence_counter:
        x: 1703
        'y': 459
        navigate:
          825bb77f-26cd-30cb-5eba-48ab9e265502:
            targetId: 71542ed1-a12e-a78a-93dc-0ab395ab81dd
            port: FAILURE
      counter:
        x: 2200
        'y': 720
        navigate:
          d4c201c2-c085-ab46-f1b1-1fda0c1e7ed6:
            targetId: 71542ed1-a12e-a78a-93dc-0ab395ab81dd
            port: NO_MORE
      set_default_dns_name:
        x: 1948
        'y': 61
      update_public_ip_address:
        x: 4370
        'y': 72
      compare_power_state:
        x: 3120
        'y': 600
        navigate:
          17b65d54-4023-629b-2827-03b42ffc6e87:
            targetId: 54bcc09c-453d-b40c-63ed-411a76b73542
            port: SUCCESS
          939940be-dea1-2294-459e-7a36f75baaa4:
            vertices:
              - x: 2640
                'y': 800
            targetId: counter
            port: FAILURE
      check_os_type:
        x: 3604
        'y': 247
      set_dns_name:
        x: 4360
        'y': 240
      set_storage_account_type_1:
        x: 1124
        'y': 263
    results:
      SUCCESS:
        82c1913f-cdac-2e76-7f3e-2101ef8159b2:
          x: 5153
          'y': 421
      FAILURE:
        71542ed1-a12e-a78a-93dc-0ab395ab81dd:
          x: 1702
          'y': 652
        54bcc09c-453d-b40c-63ed-411a76b73542:
          x: 3280
          'y': 600
        5a2a4ebe-486b-725e-ecac-a9a93fd49521:
          x: 320
          'y': 640

