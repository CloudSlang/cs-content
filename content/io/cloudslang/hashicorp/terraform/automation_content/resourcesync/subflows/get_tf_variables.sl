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
#! @description: This flow is used to get the terraform variable list.
#!
#! @input tf_user_auth_token: The terraform user token.
#! @input tf_template_organization_name: The terraform organization name.
#! @input tf_template_workspace_name: The terraform workspace name.
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
#! @output return_result: It holds the information about the component properties creation.
#! @output return_code: 0 if success, -1 if failure
#! @output error_message: If there is any error while running the flow, it will be populated, empty otherwise
#!
#! @result FAILURE: There was an error while creating the component properties using terraform variables.
#! @result SUCCESS: The component properties are successfully created.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows
flow:
  name: get_tf_variables
  inputs:
    - tf_user_auth_token:
        sensitive: true
    - tf_template_organization_name
    - tf_template_workspace_name
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
    - get_workspace_details:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.workspaces.get_workspace_details:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - organization_name: '${tf_template_organization_name}'
            - workspace_name: '${tf_template_workspace_name}'
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
          - tf_template_workspace_id: '${workspace_id}'
          - workspace_info: '${return_result}'
        navigate:
          - SUCCESS: get_template_vcs_repo_identifier
          - FAILURE: on_failure
    - get_template_vcs_repo_identifier:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${workspace_info}'
            - json_path: 'data,attributes,vcs-repo-identifier'
        publish:
          - tf_template_vcs_repo_identifier: '${return_result}'
        navigate:
          - SUCCESS: list_template_workspace_variables
          - FAILURE: on_failure
    - list_template_workspace_variables:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.workspaces.variables.list_workspace_variable:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - workspace_id: '${tf_template_workspace_id}'
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
          - tf_variables_list: '${return_result}'
        navigate:
          - SUCCESS: list_runs_in_template_workspace
          - FAILURE: on_failure
    - list_runs_in_template_workspace:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows.list_runs_in_template_workspace:
            - tf_template_workspace_id: '${tf_template_workspace_id}'
            - tf_user_auth_token: '${tf_user_auth_token}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - worker_group: '${worker_group}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password: '${trust_password}'
        publish:
          - output_variable_key_list: '${output_variable_key_list}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - tf_variables_list
    - tf_template_workspace_id
    - tf_template_vcs_repo_identifier
    - output_variable_key_list
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_workspace_details:
        x: 40
        'y': 160
      get_template_vcs_repo_identifier:
        x: 200
        'y': 160
      list_template_workspace_variables:
        x: 360
        'y': 160
      list_runs_in_template_workspace:
        x: 520
        'y': 160
        navigate:
          c1717730-22d4-a484-d82b-3837c77191bb:
            targetId: 8a94a410-8ddd-3c39-6651-daa852ea17f7
            port: SUCCESS
    results:
      SUCCESS:
        8a94a410-8ddd-3c39-6651-daa852ea17f7:
          x: 680
          'y': 160
