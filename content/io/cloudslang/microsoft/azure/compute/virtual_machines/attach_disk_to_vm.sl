#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: This operation can be used to add a virtual disk to a virtual machine
#!
#! @input subscription_id: The ID of the Azure Subscription on which the the disk will be attached to the VM.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to attach the disk to the VM.
#! @input auth_token: Azure authorization Bearer token
#! @input api_version: The API version used to create calls to Azure
#!                     Default: '2015-06-15'
#! @input vm_name: The name of the virtual machine to which the disk will be attached.
#!                 Virtual machine name cannot contain non-ASCII or special characters.
#! @input storage_account: The name of the storage account in which the OS and Storage disks of the VM should be created.
#! @input disk_name: Name of the virtual disk to be attached
#! @input disk_size: Size of the virtual disk to be attached
#! @input vm_name: Specifies the name of the virtual machine. This name should be unique within the resource group.\
#! @input location: Specifies the supported Azure location where the virtual disk will be attached to a VM.
#!                  This can be different from the location of the resource group.
#! @input connect_timeout: Optional - time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#! @input socket_timeout: Optional - time in seconds to wait for data to be retrieved
#!                        Default: '0' (infinite)
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
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - the password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!
#! @output output: json response with information about the added virtual disk to the virtual machine
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output error_message: If an error occurs while running the flow it will be populated in this output,
#!                        otherwise the output will be empty
#!
#! @result SUCCESS: virtual machine updated with the added virtual disk successfully.
#! @result FAILURE: There was an error while trying to add a virtual disk to the virtual machine.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.compute.virtual_machines

imports:
  strings: io.cloudslang.base.strings
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: attach_disk_to_vm

  inputs:
    - subscription_id
    - resource_group_name
    - auth_token
    - api_version:
        required: false
        default: '2015-06-15'
    - location
    - vm_name
    - storage_account
    - disk_name
    - disk_size
    - connect_timeout:
        default: "0"
        required: false
    - socket_timeout:
        default: "0"
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - proxy_port:
        default: "8080"
        required: false
    - proxy_host:
        required: false
    - trust_all_roots:
        default: "false"
        required: false
    - x_509_hostname_verifier:
        default: "strict"
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        default: ''
        required: false
        sensitive: true

  workflow:
    - attach_disk_to_vm:
        do:
          http.http_client_put:
            - url: >
                ${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' +
                resource_group_name + '/providers/Microsoft.Compute/virtualMachines/' + vm_name +
                '?validating=false&api-version=' + api_version}
            - body: >
                ${'{"name":"' + vm_name + '","location":"' + location +
                '","properties":{"storageProfile":{"dataDisks":[{"name":"' + disk_name + '","diskSizeGB":"' +
                disk_size + '","lun":0,"vhd":{"uri":"http://' + storage_account + '.blob.core.windows.net/vhds/' +
                disk_name + 'storageDisk.vhd"},"createOption":"empty"}]}}}'}
            - headers: "${'Authorization: ' + auth_token}"
            - auth_type: 'anonymous'
            - preemptive_auth: 'true'
            - content_type: 'application/json'
            - request_character_set: 'UTF-8'
            - connect_timeout
            - socket_timeout
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - output: ${return_result}
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: retrieve_error

    - retrieve_error:
        do:
          json.get_value:
            - json_input: ${output}
            - json_path: 'error,message'
        publish:
          - error_message: ${return_result}
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: FAILURE

  outputs:
    - output
    - status_code
    - error_message

  results:
    - SUCCESS
    - FAILURE
