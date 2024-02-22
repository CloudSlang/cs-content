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
#! @description: This operation can be used to delete suppression.
#!
#! @input auth_token: Azure authorization Bearer token.
#! @input name: The name of the Azure Resource Group that should be used to create the VM.
#! @input recommendation_id: The ID of the Azure Subscription on which the VM should be created.
#! @input resource_uri: Specifies the name of the virtual machine. This name should be unique within the resource group.
#! @input api_version: The API version used to create calls to Azure.Default: '2023-01-01'
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
#! @output return_result: A JSON containing the vm information.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#!
#! @result FAILURE: An error occurred while trying to send the request.
#! @result SUCCESS: The request to delete suppression has been successfully sent.
#!!#
########################################################################################################################
namespace: io.cloudslang.microsoft.azure.advisor.recommendations.suppressions
flow:
  name: delete_suppression
  inputs:
    - auth_token:
        sensitive: true
    - name
    - recommendation_id
    - resource_uri
    - api_version:
        default: '2023-01-01'
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
    - api_call_to_delete_suppression:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_delete:
            - url: "${'https://management.azure.com/'+resource_uri+'/providers/Microsoft.Advisor/recommendations/'+recommendation_id+'/suppressions/'+name+'?api-version='+api_version}"
            - auth_type: anonymous
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - request_character_set: utf-8
            - headers: "${'Authorization: ' + auth_token}"
            - content_type: application/json
            - worker_group: '${worker_group}'
        publish:
          - return_result
        navigate:
          - SUCCESS: set_success_message
          - FAILURE: on_failure
    - set_success_message:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - message: The delete suppression has been successfully done
            - json: '${return_result}'
        publish:
          - return_result: '${json}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result
    - status_code
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      set_success_message:
        x: 560
        'y': 200
        navigate:
          ed7c7b38-df18-5e0f-78ce-9be99fa19bb9:
            targetId: f1f62123-69ac-dd17-a1d9-3209ada7e80a
            port: SUCCESS
      api_call_to_delete_suppression:
        x: 320
        'y': 200
    results:
      SUCCESS:
        f1f62123-69ac-dd17-a1d9-3209ada7e80a:
          x: 760
          'y': 200

