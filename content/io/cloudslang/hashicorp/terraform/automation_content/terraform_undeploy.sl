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
#! @description: This workflow undeploy's the module from the given organization.
#!
#! @input tf_instance_organization_auth_token: The user authorization token for terraform.
#! @input tf_instance_organization_name: The terraform instance organization name.
#! @input tf_instance_workspace_name: The terraform instance workspace name.
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
#! @result FAILURE: There was an error while executing the request.
#! @result SUCCESS: The request was successfully executed.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.automation_content
flow:
  name: terraform_undeploy
  inputs:
    - tf_instance_organization_auth_token:
        sensitive: true
    - tf_instance_organization_name
    - tf_instance_workspace_name
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
                value: '${tf_instance_organization_auth_token}'
                sensitive: true
            - organization_name: '${tf_instance_organization_name}'
            - workspace_name: '${tf_instance_workspace_name}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
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
    - is_auto_apply_true:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${auto_apply}'
        navigate:
          - 'TRUE': get_run_details_for_get_state_version_details
          - 'FALSE': get_run_details_v2
    - wait_for_apply_status:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: get_run_details_v2
          - FAILURE: on_failure
    - get_run_details_v2:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.runs.get_run_details_v2:
            - auth_token:
                value: '${tf_instance_organization_auth_token}'
                sensitive: true
            - tf_run_id: '${tf_run_id}'
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
        worker_group: '${worker_group}'
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
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${plan_status}'
            - second_string: planned
        navigate:
          - SUCCESS: apply_run_v3
          - FAILURE: counter
    - delete_workspace:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.workspaces.delete_workspace:
            - auth_token:
                value: '${tf_instance_organization_auth_token}'
                sensitive: true
            - organization_name: '${tf_instance_organization_name}'
            - workspace_name: '${tf_instance_workspace_name}'
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
          - SUCCESS: check_workspace_is_present
          - FAILURE: on_failure
    - check_workspace_is_present:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.workspaces.get_workspace_details:
            - auth_token:
                value: '${tf_instance_organization_auth_token}'
                sensitive: true
            - organization_name: '${tf_instance_organization_name}'
            - workspace_name: '${tf_instance_workspace_name}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
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
          - SUCCESS: on_failure
          - FAILURE: SUCCESS
    - get_auto_apply_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: 'data,attributes,auto-apply'
        publish:
          - auto_apply: '${return_result}'
        navigate:
          - SUCCESS: create_workspace_variables_v2
          - FAILURE: on_failure
    - counter:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.utils.counter:
            - from: '1'
            - to: '100'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: wait_for_apply_status
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - get_run_details_for_get_state_version_details:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.runs.get_run_details_v2:
            - auth_token:
                value: '${tf_instance_organization_auth_token}'
                sensitive: true
            - tf_run_id: '${tf_run_id}'
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
        worker_group: '${worker_group}'
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
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${plan_status}'
            - second_string: applied
        navigate:
          - SUCCESS: delete_workspace
          - FAILURE: counter_for_get_state_version_details
    - counter_for_get_state_version_details:
        worker_group: '${worker_group}'
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
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: get_run_details_for_get_state_version_details
          - FAILURE: on_failure
    - create_workspace_variables_v2:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.hashicorp.terraform.workspaces.variables.create_workspace_variables_v2:
            - auth_token:
                value: '${tf_instance_organization_auth_token}'
                sensitive: true
            - workspace_id:
                value: '${workspace_id}'
                sensitive: true
            - workspace_variables_json: '[{"propertyName":"CONFIRM_DESTROY","propertyValue":"1","HCL":false,"Category":"env"}]'
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
        navigate:
          - SUCCESS: create_run_v3
          - FAILURE: on_failure
    - create_run_v3:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.hashicorp.terraform.runs.create_run_v3:
            - auth_token:
                value: '${tf_instance_organization_auth_token}'
                sensitive: true
            - workspace_id: '${workspace_id}'
            - is_destroy: 'true'
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
          - tf_run_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_auto_apply_true
    - apply_run_v3:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.hashicorp.terraform.runs.apply_run_v3:
            - auth_token:
                value: '${tf_instance_organization_auth_token}'
                sensitive: true
            - tf_run_id: '${tf_run_id}'
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
        navigate:
          - SUCCESS: get_run_details_for_get_state_version_details
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_run_status_value:
        x: 680
        'y': 280
      delete_workspace:
        x: 1280
        'y': 280
      apply_run_v3:
        x: 840
        'y': 280
      wait_for_apply_status:
        x: 520
        'y': 480
      wait_for_get_state_version_details:
        x: 960
        'y': 280
      run_status:
        x: 840
        'y': 480
      check_workspace_is_present:
        x: 1440
        'y': 280
        navigate:
          37245234-d896-8513-2a44-c4ae6a309c0d:
            targetId: 8fdcd666-d9ef-4f4f-6ed2-36400100824c
            port: FAILURE
      counter_for_get_state_version_details:
        x: 960
        'y': 480
        navigate:
          090c0377-8eaa-436b-ab07-e6c19834ad4b:
            targetId: cb4ded66-a2a7-9760-786d-84926d356dd9
            port: NO_MORE
      get_run_status_value_state_version:
        x: 960
        'y': 120
      get_workspace_details:
        x: 40
        'y': 120
      create_workspace_variables_v2:
        x: 200
        'y': 320
      get_run_details_for_get_state_version_details:
        x: 680
        'y': 120
      create_run_v3:
        x: 360
        'y': 120
      run_status_for_get_state_version_details:
        x: 1120
        'y': 280
      get_run_details_v2:
        x: 520
        'y': 280
      get_auto_apply_value:
        x: 200
        'y': 120
      is_auto_apply_true:
        x: 520
        'y': 120
      counter:
        x: 680
        'y': 480
        navigate:
          b5902390-2619-3b22-c280-1d6c7ec9bdd4:
            targetId: cb4ded66-a2a7-9760-786d-84926d356dd9
            port: NO_MORE
    results:
      FAILURE:
        cb4ded66-a2a7-9760-786d-84926d356dd9:
          x: 840
          'y': 640
      SUCCESS:
        8fdcd666-d9ef-4f4f-6ed2-36400100824c:
          x: 1640
          'y': 280

