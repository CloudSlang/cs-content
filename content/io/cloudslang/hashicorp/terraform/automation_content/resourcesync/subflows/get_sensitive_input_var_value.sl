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
#! @description: This flow is used to get the sensitive input workspace variable values.
#!
#! @input tf_template_workspace_id: The terraform workspace ID.
#! @input tf_user_auth_token: The user authorization token for terraform.
#! @input proxy_host: Proxy server used to access the Terraform service.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Terraform service.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
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
#! @output input_results_keyname: The input keyname.
#! @output input_results_keyvalue_list: The list of the key value.
#! @output input_keyname_keyvalue_list: The list of key names and values
#!
#! @result SUCCESS: The list of sensitive workspace variable values are retrieved successfully.
#! @result FAILURE: There was an error while getting sensitive workspace variable values.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows
flow:
  name: get_sensitive_input_var_value
  inputs:
    - tf_template_workspace_id
    - tf_user_auth_token:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - worker_group:
        default: RAS_Operator_Path
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
  workflow:
    - list_runs_in_template_workspace:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://app.terraform.io/api/v2/workspaces/'+tf_template_workspace_id+'/runs'}"
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
            - headers: "${'content-type: application/vnd.api+json\\n'+'Authorization:Bearer '+tf_user_auth_token}"
            - worker_group: '${worker_group}'
        publish:
          - run_list: '${return_result}'
        navigate:
          - SUCCESS: get_run_id_and_plan_id_python
          - FAILURE: on_failure
    - show_plan_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://app.terraform.io/api/v2/plans/'+tf_plan_id+'/json-output'}"
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
            - headers: "${'content-type: application/vnd.api+json\\n'+'Authorization:Bearer '+tf_user_auth_token}"
            - worker_group: '${worker_group}'
        publish:
          - plan_details: '${return_result}'
        navigate:
          - SUCCESS: get_all_input_variable
          - FAILURE: on_failure
    - get_all_input_variable:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${plan_details}'
            - json_path: variables
        publish:
          - input_results: '${return_result}'
        navigate:
          - SUCCESS: get_input_keyname_python
          - FAILURE: on_failure
    - get_run_id_and_plan_id_python:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows.get_run_id_and_plan_id_python:
            - run_list: '${run_list}'
        publish:
          - tf_run_id: '${tf_run_id}'
          - tf_plan_id: '${tf_plan_id}'
        navigate:
          - SUCCESS: show_plan_details
    - get_input_keyname_python:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows.get_input_keyname_python:
            - input_results: '${input_results}'
        publish:
          - input_keyname_keyvalue_list: '${result}'
          - input_results_keyname: '${input_results_keyname_list}'
          - input_results_keyvalue_list: '${input_results_keyvalue_list}'
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - input_results_keyname
    - input_results_keyvalue_list
    - input_keyname_keyvalue_list
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      list_runs_in_template_workspace:
        x: 120
        'y': 120
      show_plan_details:
        x: 440
        'y': 120
      get_all_input_variable:
        x: 560
        'y': 120
      get_run_id_and_plan_id_python:
        x: 280
        'y': 120
      get_input_keyname_python:
        x: 680
        'y': 120
        navigate:
          6acd93b8-9229-0a7c-3a84-cf9ac0ded55d:
            targetId: fb1b6ee0-e090-bf53-a6b8-3ce4a61afe14
            port: SUCCESS
    results:
      SUCCESS:
        fb1b6ee0-e090-bf53-a6b8-3ce4a61afe14:
          x: 800
          'y': 120
