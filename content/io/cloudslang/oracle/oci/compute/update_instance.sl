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
#! @description: Updates shape of an specified instance.
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
#! @input shape: The shape of an instance. The shape determines the number of CPUs, amount of memory, and other
#!               resources allocated to the instance.
#!               Example: VM.Standard2.1,VM.Standard2.2, etc.
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
#! @output exception: An error message in case there was an error while executing the request.
#! @output instance_shape: Updated shape of the instance.
#! @output instance_state: The current state of the instance.
#! @output status_code: The HTTP status code for OCI API request.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.oracle.oci.compute
flow:
  name: update_instance
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
    - shape
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
    - update_instance:
        do:
          io.cloudslang.oracle.oci.compute.instances.update_instance:
            - tenancy_ocid: '${tenancy_ocid}'
            - user_ocid: '${user_ocid}'
            - finger_print:
                value: '${finger_print}'
                sensitive: true
            - private_key_file: '${private_key_file}'
            - api_version: '${api_version}'
            - region: '${region}'
            - instance_id: '${instance_id}'
            - shape: '${shape}'
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
          - SUCCESS: get_instance_details
          - FAILURE: on_failure
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
          - return_result
        navigate:
          - SUCCESS: get_instance_shape
          - FAILURE: on_failure
    - is_instance_shape_updated:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${instance_shape}'
            - second_string: '${shape}'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: wait_for_instance_to_update_shape
    - counter:
        do:
          io.cloudslang.oracle.oci.utils.counter:
            - from: '1'
            - to: '${retry_count}'
            - increment_by: '1'
        navigate:
          - HAS_MORE: get_instance_details
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - wait_for_instance_to_update_shape:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: counter
          - FAILURE: on_failure
    - get_instance_shape:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result}'
            - json_path: $.shape
        publish:
          - instance_shape: '${return_result}'
        navigate:
          - SUCCESS: remove
          - FAILURE: on_failure
    - remove:
        do:
          io.cloudslang.base.strings.remove:
            - origin_string: '${instance_shape}'
            - text: '"'
        publish:
          - instance_shape: '${new_string}'
        navigate:
          - SUCCESS: is_instance_shape_updated
  outputs:
    - return_result: '${return_result}'
    - instance_shape: '${instance_shape}'
    - instance_state: '${instance_state}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      update_instance:
        x: 41
        'y': 102
      get_instance_details:
        x: 215
        'y': 105
      is_instance_shape_updated:
        x: 750
        'y': 90
        navigate:
          f207f009-6840-98a1-bf71-5ab6e67eb408:
            targetId: a7721498-2f9b-01d6-d32f-73537aaf01dd
            port: SUCCESS
      counter:
        x: 212
        'y': 312
        navigate:
          d944913f-5c6c-4fec-594e-45d48384a868:
            targetId: 18079688-1b34-92f5-f76b-6930afc511d7
            port: NO_MORE
      wait_for_instance_to_update_shape:
        x: 722
        'y': 320
      get_instance_shape:
        x: 379
        'y': 104
      remove:
        x: 531
        'y': 108
    results:
      FAILURE:
        18079688-1b34-92f5-f76b-6930afc511d7:
          x: 40
          'y': 316
      SUCCESS:
        a7721498-2f9b-01d6-d32f-73537aaf01dd:
          x: 891
          'y': 110
