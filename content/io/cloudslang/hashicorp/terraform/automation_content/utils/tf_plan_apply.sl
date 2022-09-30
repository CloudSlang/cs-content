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
#! @description: This flow applies the given terraform plan.
#!
#! @input tf_user_auth_token: The user authorization token for terraform.
#! @input tf_instance_organization_name: The terraform instance organization name.
#! @input tf_template_workspace_name: The terraform template workspace name.
#! @input tf_instance_workspace_id: the terraform instance workspace id.
#! @input auto_apply: Whether to automatically apply changes when a Terraform plan is successful, with some
#!                    exceptions.
#!                    Default: 'false'
#!                    Optional
#! @input proxy_host: Proxy server used to access the Terraform service.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Terraform service.
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
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#!
#! @output hosted_state_download_url: A url from which you can download the raw state.
#! @output state_version_id: The ID of the desired state version.
#!
#! @result FAILURE: There was an error while executing the request.
#! @result SUCCESS: The request was successfully executed.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.automation_content.utils
flow:
  name: tf_plan_apply
  inputs:
    - tf_user_auth_token:
        sensitive: true
    - tf_instance_organization_name
    - tf_template_workspace_name
    - tf_instance_workspace_id
    - auto_apply:
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
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - create_run_v3:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.hashicorp.terraform.runs.create_run_v3:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - workspace_id: '${tf_instance_workspace_id}'
            - tf_run_message: '${tf_run_message}'
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
        publish:
          - tf_run_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_auto_apply_true
    - is_auto_apply_true:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${auto_apply}'
        navigate:
          - 'TRUE': get_run_details_for_get_state_version_details
          - 'FALSE': get_run_details_v2
    - get_run_details_v2:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.runs.get_run_details_v2:
            - auth_token:
                value: '${tf_user_auth_token}'
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
          - FAILURE: counter_for_run_status
    - counter_for_run_status:
        worker_group: '${worker_group}'
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
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: get_run_details_v2
          - FAILURE: on_failure
    - get_current_state_version:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.stateversions.get_current_state_version:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - workspace_id: '${tf_instance_workspace_id}'
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
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.runs.get_run_details_v2:
            - auth_token:
                value: '${tf_user_auth_token}'
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
          - SUCCESS: get_current_state_version
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
    - apply_run_v3:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.hashicorp.terraform.runs.apply_run_v3:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - tf_run_id:
                value: '${tf_run_id}'
                sensitive: true
            - tf_run_message: '${tf_run_message}'
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
  outputs:
    - hosted_state_download_url
    - state_version_id
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_run_status_value:
        x: 240
        'y': 320
      apply_run_v3:
        x: 400
        'y': 320
      wait_for_get_state_version_details:
        x: 560
        'y': 320
      run_status:
        x: 400
        'y': 520
      wait_for_plan_status:
        x: 80
        'y': 520
      counter_for_get_state_version_details:
        x: 560
        'y': 520
        navigate:
          44a91456-5dde-6693-18b3-6a90f785ac5c:
            targetId: fabb57bb-b303-6dcd-b4cf-e667fa2870cd
            port: NO_MORE
      get_run_status_value_state_version:
        x: 560
        'y': 120
      get_run_details_for_get_state_version_details:
        x: 400
        'y': 120
      create_run_v3:
        x: 80
        'y': 120
      run_status_for_get_state_version_details:
        x: 720
        'y': 320
      get_run_details_v2:
        x: 80
        'y': 320
      is_auto_apply_true:
        x: 240
        'y': 120
      get_current_state_version:
        x: 880
        'y': 320
        navigate:
          7a5d402b-8582-098f-e314-545a43a70854:
            targetId: 314e7f88-a400-c545-369a-d99c5cb2767c
            port: SUCCESS
      counter_for_run_status:
        x: 240
        'y': 520
        navigate:
          efd7be8d-6f09-a3ee-7405-de433178e78d:
            targetId: fabb57bb-b303-6dcd-b4cf-e667fa2870cd
            port: NO_MORE
    results:
      FAILURE:
        fabb57bb-b303-6dcd-b4cf-e667fa2870cd:
          x: 400
          'y': 680
      SUCCESS:
        314e7f88-a400-c545-369a-d99c5cb2767c:
          x: 1040
          'y': 320
