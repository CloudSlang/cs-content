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
#! @description: This workflow is used to stop the instance.
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
#! @result FAILURE: There was an error while trying to stop the instance.
#! @result SUCCESS: The instance stopped successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute

flow:
  name: gcp_stop_instance
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
          - SUCCESS: check_if_instance_is_in_stopped_state
          - FAILURE: on_failure
    - check_if_instance_is_in_stopped_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status}'
            - second_string: TERMINATED
            - ignore_case: 'true'
        navigate:
          - SUCCESS: set_failure_message_for_instance
          - FAILURE: stop_instance
    - set_failure_message_for_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - instance_name: '${instance_name}'
        publish:
          - output: "${\"Cannot stop the instance \\\"\"+instance_name+\"\\\" because it's not running or being repaired.\"}"
        navigate:
          - SUCCESS: get_instance_details
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
          - external_ips
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: is_instance_stopped
          - FAILURE: on_failure
    - sleep:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '${polling_interval}'
        navigate:
          - SUCCESS: get_instance_details
          - FAILURE: on_failure
    - is_instance_stopped:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status}'
            - second_string: TERMINATED
            - ignore_case: 'true'
        publish: []
        navigate:
          - SUCCESS: is_external_ip_null
          - FAILURE: sleep
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
          - SUCCESS: get_instance_details
          - FAILURE: on_failure
    - set_external_ip:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - external_ips: None
        publish:
          - external_ips
          - status: Stopped
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - is_external_ip_null:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${external_ips}'
            - second_string: 'null'
            - ignore_case: 'true'
        publish:
          - status: Stopped
        navigate:
          - SUCCESS: set_external_ip
          - FAILURE: SUCCESS
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
      is_external_ip_null:
        x: 1048
        'y': 139
        navigate:
          598a0bc5-f894-2f2b-cc42-6b282e70aa44:
            targetId: e104c40a-d81e-dbcf-ed47-b859689c4260
            port: FAILURE
      get_instance_details:
        x: 691
        'y': 128
      get_access_token:
        x: 48
        'y': 125
      stop_instance:
        x: 535
        'y': 129
      set_failure_message_for_instance:
        x: 376
        'y': 339
      sleep:
        x: 875
        'y': 341
      is_instance_stopped:
        x: 871
        'y': 137
      check_if_instance_is_in_stopped_state:
        x: 373
        'y': 128
      set_external_ip:
        x: 1049
        'y': 340
        navigate:
          02f68921-535e-7e77-e2cc-30502930b386:
            targetId: e104c40a-d81e-dbcf-ed47-b859689c4260
            port: SUCCESS
      get_instance:
        x: 197
        'y': 129
    results:
      SUCCESS:
        e104c40a-d81e-dbcf-ed47-b859689c4260:
          x: 1218
          'y': 132
