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
#! @description: This flow checks if tag name list and tag value list are null, If not null it will set the tags else if
#! it is null it will skip and return to the end
#!
#! @input auth_token: Azure authorization Bearer token.
#! @input api_version: The API version used to create calls to Azure.
#!                       Default: '2021-04-01'
#! @input json_input_to_extract_res_id: The json ouput of the resource to which tags has to be added
#! @input tag_name_list: The list of tag_name for the tags.
#! @input tag_value_list: The list of tag_value for the given tag_name.
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
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#!
#! @output resource_id: The resource id.
#! @output return_result: This will contain the response entity.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output tags_json: A JSON output containing the information of the resource along with the tags added.
#!
#! @result SUCCESS: The request has been successfully sent.
#! @result FAILURE: An error occurred while trying to send the request.
#!!#
########################################################################################################################
namespace: io.cloudslang.microsoft.azure.utils
flow:
  name: check_if_null_else_add_tags
  inputs:
    - auth_token:
        sensitive: true
    - api_version: '2021-04-01'
    - json_input_to_extract_res_id
    - tag_name_list:
        required: false
    - tag_value_list:
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
    - check_tag_name_is_null:
        worker_group: RAS_Operator_Path
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${tag_name_list}'
        navigate:
          - IS_NULL: SUCCESS
          - IS_NOT_NULL: get_resId_from_json
    - get_resId_from_json:
        worker_group: RAS_Operator_Path
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${json_input_to_extract_res_id}'
            - json_path: id
        publish:
          - resource_id: '${return_result}'
        navigate:
          - SUCCESS: set_tag_on_a_resource
          - FAILURE: on_failure
    - set_tag_on_a_resource:
        worker_group:
          value: RAS_Operator_Path
          override: true
        do:
          io.cloudslang.microsoft.azure.tags.set_tag_on_a_resource:
            - resource_id: '${resource_id}'
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - api_version: '${api_version}'
            - tag_name_list: '${tag_name_list}'
            - tag_value_list: '${tag_value_list}'
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
        publish:
          - return_result
          - status_code
          - tags_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - resource_id
    - return_result
    - status_code
    - tags_json
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      check_tag_name_is_null:
        x: 200
        'y': 160
        navigate:
          5ff08931-316d-6ab9-3610-f43808f319d4:
            targetId: 98ccd5a3-e64a-866c-8a2f-e18d2c566742
            port: IS_NULL
      set_tag_on_a_resource:
        x: 600
        'y': 360
        navigate:
          19c26c65-06fb-721a-4120-5edf78ccae03:
            targetId: 98ccd5a3-e64a-866c-8a2f-e18d2c566742
            port: SUCCESS
      get_resId_from_json:
        x: 600
        'y': 160
    results:
      SUCCESS:
        98ccd5a3-e64a-866c-8a2f-e18d2c566742:
          x: 400
          'y': 360

