#   (c) Copyright 2024 Micro Focus, L.P.
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
#! @description: This operation can be used to resize a vm .
#!
#! @input auth_token: Azure authorization Bearer token.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to create the VM.
#! @input subscription_id: The ID of the Azure Subscription on which the VM should be created.
#! @input vm_name: Specifies the name of the virtual machine. This name should be unique within the resource group.
#! @input location: Specifies the supported Azure location where the virtual machine should be created.This can be different from the location of the resource group.
#! @input vm_size: The name of the standard Azure VM size to be applied to the VM.Example: 'Standard_DS1_v2','Standard_D2_v2','Standard_D3_v2'Default: 'Standard_DS1_v2'
#! @input api_version: The API version used to create calls to Azure.
#!                     Default: '2021-04-01'
#! @input worker_group: Optional - A worker group is a logical collection of workers.
#!                      A worker may belong to more than one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
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
#! @output return_result: This will contain the response entity.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output json: A JSON containing the vm information.
#!
#! @result FAILURE: An error occurred while trying to send the request.
#! @result SUCCESS: The request to resize vm has been successfully sent.
#!!#
########################################################################################################################
namespace: io.cloudslang.microsoft.azure.compute.virtual_machines
flow:
  name: resize_vm
  inputs:
    - auth_token:
        sensitive: true
    - resource_group_name
    - subscription_id
    - vm_name
    - location
    - vm_size
    - api_version:
        default: '2021-04-01'
        required: true
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
    - api_call_to_resize_vm:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_patch:
            - url: "${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' + resource_group_name + '/providers/Microsoft.Compute/virtualMachines/' + vm_name + '?api-version=' + api_version}"
            - auth_type: anonymous
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - request_character_set: utf-8
            - headers: "${'Authorization: '+auth_token}"
            - body: "${'{\"properties\": { \"hardwareProfile\": { \"vmSize\": \"'+vm_size+'\" }},\"location\": \"'+location+'\"}'}"
            - content_type: application/json
        publish:
          - return_result
          - status_code
          - error_message
        navigate:
          - SUCCESS: set_success_message
          - FAILURE: on_failure
    - set_success_message:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - message: The vm has been successfully resized
            - json: '${return_result}'
        publish:
          - return_result: '${message}'
          - json
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result
    - status_code
    - json
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      api_call_to_resize_vm:
        x: 200
        'y': 200
      set_success_message:
        x: 360
        'y': 200
        navigate:
          ed7c7b38-df18-5e0f-78ce-9be99fa19bb9:
            targetId: f1f62123-69ac-dd17-a1d9-3209ada7e80a
            port: SUCCESS
    results:
      SUCCESS:
        f1f62123-69ac-dd17-a1d9-3209ada7e80a:
          x: 560
          'y': 200

