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
#! @description: The operation to create a virtual machine.
#!
#! @input subscription_id: Specifies the unique identifier of Azure subscription.
#! @input azure_protocol: Specifies a connection protocol.
#!                        Valid values: https, http
#!                        Default: https
#! @input azure_host: Specifies the Portal to which requests will be sent.
#!                    Default: management.azure.com
#! @input auth_token: The authorization token for azure.
#! @input api_version: Client Api Version.
#!                     Default: 2019-07-01
#!                     Optional
#! @input location: Specifies the Azure location where the resource exists.
#!                  Example: eastasia, westus, westeurope
#! @input resource_group_name: The name of the resource group that contains the resource. You can obtain this value from
#!                             the Azure Resource Manager API or the portal.
#! @input nic_name: This is the user entered NIC name for the VM.
#! @input vm_size: Size of the VM to be created. Options include A0 standard , A1 standard, D1 standard, D2 standard etc
#!                 
#! @input vm_name: Name of the VM Instance provided by the user.
#! @input admin_username: Admin Username of the VM to be provided by the User. The user name should not contain
#!                        uppercase characters A-Z, special characters except $. It should start with alphanumeric
#!                        characters and should not be any reserved word like a, admin, root, test etc.
#! @input availability_set_name: Name of the Availability set in which the VM  to be deploy.
#!                               Optional
#! @input disk_type: Type of disk.
#!                   Allowed Values: Managed, Unmanaged
#!                   Default: Managed
#!                   Optional
#! @input admin_password: Admin Password of the VM to be provided by the User. The password should be with character
#!                        length of 12-72. Password should be a combination of at least 1 lower case character, 1 upper
#!                        case character, 1 number, and 1 special character.
#!                        Optional
#! @input ssh_public_key_name: The name of the SSH public key.
#!                             Optional
#! @input storage_account: Name of the storageAccount. If availabilitySet is classic, then storageAccount is used.
#!                         Optional
#! @input storage_account_type: Type of the storageAccount. If availabilitySet is aligned, then storageAccountType is
#!                              used
#!                              Example: Standard_LRS
#!                              Optional
#! @input publisher: Publisher information of the OS Image for the VM.
#!                   Optional
#! @input offer: This contains partial OS image info.
#!               Optional
#! @input sku: A VM service is provisioned at a specific pricing tier or SKU. Options include Free, Basic, or Standard.
#!             Optional
#! @input image_version: Version of the image.
#!                       Default: latest
#!                       Optional
#! @input plan: Set to true when the image you are using requires a marketplace plan, otherwise set to false.
#!              Default: False
#!              Optional
#! @input private_image_name: Name of the private image.
#!                            Optional
#! @input data_disk_name: This is the name for the data disk which is a VHD that’s attached to a virtual machine to
#!                        store application data, or other data you need to keep.
#!                        Optional
#! @input os_disk_name: Name of the VM disk used as a place to store operating system, applications and data.
#!                      Optional
#! @input disk_size_in_gb: Size of the disk in GB. 
#!                         Default: 10
#!                         Optional
#! @input tag_key_list: The keys of the tags that you want to add to your instance. The length of this list must be
#!                      equal to the length of the list contained by the tagValueList input. Use the tag key Name in
#!                      this list if you want to set a specific instance name and it will remain unchanged, will not
#!                      receive the suffix as in case of the instanceName input.
#!                      Optional
#! @input tag_value_list: The values for the keys provided in the tagKeyList. The lengths of these two list must be the
#!                        same, and the order of the tag values has to correspond the order of the tag keys.
#!                        Optional
#! @input proxy_host: Proxy server used to access the Azure service.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Azure service.
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
#!
#! @output return_result: If successful, returns the complete API response. In case of an error this output will contain
#!                        the error message.
#! @output exception: An error message in case there was an error while executing the request.
#! @output status_code: The HTTP status code for Azure API request.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.compute.virtual_machines

