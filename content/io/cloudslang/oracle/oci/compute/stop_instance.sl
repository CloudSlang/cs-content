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
#! @description: This workflow stops an instance. It checks the current state of the instance. If instance is in a
#!               stopped state, workflow succeeds without any operation execution and returns the instance state.
#!
#! @input tenancy_ocid: Oracle creates a tenancy for your company, which is a secure and isolated partition where you
#!                      can create, organize, and administer your cloud resources. This is the ID of the tenancy.
#! @input user_ocid: The ID of an individual employee or system that needs to manage or use your company’s Oracle Cloud
#!                   Infrastructure resources.
#! @input finger_print: The finger print of the public key generated for the OCI account.
#! @input private_key_file: The path to the private key file on the machine where the worker is.
#! @input api_version: Version of the API of OCI.
#!                     Default: '20160918'
#!                     Optional
#! @input region: The region's name.
#!                Example: ap-sydney-1, ap-melbourne-1, sa-saopaulo-1, etc.
#! @input instance_id: The OCID of the instance.
#! @input proxy_host: Proxy server used to access the OCI.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the OCI.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.
#!                         Default: '10000'
#!                         Optional
#! @input socket_timeout: The timeout for waiting for data (a maximum period of inactivity between two consecutive data
#!                        packets), in seconds. A socketTimeout value of '0' represents an infinite timeout.
#!                        Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls. If
#!                    keepAlive is false, an existing open connection is used and the connection will be closed after
#!                    execution.
#!                    Default: 'true'
#!                    Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.
#!                                   Default: '2'
#!                                   Optional
#! @input connections_max_total: The maximum limit of connections in total.
#!                               Default: '20'
#!                               Optional
#! @input retry_count: Number of checks if the instance was created successfully.
#!                     Default: '60'
#!                     Optional
#!
#! @output return_result: If successful, returns the complete API response. In case of an error this output will contain
#!                        the error message.
#! @output instance_state: The current state of the instance.
#! @output exception: An error message in case there was an error while executing the request.
#! @output status_code: The HTTP status code for OCI API request.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.oracle.oci.compute
flow:
  name: stop_instance
  inputs:
    - tenancy_ocid
    - user_ocid
    - finger_print:
        sensitive: true
    - private_key_file
    - api_version:
        required: false
    - region
    - instance_id:
        required: true
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
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
    - retry_count:
        default: '30'
        required: false
  workflow:
    - get_instance_details:
        do:
          io.cloudslang.oracle.oci.compute.instances.get_instance_details:
            - tenancy_ocid: '${tenancy_ocid}'
            - user_ocid: '${user_ocid}'
            - finger_print:
                value: '${finger_print}'
                sensitive: true
            - private_key_file:
                value: '${private_key_file}'
            - api_version: '${api_version}'
            - region: '${region}'
            - instance_id: '${instance_id}'
            - proxy_host: '${proxy_host}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - proxy_port: '${proxy_port}'
        publish:
          - instance_state
        navigate:
          - SUCCESS: is_instance_in_stopped_state
          - FAILURE: on_failure
    - get_instance_details_for_instance_action:
        do:
          io.cloudslang.oracle.oci.compute.instances.get_instance_details:
            - tenancy_ocid: '${tenancy_ocid}'
            - user_ocid: '${user_ocid}'
            - finger_print:
                value: '${finger_print}'
                sensitive: true
            - private_key_file:
                value: '${private_key_file}'
            - api_version: '${api_version}'
            - region: '${region}'
            - instance_id: '${instance_id}'
            - proxy_host: '${proxy_host}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - proxy_port: '${proxy_port}'
        publish:
          - instance_state
        navigate:
          - SUCCESS: is_instance_stopped
          - FAILURE: on_failure
    - is_instance_stopped:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${instance_state}'
            - second_string: STOPPED
            - ignore_case: 'true'
        navigate:
          - SUCCESS: success_message
          - FAILURE: wait_for_instance_to_stop
    - counter:
        do:
          io.cloudslang.oracle.oci.utils.counter:
            - from: '1'
            - to: '${retry_count}'
            - increment_by: '1'
        navigate:
          - HAS_MORE: get_instance_details_for_instance_action
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - wait_for_instance_to_stop:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: counter
          - FAILURE: on_failure
    - is_instance_in_stopped_state:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${instance_state}'
            - second_string: STOPPED
            - ignore_case: 'true'
        navigate:
          - SUCCESS: instance_action_success_message
          - FAILURE: instance_action
    - instance_action_success_message:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${instance_id}'
            - text: ' is in stopped state.'
            - input_0: '${instance_state}'
        publish:
          - return_result: '${new_string}'
          - instance_state: '${input_0}'
        navigate:
          - SUCCESS: SUCCESS
    - instance_action:
        do:
          io.cloudslang.oracle.oci.compute.instances.instance_action:
            - tenancy_ocid: '${tenancy_ocid}'
            - user_ocid: '${user_ocid}'
            - finger_print:
                value: '${finger_print}'
                sensitive: true
            - private_key_file: '${private_key_file}'
            - api_version: '${api_version}'
            - region: '${region}'
            - instance_id: '${instance_id}'
            - action_name: STOP
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
        publish:
          - return_result
        navigate:
          - SUCCESS: get_instance_details_for_instance_action
          - FAILURE: on_failure
    - success_message:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: 'Successfully stopped the instance : '
            - text: '${instance_id}'
        publish:
          - return_result: '${new_string}'
          - instance_state: STOPPED
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - instance_state: '${instance_state}'
    - return_result: '${return_result}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      instance_action:
        x: 386
        'y': 178
      get_instance_details:
        x: 33
        'y': 71
      success_message:
        x: 875
        'y': 175
        navigate:
          c4bd9bbf-b73b-67a2-d832-006eb31301ef:
            targetId: 6c493ff8-f7ad-3c4a-74ab-e29cccc2f866
            port: SUCCESS
      instance_action_success_message:
        x: 422
        'y': 41
        navigate:
          24ebb488-868f-0927-5e63-a9d86e1b452f:
            targetId: 6c493ff8-f7ad-3c4a-74ab-e29cccc2f866
            port: SUCCESS
      get_instance_details_for_instance_action:
        x: 530
        'y': 175
      is_instance_stopped:
        x: 746
        'y': 155
      is_instance_in_stopped_state:
        x: 251
        'y': 59
      counter:
        x: 541
        'y': 354
        navigate:
          c2d034b4-bd94-90c8-6d2b-4c3beaf1aa4b:
            targetId: 32fcec6d-d2fb-5634-6ea4-61f4eefa2667
            port: NO_MORE
      wait_for_instance_to_stop:
        x: 718
        'y': 350
    results:
      FAILURE:
        32fcec6d-d2fb-5634-6ea4-61f4eefa2667:
          x: 384
          'y': 358
      SUCCESS:
        6c493ff8-f7ad-3c4a-74ab-e29cccc2f866:
          x: 870
          'y': 41
