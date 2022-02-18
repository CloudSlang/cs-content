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
#! @description: This flow terminates an instance. If the resources attached to this instance were created with the
#!               attribute auto_delete = false, these resources will be deleted only if the attribute
#!               delete_all_disk= true. If this attribute is set to false, then the resources will be detached
#!               but not deleted.
#!
#! @input json_token: Content of the Google Cloud service account JSON.
#! @input project_id: Google Cloud project id.
#!                    Example: "example-project-a"
#! @input zone: The name of the zone where the Disk resource is located.
#!              Examples: "us-central1-a", "us-central1-b", "us-central1-c"
#! @input scopes: Scopes that you might need to request to access Google Compute APIs, depending on the level of access you need.
#!                One or more scopes may be specified delimited by the <scopesDelimiter>.
#!                For a full list of scopes see https://developers.google.com/identity/protocols/googlescopes#computev1
#!                Note: It is recommended to use the minimum necessary scope in order to perform the requests.
#!                Example: 'https://www.googleapis.com/auth/compute.readonly'
#! @input instance_name: Name of the Instance resource to create.
#! @input delete_all_disks: Whether to delete all disks attached to the instance, disregardint the Google provided 'autoDelete' property.
#!                          Valid values: true, false Default: false
#!                          Optional
#! @input auth_type: The authentication type.
#!                   Example : "basic".
#!                   Optional
#! @input proxy_host: The proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: The proxy server used to access the provider services.
#!                    Optional
#! @input proxy_username: The proxy server user name.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input timeout: Time in seconds to wait for a connection to be established.
#!                 default: '300'
#!                 Optional
#!
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output exception: exception if there was an error when executing, empty otherwise
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute
flow:
  name: gcp_undeploy_instance
  inputs:
    - json_token:
        sensitive: true
    - project_id:
        sensitive: true
    - zone
    - scopes: 'https://www.googleapis.com/auth/compute'
    - instance_name
    - delete_all_disks:
        default: 'false'
        required: false
    - auth_type:
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
    - worker_group:
        default: RAS_Operator_Path
        required: false
    - timeout:
        default: '300'
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
          - exception
          - return_code
        navigate:
          - SUCCESS: get_instance
          - FAILURE: set_failure_message_for_authentication
    - get_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.compute.compute_engine.instances.get_instance:
            - project_id: '${project_id}'
            - zone: '${zone}'
            - instance_name: '${instance_name}'
            - access_token:
                value: '${access_token}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - return_code
          - instance_details: '${return_result}'
          - exception
        navigate:
          - SUCCESS: delete_instance
          - FAILURE: set_failure_message_for_to_get_instance
    - delete_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.compute.compute_engine.instances.delete_instance:
            - access_token:
                value: '${access_token}'
                sensitive: true
            - project_id: '${project_id}'
            - zone: '${zone}'
            - instance_name: '${instance_name}'
            - async: 'false'
            - timeout: '${timeout}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: delete_all_disks
          - FAILURE: set_failure_message_for_instance
    - delete_all_disks:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${delete_all_disks}'
            - second_string: 'true'
        navigate:
          - SUCCESS: get_remaining_disk_names
          - FAILURE: set_success_message_for_instance
    - get_remaining_disk_names:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${instance_details}'
            - json_path: 'disks[?(@.autoDelete==false)].source'
        publish:
          - list_of_disks: '${return_result}'
        navigate:
          - SUCCESS: list_of_disks
          - FAILURE: on_failure
    - list_of_disks:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${list_of_disks}'
        publish:
          - disk_name: '${result_string}'
        navigate:
          - HAS_MORE: check_if_disk_name_list_empty
          - NO_MORE: set_success_message_for_instance_with_disk_name
          - FAILURE: on_failure
    - delete_disk:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.compute.compute_engine.disks.delete_disk:
            - access_token:
                value: '${access_token}'
                sensitive: true
            - project_id: '${project_id}'
            - zone: '${zone}'
            - disk_name: '${disk_name_out}'
            - async: 'false'
            - timeout: '${timeout}'
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
        navigate:
          - SUCCESS: list_of_disks
          - FAILURE: on_failure
    - get_by_disk_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${disk_name[1:-1]}'
            - delimiter: /
            - index: end
        publish:
          - disk_name_out: '${return_result}'
        navigate:
          - SUCCESS: delete_disk
          - FAILURE: on_failure
    - for_each_disk:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - disk_name: '${disk_name}'
        publish:
          - disk_name: '${disk_name.replace("[","").replace("]","")}'
        navigate:
          - SUCCESS: get_by_disk_name
          - FAILURE: on_failure
    - check_if_disk_name_list_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${disk_name}'
            - second_string: '[]'
        navigate:
          - SUCCESS: set_success_message_for_instance
          - FAILURE: for_each_disk
    - set_success_message_for_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - instance_name: '${instance_name}'
        publish:
          - return_result: "${\"Instance \\\"\"+instance_name+\"\\\" has been successfully undeployed.\"}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - set_failure_message_for_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - instance_name: '${instance_name}'
        publish:
          - return_result: "${\"Unable to delete instance \\\"\"+instance_name+\"\\\".\"}"
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
    - set_failure_message_for_to_get_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - instance_name: '${instance_name}'
        publish:
          - return_result: "${\"Error getting instance details for instance \\\"\"+instance_name+\"\\\" .\"}"
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
    - set_failure_message_for_authentication:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing: []
        publish:
          - return_result: Unable to authenticate.
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
    - set_success_message_for_instance_with_disk_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - instance_name: '${instance_name}'
            - list_of_disks: '${list_of_disks}'
        publish:
          - return_result: "${\"Instance \\\"\"+instance_name+\"\\\" has been successfully undeployed.along with all disks attached to it: \\\"\"+list_of_disks+\"\\\".\"}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_code
    - return_result
    - exception
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      set_failure_message_for_to_get_instance:
        x: 167
        'y': 244
        navigate:
          c3dcd161-0fc6-2c23-26fa-c80a738145b2:
            targetId: ca0c6dc5-a40c-f0f8-9916-3aa81a83497f
            port: SUCCESS
      delete_all_disks:
        x: 475
        'y': 88
      for_each_disk:
        x: 472
        'y': 652
      get_access_token:
        x: 13
        'y': 68
      delete_instance:
        x: 322
        'y': 77
      check_if_disk_name_list_empty:
        x: 786
        'y': 537
      get_by_disk_name:
        x: 325
        'y': 652
      list_of_disks:
        x: 484
        'y': 411
      delete_disk:
        x: 326
        'y': 407
      set_failure_message_for_instance:
        x: 322
        'y': 246
        navigate:
          a7da2825-37ea-f07f-bcfa-e09ada5d33f5:
            targetId: ca0c6dc5-a40c-f0f8-9916-3aa81a83497f
            port: SUCCESS
      set_success_message_for_instance_with_disk_name:
        x: 665
        'y': 362
        navigate:
          3652a93f-a253-ddde-da58-b2e578736a21:
            targetId: 39b3c3fe-524e-b2fb-d62e-f1abcd08f3ba
            port: SUCCESS
      set_failure_message_for_authentication:
        x: 16
        'y': 252
        navigate:
          6d7025a1-aa6e-8486-c1c6-3956d17aba70:
            targetId: ca0c6dc5-a40c-f0f8-9916-3aa81a83497f
            port: SUCCESS
      get_remaining_disk_names:
        x: 481
        'y': 246
      set_success_message_for_instance:
        x: 783
        'y': 88
        navigate:
          2bf89107-434e-4182-b54b-54f4fcbcfb1a:
            targetId: 39b3c3fe-524e-b2fb-d62e-f1abcd08f3ba
            port: SUCCESS
      get_instance:
        x: 170
        'y': 72
    results:
      SUCCESS:
        39b3c3fe-524e-b2fb-d62e-f1abcd08f3ba:
          x: 662
          'y': 223
      FAILURE:
        ca0c6dc5-a40c-f0f8-9916-3aa81a83497f:
          x: 163
          'y': 418
