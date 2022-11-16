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
########################################################################################################################
#!!
#! @description: This operation can be used to add tags to the given scope.
#!
#! @input scope: The resource scope
#! @input auth_token: The authorization token for azure cloud.
#! @input api_version: The API version to use for this operation.
#! @input keys: The keys for the tags
#! @input values: The values for the given keys
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more thanone group simultaneously.Default: 'RAS_Operator_Path'Optional
#! @input proxy_host: Proxy server used to access the provider services.Optional
#! @input proxy_port: Proxy server port used to access the provider services.Optional
#! @input proxy_username: Proxy server user name.Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL.Default: 'false'Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name inthe subject's Common Name (CN) or subjectAltName field of the X.509 certificateValid: 'strict', 'browser_compatible', 'allow_all'Default: 'strict'Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates fromother parties that you expect to communicate with, or from Certificate Authorities thatyou trust to identify other parties.  If the protocol (specified by the 'url') is not'https' or if trust_all_roots is 'true' this input is ignored.Default value: '..JAVA_HOME/java/lib/security/cacerts'Format: Java KeyStore (JKS)Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is falseand trust_keystore is empty, trust_password default will be supplied.Optional
#!
#! @output return_result: This will contain the response entity.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output tags_json: A JSON containing the tags information.
#! @output result: The output containing the JSON of the list input passed
#!
#! @result FAILURE: An error occurred while trying to send the request.
#! @result SUCCESS: The request to create tags has been successfully sent.
#!!#
########################################################################################################################
namespace: io.cloudslang.microsoft.azure.compute.tags
flow:
  name: create_azure_tags_at_scope
  inputs:
    - scope
    - auth_token:
        sensitive: true
    - api_version:
        required: true
    - keys
    - values
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
    - list_to_json:
        worker_group: '${worker_group}'
        do:
          test.tags.list_to_json:
            - keys: '${keys}'
            - values: '${values}'
        publish:
          - result
        navigate:
          - SUCCESS: api_call_to_add_tags
    - api_call_to_add_tags:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_patch:
            - url: "${'https://management.azure.com/'+scope+'/providers/Microsoft.Resources/tags/default?api-version='+api_version+''}"
            - auth_type: anonymous
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - request_character_set: utf-8
            - headers: "${'Authorization: '+auth_token}"
            - body: "${'{\"operation\":\"Merge\",\"properties\":{\"tags\": '+ result+'}}'}"
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
            - message: The tags are sucessfully created/merged to the exisiting tags
            - tags_json: '${return_result}'
        publish:
          - return_result: '${message}'
          - tags_json
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result
    - status_code
    - tags_json
    - result
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      list_to_json:
        x: 40
        'y': 200
      api_call_to_add_tags:
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

