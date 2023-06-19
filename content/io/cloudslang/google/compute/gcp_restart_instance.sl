#   (c) Copyright 2023 Open Text
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
#! @description: This workflow is used to restart the instance.
#!
#! @input json_token: Content of the Google Cloud service account JSON.
#! @input project_id: Google Cloud project id.
#!                    Example: 'example-project-a'
#! @input zone: The name of the zone where the disk is located.
#!              Examples: 'us-central1-a, us-central1-b, us-central1-c'
#! @input scopes: Scopes that you might need to request to access Google Compute APIs, depending on the level of access you need.
#!                One or more scopes may be specified delimited by the <scopesDelimiter>.
#!                For a full list of scopes see https://developers.google.com/identity/protocols/googlescopes#computev1
#!                Note: It is recommended to use the minimum necessary scope in order to perform the requests.
#!                Example: 'https://www.googleapis.com/auth/compute.readonly'
#! @input instance_name: The name of the instance.
#! @input proxy_host: The proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: The proxy server port.
#!                    Optional
#! @input proxy_username: The proxy server username.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input timeout: Time in seconds to wait for a connection to be established.
#!                 default: '1200'
#!                 Optional
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Default: '30'
#!                          Optional
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
#! @result FAILURE: There was an error while trying to restart the instance.
#! @result SUCCESS: The instance restarted successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute

flow:
  name: gcp_restart_instance
  inputs:
    - json_token:
        sensitive: true
    - project_id:
        sensitive: true
    - zone
    - scopes
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
    - timeout:
        default: '1200'
        required: false
    - polling_interval:
        default: '30'
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - get_access_token:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.authentication.get_access_token:
            - json_token:
                value: '${json_token}'
                sensitive: true
            - scopes: '${scopes}'
            - timeout: '${timeout}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - access_token: '${return_result}'
        navigate:
          - SUCCESS: get_instance
          - FAILURE: on_failure
    - get_instance_details:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.compute.compute_engine.instances.get_instance:
            - access_token:
                value: '${access_token}'
                sensitive: true
            - project_id: '${project_id}'
            - zone: '${zone}'
            - instance_name: '${instance_name}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - status
          - return_code
          - return_result
          - exception
          - external_ips
        navigate:
          - SUCCESS: is_instance_running
          - FAILURE: on_failure
    - sleep:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '${polling_interval}'
        navigate:
          - SUCCESS: get_instance_details
          - FAILURE: on_failure
    - is_instance_running:
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
    - get_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.compute.compute_engine.instances.get_instance:
            - access_token:
                value: '${access_token}'
                sensitive: true
            - project_id: '${project_id}'
            - zone: '${zone}'
            - instance_name: '${instance_name}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - status
          - return_code
          - return_result
          - exception
        navigate:
          - SUCCESS: check_if_instance_is_in_running_state
          - FAILURE: on_failure
    - check_if_instance_is_in_running_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status}'
            - second_string: RUNNING
            - ignore_case: 'true'
        navigate:
          - SUCCESS: stop_instance
          - FAILURE: start_instance
    - start_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.compute.compute_engine.instances.start_instance:
            - access_token:
                value: '${access_token}'
                sensitive: true
            - project_id: '${project_id}'
            - zone: '${zone}'
            - instance_name: '${instance_name}'
            - timeout: '${timeout}'
            - polling_interval: '${polling_interval}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - return_code
          - return_result
          - exception
          - status
        navigate:
          - SUCCESS: get_instance_details
          - FAILURE: on_failure
    - stop_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.compute.compute_engine.instances.stop_instance:
            - access_token:
                value: '${access_token}'
                sensitive: true
            - project_id: '${project_id}'
            - zone: '${zone}'
            - instance_name: '${instance_name}'
            - timeout: '${timeout}'
            - polling_interval: '${polling_interval}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - status
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: get_instance_details_1
          - FAILURE: on_failure
    - get_instance_details_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.compute.compute_engine.instances.get_instance:
            - access_token:
                value: '${access_token}'
                sensitive: true
            - project_id: '${project_id}'
            - zone: '${zone}'
            - instance_name: '${instance_name}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - status
          - external_ips
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_if_instance_is_in_stopped_state
          - FAILURE: on_failure
    - check_if_instance_is_in_stopped_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status}'
            - second_string: TERMINATED
            - ignore_case: 'true'
        publish: []
        navigate:
          - SUCCESS: start_instance
          - FAILURE: sleep_1
    - sleep_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '${polling_interval}'
        navigate:
          - SUCCESS: get_instance_details_1
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
      get_instance_details:
        x: 732
        'y': 111
      get_access_token:
        x: 42
        'y': 108
      sleep_1:
        x: 572
        'y': 451
      is_instance_running:
        x: 923
        'y': 120
        navigate:
          649043f8-1950-152b-2ddf-858591e896eb:
            targetId: e104c40a-d81e-dbcf-ed47-b859689c4260
            port: SUCCESS
      check_if_instance_is_in_running_state:
        x: 395
        'y': 103
      stop_instance:
        x: 403
        'y': 281
      start_instance:
        x: 565
        'y': 106
      get_instance_details_1:
        x: 408
        'y': 438
      sleep:
        x: 928
        'y': 303
      check_if_instance_is_in_stopped_state:
        x: 574
        'y': 281
      get_instance:
        x: 222
        'y': 103
    results:
      SUCCESS:
        e104c40a-d81e-dbcf-ed47-b859689c4260:
          x: 1112
          'y': 123

