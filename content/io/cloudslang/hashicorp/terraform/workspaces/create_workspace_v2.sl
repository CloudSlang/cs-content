#   Copyright 2023 Open Text
#   This program and the accompanying materials
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
#! @description: Creates a workspace which represent running infrastructure managed by Terraform.
#!
#! @input auth_token: The authorization token for terraform.
#! @input organization_name: The name of the organization.
#! @input terraform_version: The version of Terraform to use for this workspace. Upon creating a workspace, the latest
#!                           version is selected unless otherwise specified (e.g. "0.11.1").
#!                           Default: '1.2.0'
#! @input workspace_name: The name of the workspace, which can only include letters, numbers, -, and _. This will be
#!                        used as an identifier and must be unique in the organization.
#!                        Optional
#! @input workspace_description: A description of the workspace to be created.
#!                               Optional
#! @input auto_apply: Whether to automatically apply changes when a Terraform plan is successful, with some
#!                    exceptions.
#!                    Default: 'false'
#!                    Optional
#! @input file_triggers_enabled: Whether to filter runs based on the changed files in a VCS push. If enabled, the
#!                               working-directory and trigger-prefixes describe a set of paths which must contain
#!                               changes for a VCS push to trigger a run. If disabled, any push will trigger a run.
#!                               Default: 'true'
#!                               Optional
#! @input working_directory: A relative path that Terraform will execute within. This defaults to the root of your
#!                           repository and is typically set to a subdirectory matching the environment when multiple
#!                           environments exist within the same repository.
#!                           Optional
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
#!                             Default: 'true'
#!                             Optional
#! @input ingress_submodules: Whether submodules should be fetched when cloning the VCS repository.
#!                            Default: 'false'
#!                            Optional
#! @input vcs_repo_id: A reference to your VCS repository in the format :org/:repo where :org and :repo refer to the
#!                     organization and repository in your VCS provider.
#!                     Optional
#! @input oauth_token_id: The VCS Connection (OAuth Connection + Token) to use. This ID can be obtained from the
#!                        oauth-tokens endpoint.
#!                        Optional
#! @input vcs_branch_name: The repository branch that Terraform will execute from. If omitted or submitted as an empty
#!                         string, this defaults to the repository's default branch (e.g. master) .
#!                         Optional
#! @input request_body: The request body of the workspace.
#!                      Optional
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.
#!                         Default: '10000'
#!                         Optional
#! @input socket_timeout: The timeout for waiting for data (a maximum period inactivity between two consecutive data
#!                        packets), in seconds. A socketTimeout value of '0' represents an infinite timeout.
#!                        Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
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
#!
#! @output return_result: If successful, returns the complete API response. In case of an error this output will contain
#!                        the error message.
#! @output status_code: The HTTP status code for Terraform API request.
#! @output workspace_id: The Id of created workspace
#! @output return_code: If successful, returns 0. In case of an error returns -1.
#!
#! @result FAILURE: There was an error while executing the request.
#! @result SUCCESS: The request is successfully executed.
#!!#
########################################################################################################################

namespace: io.cloudslang.hashicorp.terraform.workspaces
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: create_workspace_v2
  inputs:
    - auth_token:
        sensitive: true
    - organization_name
    - terraform_version:
        default: 1.2.0
        required: true
    - workspace_name:
        required: false
        sensitive: false
    - workspace_description:
        required: false
    - auto_apply:
        default: 'false'
        required: false
    - file_triggers_enabled:
        default: 'true'
        required: false
    - working_directory:
        required: false
    - trigger_prefixes:
        required: false
    - queue_all_runs:
        default: 'false'
        required: false
    - speculative_enabled:
        default: 'true'
        required: false
    - ingress_submodules:
        default: 'false'
        required: false
    - vcs_repo_id:
        required: false
    - oauth_token_id:
        required: false
    - vcs_branch_name:
        required: false
    - request_body:
        required: false
    - connect_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
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
    - string_equals:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${request_body}'
        navigate:
          - SUCCESS: create_optional_property_json
          - FAILURE: api_to_create_workspace_with_request_body
    - create_optional_property_json:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.utils.create_optional_property_json:
            - terraform_version: '${terraform_version}'
            - workspace_description: '${workspace_description}'
            - working_directory: '${working_directory}'
            - trigger_prefixes: '${trigger_prefixes}'
            - vcs_repo_id: '${vcs_repo_id}'
            - oauth_token_id: '${oauth_token_id}'
            - vcs_branch_name: '${vcs_branch_name}'
            - ingress_submodules: '${ingress_submodules}'
        publish:
          - optional_property_json
        navigate:
          - SUCCESS: api_to_create_workspace_using_given_input_properties
    - api_to_create_workspace_with_request_body:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.utils.http_client_without_request_character_set:
            - url: "${'https://app.terraform.io/api/v2/organizations/'+organization_name+'/workspaces'}"
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - headers: "${'Authorization: Bearer ' + auth_token}"
            - body: '${request_body}'
            - content_type: application/vnd.api+json
            - method: POST
        publish:
          - return_result
          - status_code
          - return_code
        navigate:
          - SUCCESS: get_value
          - FAILURE: on_failure
    - api_to_create_workspace_using_given_input_properties:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.utils.http_client_without_request_character_set:
            - url: "${'https://app.terraform.io/api/v2/organizations/'+organization_name+'/workspaces'}"
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - headers: "${'Authorization: Bearer ' + auth_token}"
            - body: "${'{\"data\":{\"attributes\":{\"name\":\"' + workspace_name + '\",'+optional_property_json+',\"file-triggers-enabled\":'+file_triggers_enabled+',\"queue-all-runs\":'+queue_all_runs+',\"speculative-enabled\":'+speculative_enabled+',\"auto-apply\":'+auto_apply+'},\"type\":\"workspace\"}}'}"
            - content_type: application/vnd.api+json
            - method: POST
        publish:
          - return_result
          - status_code
          - return_code
        navigate:
          - SUCCESS: get_value
          - FAILURE: on_failure
    - get_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: 'data,id'
        publish:
          - workspace_id: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result
    - status_code
    - workspace_id
    - return_code
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      string_equals:
        x: 80
        'y': 120
      create_optional_property_json:
        x: 80
        'y': 320
      api_to_create_workspace_with_request_body:
        x: 360
        'y': 120
      api_to_create_workspace_using_given_input_properties:
        x: 360
        'y': 320
      get_value:
        x: 520
        'y': 120
        navigate:
          7b8500d4-e1a7-9984-b5a0-1bd866f4c3bd:
            targetId: 11110857-8b44-be82-ae47-d2b98712cd15
            port: SUCCESS
    results:
      SUCCESS:
        11110857-8b44-be82-ae47-d2b98712cd15:
          x: 520
          'y': 320
