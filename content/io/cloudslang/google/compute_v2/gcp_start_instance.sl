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
#! @description: This workflow is used to start the instance.
#!
#! @input client_id: The client ID for your application.
#! @input client_secret: The client secret for your application.
#! @input refresh_token: Refresh token.
#! @input project_id: Google Cloud project id.
#!                    Example: 'example-project-a'
#! @input zone: The name of the zone where the disk is located.
#!              Examples: 'us-central1-a, us-central1-b, us-central1-c'
#! @input instance_name: The name of the instance.
#! @input proxy_host: The proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: The proxy server port.
#!                    Optional
#! @input proxy_username: The proxy server username.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#!
#! @output external_ips: The external IP's of the instance.
#! @output status: The current state of the instance.
#! @output return_result: contains the exception in case of failure, success message otherwise.
#! @output exception: exception if there was an error when executing, empty otherwise.
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#!
#! @result FAILURE: There was an error while trying to start the instance.
#! @result SUCCESS: The instance started successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute_v2
flow:
  name: gcp_start_instance
  inputs:
    - client_id
    - client_secret:
        sensitive: true
    - refresh_token:
        sensitive: true
    - project_id:
        sensitive: true
    - zone
    - instance_name
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
    - get_access_token_using_web_api:
        do:
          io.cloudslang.google.authentication.get_access_token_using_web_api:
            - client_id: '${client_id}'
            - client_secret: '${client_secret}'
            - refresh_token:
                value: '${refresh_token}'
                sensitive: true
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
          - access_token
        navigate:
          - SUCCESS: get_instance
          - FAILURE: on_failure
    - check_if_instance_is_in_running_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status}'
            - second_string: RUNNING
            - ignore_case: 'true'
        navigate:
          - SUCCESS: set_failure_message_for_instance
          - FAILURE: start_instance
    - set_failure_message_for_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - instance_name: '${instance_name}'
        publish:
          - output: "${\"Cannot start the instance \\\"\"+instance_name+\"\\\"  because it's not stopped.\"}"
        navigate:
          - SUCCESS: get_instance_details
          - FAILURE: on_failure
    - sleep:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '${polling_interval}'
        navigate:
          - SUCCESS: get_instance_details
          - FAILURE: on_failure
    - compare_power_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status}'
            - second_string: RUNNING
            - ignore_case: 'true'
        publish:
          - status: Running
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: sleep
    - start_instance:
        do:
          io.cloudslang.google.compute_v2.instances.start_instance:
            - project_id:
                value: '${project_id}'
                sensitive: true
            - access_token:
                value: '${access_token}'
                sensitive: true
            - zone: '${zone}'
            - instance_name: '${instance_name}'
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
        navigate:
          - SUCCESS: get_instance_details
          - FAILURE: on_failure
    - get_instance:
        do:
          io.cloudslang.google.compute_v2.instances.get_instance:
            - access_token:
                value: '${access_token}'
                sensitive: true
            - project_id:
                value: '${project_id}'
                sensitive: true
            - zone: '${zone}'
            - resource_id: '${instance_name}'
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
          - status
          - instance_json
        navigate:
          - SUCCESS: check_if_instance_is_in_running_state
          - FAILURE: on_failure
    - get_instance_details:
        do:
          io.cloudslang.google.compute_v2.instances.get_instance:
            - access_token:
                value: '${access_token}'
                sensitive: true
            - project_id:
                value: '${project_id}'
                sensitive: true
            - zone: '${zone}'
            - resource_id: '${instance_name}'
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
          - external_ips
          - status
        navigate:
          - SUCCESS: compare_power_state
          - FAILURE: on_failure
  outputs:
    - external_ips
    - status
    - return_result
    - exception
    - return_code
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_access_token_using_web_api:
        x: 40
        'y': 160
      check_if_instance_is_in_running_state:
        x: 360
        'y': 160
      set_failure_message_for_instance:
        x: 360
        'y': 360
      sleep:
        x: 880
        'y': 360
      compare_power_state:
        x: 880
        'y': 160
        navigate:
          649043f8-1950-152b-2ddf-858591e896eb:
            targetId: e104c40a-d81e-dbcf-ed47-b859689c4260
            port: SUCCESS
      start_instance:
        x: 520
        'y': 160
      get_instance:
        x: 200
        'y': 160
      get_instance_details:
        x: 720
        'y': 160
    results:
      SUCCESS:
        e104c40a-d81e-dbcf-ed47-b859689c4260:
          x: 1040
          'y': 160