operation: 
  name: create_vm
  
  inputs: 
    - subscription_id    
    - subscriptionId: 
        default: ${get('subscription_id', '')}
        private: true 
    - azure_protocol    
    - azureProtocol: 
        default: ${get('azure_protocol', '')}
        private: true 
    - azure_host    
    - azureHost: 
        default: ${get('azure_host', '')}
        private: true 
    - auth_token:    
        sensitive: true
    - authToken: 
        default: ${get('auth_token', '')}
        private: true 
        sensitive: true
    - api_version:  
        required: false  
    - apiVersion: 
        default: ${get('api_version', '')}
        private: true 
    - location    
    - resource_group_name    
    - resourceGroupName: 
        default: ${get('resource_group_name', '')}
        private: true 
    - nic_name    
    - nicName: 
        default: ${get('nic_name', '')}
        private: true 
    - vm_size    
    - vmSize: 
        default: ${get('vm_size', '')}
        private: true 
    - vm_name    
    - vmName: 
        default: ${get('vm_name', '')}
        private: true 
    - admin_username    
    - adminUsername: 
        default: ${get('admin_username', '')}
        private: true 
    - availability_set_name:  
        required: false  
    - availabilitySetName: 
        default: ${get('availability_set_name', '')}  
        required: false 
        private: true 
    - disk_type:  
        required: false  
    - diskType: 
        default: ${get('disk_type', '')}  
        required: false 
        private: true 
    - admin_password:  
        required: false  
        sensitive: true
    - adminPassword: 
        default: ${get('admin_password', '')}  
        required: false 
        private: true 
        sensitive: true
    - ssh_public_key_name:  
        required: false  
    - sshPublicKeyName: 
        default: ${get('ssh_public_key_name', '')}  
        required: false 
        private: true 
    - storage_account:  
        required: false  
    - storageAccount: 
        default: ${get('storage_account', '')}  
        required: false 
        private: true 
    - storage_account_type:  
        required: false  
    - storageAccountType: 
        default: ${get('storage_account_type', '')}  
        required: false 
        private: true 
    - publisher:  
        required: false  
    - offer:  
        required: false  
    - sku:  
        required: false  
    - image_version:  
        required: false  
    - imageVersion: 
        default: ${get('image_version', '')}  
        required: false 
        private: true 
    - plan:  
        required: false  
    - private_image_name:  
        required: false  
    - privateImageName: 
        default: ${get('private_image_name', '')}  
        required: false 
        private: true 
    - data_disk_name:  
        required: false  
    - dataDiskName: 
        default: ${get('data_disk_name', '')}  
        required: false 
        private: true 
    - os_disk_name:  
        required: false  
    - osDiskName: 
        default: ${get('os_disk_name', '')}  
        required: false 
        private: true 
    - disk_size_in_gb:  
        required: false  
    - diskSizeInGB: 
        default: ${get('disk_size_in_gb', '')}  
        required: false 
        private: true 
    - tag_key_list:  
        required: false  
    - tagKeyList: 
        default: ${get('tag_key_list', '')}  
        required: false 
        private: true 
    - tag_value_list:  
        required: false  
    - tagValueList: 
        default: ${get('tag_value_list', '')}  
        required: false 
        private: true 
    - proxy_host:  
        required: false  
    - proxyHost: 
        default: ${get('proxy_host', '')}  
        required: false 
        private: true 
    - proxy_port:  
        required: false  
    - proxyPort: 
        default: ${get('proxy_port', '')}  
        required: false 
        private: true 
    - proxy_username:  
        required: false  
    - proxyUsername: 
        default: ${get('proxy_username', '')}  
        required: false 
        private: true 
    - proxy_password:  
        required: false  
        sensitive: true
    - proxyPassword: 
        default: ${get('proxy_password', '')}  
        required: false 
        private: true 
        sensitive: true
    - trust_all_roots:  
        required: false  
    - trustAllRoots: 
        default: ${get('trust_all_roots', '')}  
        required: false 
        private: true 
    - x_509_hostname_verifier:  
        required: false  
    - x509HostnameVerifier: 
        default: ${get('x_509_hostname_verifier', '')}  
        required: false 
        private: true 
    - trust_keystore:  
        required: false  
    - trustKeystore: 
        default: ${get('trust_keystore', '')}  
        required: false 
        private: true 
    - trust_password:  
        required: false  
        sensitive: true
    - trustPassword: 
        default: ${get('trust_password', '')}  
        required: false 
        private: true 
        sensitive: true
    
  java_action: 
    gav: 'io.cloudslang.content:cs-azure:0.0.14'
    class_name: 'io.cloudslang.content.azure.actions.compute.virtualmachines.CreateVM'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - exception: ${get('exception', '')} 
    - status_code: ${get('statusCode', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
