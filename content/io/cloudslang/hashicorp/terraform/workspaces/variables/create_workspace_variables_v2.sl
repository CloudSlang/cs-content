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
#! @description: Creates  multiple sensitive and non-sensitive variables or both in a workspace.
#!
#! @input auth_token: The authorization token for terraform.
#! @input workspace_id: The Id of the workspace
#! @input sensitive_workspace_variables_json: List of sensitive workspace variables in json format.
#!                                            Optional
#! @input workspace_variables_json: List of workspace variables in json format.
#!                                  Example: '[{"propertyName":"xxx","propertyValue":"xxxx","HCL":false,"Category":"terraform"}]'
#!                                  Optional
#! @input proxy_host: Proxy server used to access the Terraform service.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Terraform service.
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
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#!
#! @output create_workspace_variables_output: If successful, returns the complete API response. In case of an error this output will contain
#!                                            the error message.
#! @output status_code: The HTTP status code for Terraform API request.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.hashicorp.terraform.workspaces.variables
flow:
  name: create_workspace_variables_v2
  inputs:
    - auth_token:
        sensitive: true
    - workspace_id
    - sensitive_workspace_variables_json:
        required: false
    - workspace_variables_json:
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
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - create_workspace_variables_request_body:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.utils.create_workspace_variables_request_body:
            - workspace_variables_json: '${workspace_variables_json}'
            - sensitive_workspace_variables_json: '${sensitive_workspace_variables_json}'
        publish:
          - return_result
        navigate:
          - SUCCESS: list_iterator
    - list_iterator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${return_result}'
        publish:
          - result_string
        navigate:
          - HAS_MORE: api_to_create_workspace_variables
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - api_to_create_workspace_variables:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.utils.http_client_without_request_character_set:
            - url: "${'https://app.terraform.io/api/v2/workspaces/'+workspace_id+'/vars'}"
            - auth_type: anonymous
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
            - headers: "${'Authorization: Bearer ' + auth_token}"
            - body: "${'{\"data\":{\"attributes\":{\"key\":\"'+result_string.split(\":::\")[0]+'\",\"value\":\"'+result_string.split(\":::\")[1]+'\",\"category\":\"'+result_string.split(\":::\")[3]+'\",\"hcl\":'+result_string.split(\":::\")[2].lower()+',\"sensitive\":'+result_string.split(\":::\")[4]+'},\"type\":\"vars\"}}'}"
            - content_type: application/vnd.api+json
            - method: POST
        publish:
          - create_workspace_variables_output: '${return_result}'
          - status_code
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
  outputs:
    - create_workspace_variables_output
    - status_code
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      create_workspace_variables_request_body:
        x: 40
        'y': 200
      list_iterator:
        x: 200
        'y': 200
        navigate:
          0b079cdd-c42b-8bd5-3338-78033b307c98:
            targetId: 5d63388e-9406-04b3-ff68-c3e42a819dc7
            port: NO_MORE
      api_to_create_workspace_variables:
        x: 400
        'y': 200
    results:
      SUCCESS:
        5d63388e-9406-04b3-ff68-c3e42a819dc7:
          x: 200
          'y': 400
