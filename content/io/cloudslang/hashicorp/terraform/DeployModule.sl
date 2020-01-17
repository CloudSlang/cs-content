#   (c) Copyright 2020 Micro Focus, L.P.
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
#! @description: deploy's the module in the given organization.
#!
#! @input auth_token: The authorization token for terraform.
#! @input organization_name: The name of the organization
#! @input workspace_name: The name of the workspace, which can only include letters, numbers, -, and _. This will be
#!                        used as an identifier and must be unique in the organization.
#!                        Optional
#! @input workspace_description: A description of the workspace to be created.
#!                               Optional
#! @input vcs_repo_id: A reference to your VCS repository in the format :org/:repo where :org and :repo refer to the
#!                     organization and repository in your VCS provider.
#!                     Optional
#! @input working_directory: A relative path that Terraform will execute within. This defaults to the root of your
#!                           repository and is typically set to a subdirectory matching the environment when multiple
#!                           environments exist within the same repository.
#!                           Optional
#! @input variable_category: Whether this is a Terraform or environment variable. Valid values are "terraform" or "env".
#!                           Optional
#! @input auto_apply: Whether to automatically apply changes when a Terraform plan is successful, with some
#!                    exceptions.
#!                    Default: 'false'
#!                    Optional
#! @input trigger_prefixes: List of repository-root-relative paths which should be tracked for changes, in addition to
#!                          the working directory.
#!                          Optional
#! @input queue_all_runs: Whether runs should be queued immediately after workspace creation. When set to false, runs
#!                        triggered by a VCS change will not be queued until at least one run is manually
#!                        queued.
#!                        Default: 'false'
#!                        Optional
#! @input speculative_enabled: Whether this workspace allows speculative plans. Setting this to false prevents Terraform
#!                             Cloud from running plans on pull requests, which can improve security if the VCS
#!                             repository is public or includes untrusted contributors.
#!                               Default: 'true'
#!                             Optional
#! @input ingress_submodules: Whether submodules should be fetched when cloning the VCS repository.
#!                            Default: 'false'
#!                            Optional
#! @input vcs_branch_name: The repository branch that Terraform will execute from. If omitted or submitted as an empty
#!                         string, this defaults to the repository's default branch (e.g. master) .
#!                         Optional
#! @input terraform_version: The version of Terraform to use for this workspace. Upon creating a workspace, the latest
#!                           version is selected unless otherwise specified (e.g. "0.11.1").
#!                           Default: '0.12.1'
#!                           Optional
#! @input run_message: Specifies the message to be associated with this run
#!                     Optional
#! @input is_destroy: Specifies if this plan is a destroy plan, which will destroy all provisioned resources.
#!                    Optional
#! @input sensitive: Whether the value is sensitive. If true then the variable is written once and not visible
#!                   thereafter.
#!                   Optional
#! @input hcl: Whether to evaluate the value of the variable as a string of HCL code. Has no effect for environment
#!             variables.
#!             Optional
#! @input run_comment: Specifies the comment to be associated with this run
#!                     Optional
#! @input variables_json: List of variables in json format.
#!                        Optional
#!                        Example: '[{"propertyName":"xxx","propertyValue":"xxxx","HCL":false,"Category":"terraform"}]'
#! @input sensitive_variables_json: List of sensitive variables in json format.
#!                                  Optional
#!                                  Example: '[{"propertyName":"xxx","propertyValue":"xxxx","HCL":false,
#!                                            "Category":"terraform"}]'
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
#!                        Default: 'false'
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
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.
#!                         Default: '10000'
#!                         Optional
#! @input socket_timeout: The timeout for waiting for data (a maximum period inactivity between two consecutive data
#!                        packets), in seconds. A socketTimeout value of '0' represents an infinite timeout.
#!                        Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls. If
#!                    keepAlive is false, the already open connection will be used and after execution it will close it.
#!                   Default: 'true'
#!                    Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.
#!                                   Default: '2'
#!                                   Optional
#! @input connections_max_total: The maximum limit of connections in total.
#!                              Default: '20'
#!                               Optional
#! @input response_character_set: The character encoding to be used for the HTTP response. If responseCharacterSet is
#!                                empty, the charset from the 'Content-Type' HTTP response header will be used. If
#!                                responseCharacterSet is empty and the charset from the HTTP response Content-Type
#!                                header is empty, the default value will be used. You should not use this for
#!                                method=HEAD or OPTIONS.
#!                                Default: 'UTF-8'
#!                                Optional
#!
#! @output hosted_state_download_url: A url from which you can download the raw state.
#! @output state_version_id: The ID of the desired state version.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform
flow:
  name: DeployModule
  inputs:
    - auth_token:
        sensitive: true
    - organization_name
    - workspace_name
    - vcs_repo_id
    - variables_json:
        required: true
    - sensitive_variables_json:
        required: true
        sensitive: true
    - is_destroy:
        required: false
    - auto_apply:
        required: false
    - workspace_description:
        required: false
    - working_directory:
        required: false
    - variable_category:
        required: false
    - trigger_prefixes:
        required: false
    - queue_all_runs:
        required: false
    - speculative_enabled:
        required: false
    - ingress_submodules:
        required: false
    - vcs_branch_name:
        required: false
    - terraform_version:
        required: false
    - run_message:
        required: false
    - run_comment:
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
        required: false
    - x_509_hostname_verifier:
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - connect_timeout:
        required: false
    - keep_alive:
        required: false
    - connections_max_per_route:
        required: false
    - connections_max_total:
        required: false
    - response_character_set:
        required: false
  workflow:
    - list_o_auth_client:
        do:
          io.cloudslang.hashicorp.terraform.utils.list_o_auth_client:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - organization_name: '${organization_name}'
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        publish:
          - oauth_token_id
        navigate:
          - SUCCESS: create_workspace
          - FAILURE: on_failure
    - create_workspace:
        do:
          io.cloudslang.hashicorp.terraform.workspaces.create_workspace:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - organization_name: '${organization_name}'
            - workspace_name: '${workspace_name}'
            - workspace_description: '${workspace_description}'
            - auto_apply: '${auto_apply}'
            - file_triggers_enabled: '${file_triggers_enabled}'
            - working_directory: '${working_directory}'
            - trigger_prefixes: '${trigger_prefixes}'
            - queue_all_runs: '${queue_all_runs}'
            - speculative_enabled: '${speculative_enabled}'
            - ingress_submodules: '${ingress_submodules}'
            - vcs_repo_id: '${vcs_repo_id}'
            - vcs_branch_name: '${vcs_branch_name}'
            - oauth_token_id: '${oauth_token_id}'
            - terraform_version: '${terraform_version}'
            - request_body: null
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        publish:
          - workspace_id
        navigate:
          - SUCCESS: create_variables
          - FAILURE: on_failure
    - create_variables:
        do:
          io.cloudslang.hashicorp.terraform.variables.create_variables:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - workspace_id: '${workspace_id}'
            - variables_json: '${variables_json}'
            - sensitive_variables_json:
                value: '${sensitive_variables_json}'
                sensitive: true
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        navigate:
          - SUCCESS: create_run
          - FAILURE: on_failure
    - create_run:
        do:
          io.cloudslang.hashicorp.terraform.runs.create_run:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - workspace_id: '${workspace_id}'
            - run_message: '${run_message}'
            - is_destroy: '${is_destroy}'
            - request_body: null
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        publish:
          - run_id
        navigate:
          - SUCCESS: is_auto_apply_true
          - FAILURE: on_failure
    - is_auto_apply_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${auto_apply}'
        navigate:
          - 'TRUE': get_run_details_for_get_state_version_details
          - 'FALSE': get_run_details
    - get_run_details:
        do:
          io.cloudslang.hashicorp.terraform.runs.get_run_details:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - run_id: '${run_id}'
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        publish:
          - return_result
        navigate:
          - SUCCESS: get_run_status_value
          - FAILURE: on_failure
    - get_run_status_value:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: 'data,attributes,status'
        publish:
          - plan_status: '${return_result}'
        navigate:
          - SUCCESS: run_status
          - FAILURE: on_failure
    - run_status:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${plan_status}'
            - second_string: planned
        navigate:
          - SUCCESS: apply_run
          - FAILURE: counter_for_run_status
    - counter_for_run_status:
        do:
          io.cloudslang.hashicorp.terraform.utils.counter:
            - from: '1'
            - to: '100'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: wait_for_plan_status
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - wait_for_plan_status:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: get_run_details
          - FAILURE: on_failure
    - apply_run:
        do:
          io.cloudslang.hashicorp.terraform.runs.apply_run:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - run_id: '${run_id}'
            - run_comment: '${run_comment}'
            - request_body: null
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        publish: []
        navigate:
          - SUCCESS: get_run_details_for_get_state_version_details
          - FAILURE: on_failure
    - get_current_state_version:
        do:
          io.cloudslang.hashicorp.terraform.stateversions.get_current_state_version:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - workspace_id: '${workspace_id}'
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        publish:
          - hosted_state_download_url
          - state_version_id
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_run_details_for_get_state_version_details:
        do:
          io.cloudslang.hashicorp.terraform.runs.get_run_details:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - run_id: '${run_id}'
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
        publish:
          - return_result
        navigate:
          - SUCCESS: get_run_status_value_state_version
          - FAILURE: on_failure
    - get_run_status_value_state_version:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: 'data,attributes,status'
        publish:
          - plan_status: '${return_result}'
        navigate:
          - SUCCESS: run_status_for_get_state_version_details
          - FAILURE: on_failure
    - run_status_for_get_state_version_details:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${plan_status}'
            - second_string: applied
        navigate:
          - SUCCESS: get_current_state_version
          - FAILURE: counter_for_get_state_version_details
    - counter_for_get_state_version_details:
        do:
          io.cloudslang.hashicorp.terraform.utils.counter:
            - from: '1'
            - to: '100'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: wait_for_get_state_version_details
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - wait_for_get_state_version_details:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: get_run_details_for_get_state_version_details
          - FAILURE: on_failure
  outputs:
    - hosted_state_download_url: '${hosted_state_download_url}'
    - state_version_id: '${state_version_id}'
  results:
    - FAILURE
    - SUCCESS
