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
#! @description: This flow is used to get the list runs in workspace.
#!
#! @input tf_template_workspace_id: The terraform workspace ID.
#! @input tf_user_auth_token: The terraform user token.
#! @input proxy_host: Proxy server used to access the Terraform service.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Terraform service.
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
#! @output output_variable_key_list: It holds the information about the component properties creation.
#!
#! @result FAILURE: There was an error while creating the component properties using terraform variables.
#! @result SUCCESS: The component properties are successfully created.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows
flow:
  name: list_runs_in_template_workspace
  inputs:
    - tf_template_workspace_id
    - tf_user_auth_token
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
            - trust_keystore: '${trust_all_roots}'
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
            - headers: "${'content-type: application/vnd.api+json\\n'+'Authorization:Bearer '+tf_user_auth_token}"
        publish:
          - plan_details: '${return_result}'
        navigate:
          - SUCCESS: get_tf_output_variable
          - FAILURE: on_failure
    - get_tf_output_variable:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${plan_details}'
            - json_path: 'planned_values,outputs'
        publish:
          - output_variable_list: '${return_result}'
        navigate:
          - SUCCESS: get_output_variable_python
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
    - get_output_variable_python:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows.get_output_variable_python:
            - output_variable_list: '${output_variable_list}'
        publish:
          - output_variable_key_list: '${output_variable_key_list}'
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - output_variable_key_list
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
      get_tf_output_variable:
        x: 560
        'y': 120
      get_run_id_and_plan_id_python:
        x: 280
        'y': 120
      get_output_variable_python:
        x: 680
        'y': 120
        navigate:
          f42f973e-8947-b0e3-5760-7ff3afe3f8de:
            targetId: fb1b6ee0-e090-bf53-a6b8-3ce4a61afe14
            port: SUCCESS
    results:
      SUCCESS:
        fb1b6ee0-e090-bf53-a6b8-3ce4a61afe14:
          x: 800
          'y': 120
