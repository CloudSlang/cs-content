#   Copyright 2024 Open Text
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
#! @description: This flow updates the module in the given organization.
#!
#! @input auth_token: The authorization token for terraform.
#! @input organization_name: The name of the organization
#! @input workspace_name: The name of the workspace, which can only include letters, numbers, -, and _. This will be
#!                        used as an identifier and must be unique in the organization.
#!                        Optional
#! @input workspace_variables_json: List of variables in json format.
#!                                  Example: '[{"propertyName":"xxx","propertyValue":"xxxx","HCL":false,"sensitive":false}]'
#!                                  Optional
#! @input sensitive_workspace_variables_json: List of sensitive variables in json format.
#!                                            Example: '[{"propertyName":"xxx","propertyValue":"xxxx","HCL":false,
#!                                            "sensitive":false}]'
#!                                            Optional
#! @input is_destroy: Specifies if this plan is a destroy plan, which will destroy all provisioned resources.
#!                    Optional
#! @input run_message: Specifies the message to be associated with this run
#!                     Optional
#! @input run_comment: Specifies the comment to be associated with this run
#!                     Optional
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
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.
#!                         Default: '10000'
#!                         Optional
#! @input socket_timeout: The timeout for waiting for data (a maximum period inactivity between two consecutive data
#!                        packets), in seconds. A socketTimeout value of '0' represents an infinite timeout.
#!                        Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls. If
#!                    keepAlive is false, the already open connection will be used and after execution it will close it.
#!                    Default: 'true'
#!                    Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.
#!                                   Default: '2'
#!                                   Optional
#! @input connections_max_total: The maximum limit of connections in total.
#!                               Default: '20'
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
#! @result FAILURE: There was an error while executing the request.
#! @result SUCCESS: The request was successfully executed.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform
flow:
  name: UpdateModuleV2
  inputs:
    - auth_token:
        sensitive: true
    - organization_name
    - workspace_name
    - workspace_variables_json:
        required: true
    - sensitive_workspace_variables_json:
        required: false
        sensitive: true
    - is_destroy:
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
        default: 'false'
    - x_509_hostname_verifier:
        required: false
        default: 'strict'
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - connect_timeout:
        required: false
    - socket_timeout:
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
    - get_workspace_details:
        do:
          io.cloudslang.hashicorp.terraform.workspaces.get_workspace_details:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - organization_name: '${organization_name}'
            - workspace_name: '${workspace_name}'
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
          - return_result
        navigate:
          - SUCCESS: get_auto_apply_value
          - FAILURE: on_failure
    - get_run_status_value_to_get_current_state_version_details:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: 'data,attributes,status'
        publish:
          - plan_status: '${return_result}'
        navigate:
          - SUCCESS: run_status_to_get_current_state_version_details
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
        publish: []
        navigate:
          - 'TRUE': get_run_details_to_get_current_state_version_details
          - 'FALSE': get_run_details
    - wait_for_plan_status:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: get_run_details
          - FAILURE: on_failure
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
          - FAILURE: counter_for_plan_status
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
          - SUCCESS: get_run_details_to_get_current_state_version_details
          - FAILURE: on_failure
    - wait_for_apply_state:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: get_run_details_to_get_current_state_version_details
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
    - get_auto_apply_value:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: 'data,attributes,auto-apply'
        publish:
          - auto_apply: '${return_result}'
        navigate:
          - SUCCESS: update_workspace_variables
          - FAILURE: on_failure
    - counter_for_plan_status:
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
    - run_status_to_get_current_state_version_details:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${plan_status}'
            - second_string: applied
        navigate:
          - SUCCESS: get_current_state_version
          - FAILURE: counter_for_apply_state
    - get_run_details_to_get_current_state_version_details:
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
          - SUCCESS: get_run_status_value_to_get_current_state_version_details
          - FAILURE: on_failure
    - counter_for_apply_state:
        do:
          io.cloudslang.hashicorp.terraform.utils.counter:
            - from: '1'
            - to: '100'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: wait_for_apply_state
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - update_workspace_variables:
        do:
          io.cloudslang.hashicorp.terraform.workspaces.variables.update_workspace_variables:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - workspace_id: '${workspace_id}'
            - workspace_variables_json: '${workspace_variables_json}'
            - sensitive_workspace_variables_json:
                value: '${sensitive_workspace_variables_json}'
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
  outputs:
    - hosted_state_download_url: '${hosted_state_download_url}'
    - state_version_id: '${state_version_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      wait_for_apply_state:
        x: 924
        'y': 297
      get_run_status_value:
        x: 627
        'y': 281
      get_run_details:
        x: 454
        'y': 279
      run_status:
        x: 816
        'y': 457
      counter_for_apply_state:
        x: 924
        'y': 469
        navigate:
          f0006fdc-5a3f-d205-a06e-a37922490b8a:
            targetId: d3e056e0-382d-820b-a4f0-98703bcb5211
            port: NO_MORE
      wait_for_plan_status:
        x: 457
        'y': 466
      create_run:
        x: 456
        'y': 111
      counter_for_plan_status:
        x: 634
        'y': 464
        navigate:
          7d3b629d-d511-ac3f-ba7b-2264321197d9:
            targetId: d3e056e0-382d-820b-a4f0-98703bcb5211
            port: NO_MORE
      get_workspace_details:
        x: 38
        'y': 104
      run_status_to_get_current_state_version_details:
        x: 1119
        'y': 282
      get_run_details_to_get_current_state_version_details:
        x: 765
        'y': 106
      update_workspace_variables:
        x: 314
        'y': 114
      get_run_status_value_to_get_current_state_version_details:
        x: 912
        'y': 107
      get_auto_apply_value:
        x: 181
        'y': 108
      apply_run:
        x: 765
        'y': 283
      is_auto_apply_true:
        x: 671
        'y': 93
      get_current_state_version:
        x: 1239
        'y': 302
        navigate:
          4d557828-6b3c-b1e9-9f47-d6aefab8e4e7:
            targetId: 2927d249-49fd-d519-a86e-5ec28268ee24
            port: SUCCESS
    results:
      SUCCESS:
        2927d249-49fd-d519-a86e-5ec28268ee24:
          x: 1389
          'y': 312
      FAILURE:
        d3e056e0-382d-820b-a4f0-98703bcb5211:
          x: 798
          'y': 623

