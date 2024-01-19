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
#! @description: This workflow starts an instance. It checks the current state of the instance. If the instance is in a
#!               running state, workflow succeeds without any operation execution and returns the instance state.
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
  name: start_instance
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
          - SUCCESS: is_instance_in_running_state
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
          - SUCCESS: is_instance_started
          - FAILURE: on_failure
    - is_instance_started:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${instance_state}'
            - second_string: RUNNING
            - ignore_case: 'true'
        navigate:
          - SUCCESS: success_message
          - FAILURE: wait_for_instance_to_start
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
    - wait_for_instance_to_start:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: counter
          - FAILURE: on_failure
    - is_instance_in_running_state:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${instance_state}'
            - second_string: RUNNING
            - ignore_case: 'true'
        navigate:
          - SUCCESS: instance_action_success_message
          - FAILURE: instance_action
    - instance_action_success_message:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${instance_id}'
            - text: ' is in running state.'
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
            - action_name: START
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
            - origin_string: 'Successfully started the instance : '
            - text: '${instance_id}'
        publish:
          - return_result: '${new_string}'
          - instance_state: RUNNING
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
        x: 387
        'y': 180
      get_instance_details:
        x: 38
        'y': 76
      wait_for_instance_to_start:
        x: 755
        'y': 347
      success_message:
        x: 905
        'y': 176
        navigate:
          e1cdd487-f34c-7467-dac4-bccf818d5d3d:
            targetId: 15d35135-3854-bafa-6b17-02018872bf96
            port: SUCCESS
      is_instance_in_running_state:
        x: 265
        'y': 64
      is_instance_started:
        x: 783
        'y': 159
      instance_action_success_message:
        x: 385
        'y': 36
        navigate:
          ccec6fc7-1568-730f-36c2-7ebabd6e978c:
            targetId: 15d35135-3854-bafa-6b17-02018872bf96
            port: SUCCESS
      get_instance_details_for_instance_action:
        x: 556
        'y': 176
      counter:
        x: 558
        'y': 355
        navigate:
          52df6aaf-550e-0080-0c7d-bdebe6a5eb98:
            targetId: ae4aee99-9492-8f25-974a-bbba239f8d62
            port: NO_MORE
    results:
      FAILURE:
        ae4aee99-9492-8f25-974a-bbba239f8d62:
          x: 393
          'y': 355
      SUCCESS:
        15d35135-3854-bafa-6b17-02018872bf96:
          x: 898
          'y': 38
