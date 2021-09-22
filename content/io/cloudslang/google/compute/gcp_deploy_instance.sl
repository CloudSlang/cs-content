#   (c) Copyright 2021 Micro Focus, L.P.
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
#! @description: This flow deploys an instance in Google cloud. This flow gives the flexibility to attach multiple disks
#!               that are of different types to the instance.
#!
#! @input json_token: Content of the Google Cloud service account JSON.
#! @input project_id: Google Cloud project id.
#!                    Example: "example-project-a"
#! @input zone: The name of the zone where the Disk resource is located.
#!              Examples: "us-central1-a", "us-central1-b", "us-central1-c"
#! @input machine_type: The machine type resource to use for this instance.
#!                      Example : "n1-standard-1".
#! @input scopes: Scopes that you might need to request to access Google Compute APIs, depending on the level of access you need.
#!                One or more scopes may be specified delimited by the <scopesDelimiter>.
#!                For a full list of scopes see https://developers.google.com/identity/protocols/googlescopes#computev1
#!                Note: It is recommended to use the minimum necessary scope in order to perform the requests.
#!                Example: 'https://www.googleapis.com/auth/compute.readonly'
#! @input instance_name: Name of the Instance resource to create.
#! @input volume_disk_source_image: The source image to create this disk.
#!                                  Example : "https://www.googleapis.com/compute/v1/projects/windows-cloud/global/images/image"
#! @input volume_disk_size: Specifies the size in GB of the disk on which the system will be installed.
#! @input instance_description: The description of the new instance.
#!                              Optional
#! @input volume_disk_type: Specifies the disk type to use to create the instance.
#!                          Valid values: pd-ssd,pd-balanced,pd-standard,pd-extreme
#!                          Optional
#! @input network: URL of the network resource for this instance. When creating an instance,if neither the network nor
#!                 the subnetwork is specified, the default network global/networks/default
#!                 is used; if the network is not specified but the subnetwork is specified, the network is inferred.
#!                 This field is optional when creating a firewall rule. If not specified when creating a firewall rule,
#!                 the default network global/networks/default is used.
#!                 Example : "https://www.googleapis.com/compute/v1/projects/project/global/networks/network"
#!                 Optional
#! @input sub_network: The URL of the Subnetwork resource for this instance. If the network resource is in legacy mode,
#!                     do not provide this property. If the network is in auto subnet mode,If the network is in custom subnet mode,
#!                     then this field should be specified.
#!                     Example : "https://www.googleapis.com/compute/v1/projects/project/regions/region/subnetworks/subnetwork"
#!                     Optional
#! @input disk_name_list: List of names of the disks provided by the client when the Disks are created.
#!                        Example : "test1"
#!                        Optional
#! @input disk_type_list: A list of URLs of disk type resources describing which disk type to use to create each disk.
#!                        Provide this when creating the disks.
#!                        Optional
#! @input disk_size_list: List of sizes of the persistent disks, specified in GB.
#!                        default: '10'
#!                        Optional
#! @input os_type: Type of OS.
#!                 Optional
#! @input username: Instance username.
#!                  Optional
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
#!                 default: '1200'
#!                 Optional
#!
#! @output self_link: The URI of this resource.
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output zone_operation_name: The zone operation name of the inserted instance.
#! @output external_ips: A comma-separated list of external IPs, accessible from outside of the Google Cloud Network, allocated to the instance.
#! @output internal_ips: A comma-separated list of internal IPs, accessible only from inside of the Google Cloud Network, allocated to the instance.
#! @output instance_id: The ID of the inserted instance.
#! @output instance_name_out: The name of the inserted instance.
#! @output status: The status of the instance.
#! @output exception: exception if there was an error when executing, empty otherwise
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output disks: A list of all the disks device name that are attached to the instance.
#! @output vm_name: The name of the inserted instance.
#! @output image_type: The type of the OS image used on the created instance.
#! @output zone_out: The zone in which the instance was created.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute
flow:
  name: gcp_deploy_instance
  inputs:
    - json_token:
        sensitive: true
    - project_id:
        sensitive: true
    - zone
    - machine_type
    - scopes: 'https://www.googleapis.com/auth/compute'
    - instance_name
    - volume_disk_source_image
    - volume_disk_size:
        required: true
    - instance_description:
        required: false
    - volume_disk_type:
        required: false
    - network:
        required: false
    - sub_network:
        required: false
    - disk_name_list:
        required: false
    - disk_type_list:
        required: false
    - disk_size_list:
        default: '10'
        required: false
    - os_type:
        required: false
    - username:
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
        default: '1200'
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
          - SUCCESS: get_machine_type
          - FAILURE: on_failure
    - get_machine_type:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          manjooshtest.get_machine_type:
            - json_token:
                value: '${json_token}'
                sensitive: true
            - project_id: '${project_id}'
            - zone: '${zone}'
            - machine_type: '${machine_type}'
            - scopes: '${scopes}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - worker_group: '${worker_group}'
            - connect_timeout: '${timeout}'
            - trust_all_roots: null
            - x_509_hostname_verifier: null
        publish:
          - self_link
        navigate:
          - FAILURE: on_failure
          - SUCCESS: random_number_generator
    - insert_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.compute.compute_engine.instances.insert_instance:
            - access_token:
                value: '${access_token}'
                sensitive: true
            - project_id: '${project_id}'
            - zone: '${zone}'
            - instance_name: '${instance_name}'
            - instance_description: '${instance_description}'
            - machine_type: '${self_link}'
            - list_delimiter: ','
            - volume_disk_source_image: '${volume_disk_source_image}'
            - volume_disk_type: '${volume_disk_type}'
            - volume_disk_size: '${volume_disk_size}'
            - network: '${network}'
            - subnetwork: '${sub_network}'
            - access_config_name: External NAT
            - async: 'false'
            - timeout: '${timeout}'
            - polling_interval: '5'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - return_result
          - zone_operation_name
          - external_ips
          - internal_ips
          - return_code
          - instance_name_out
          - instance_id
          - status
          - zone
          - vm_name: '${instance_name_out}'
          - zone_out: '${zone}'
        navigate:
          - SUCCESS: set_success_message_for_instance_with_disk_name
          - FAILURE: undeploy_vm
    - random_number_generator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.math.random_number_generator:
            - min: '10000'
            - max: '99999'
        publish:
          - random_number: '${random_number}'
        navigate:
          - SUCCESS: append_vm_prefix
          - FAILURE: on_failure
    - append_vm_prefix:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${instance_name}'
            - text: '${random_number}'
        publish:
          - instance_name: '${new_string}'
        navigate:
          - SUCCESS: is_volume_disk_type_is_empty
    - get_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.compute.compute_engine.instances.get_instance:
            - project_id: '${project_id}'
            - zone: '${zone}'
            - instance_name: '${instance_name_out}'
            - access_token:
                value: '${access_token}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - pretty_print: '${pretty_print}'
        publish:
          - return_code
          - instance_name_out
          - instance_id
          - internal_ips
          - external_ips
          - tags
          - disks
          - status
          - instance_image_details: '${return_result}'
        navigate:
          - SUCCESS: get_image_type_list
          - FAILURE: on_failure
    - os_platform_is_windows:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${os_type}'
            - second_string: Windows
        navigate:
          - SUCCESS: reset_windows_password
          - FAILURE: set_success_message_for_unix_os
    - reset_windows_password:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.compute.compute_engine.instances.reset_windows_password:
            - access_token:
                value: '${access_token}'
                sensitive: true
            - project_id: '${project_id}'
            - zone: '${zone}'
            - instance_name: '${instance_name_out}'
            - username: '${username}'
            - timeout: '${timeout}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - password: '${return_result}'
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - insert_disk:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.compute.compute_engine.disks.insert_disk:
            - access_token:
                value: '${access_token}'
                sensitive: true
            - project_id: '${project_id}'
            - zone: '${zone}'
            - disk_name: '${disk_name}'
            - disk_type: "${'https://www.googleapis.com/compute/v1/projects/'+str(project_id)+'/zones/'+str(zone)+'/diskTypes/'+str(disk_type)+''}"
            - disk_size: '${disk_size}'
            - timeout: '${timeout}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - disk_name_out
        navigate:
          - SUCCESS: attach_disk_to_instance
          - FAILURE: undeploy_vm
    - attach_disk_to_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.compute.compute_engine.disks.attach_disk_to_instance:
            - access_token:
                value: '${access_token}'
                sensitive: true
            - project_id: '${project_id}'
            - zone: '${zone}'
            - instance_name: '${instance_name_out}'
            - source: "${'https://www.googleapis.com/compute/v1/projects/'+ str(project_id)+'/zones/'+str(zone)+'/disks/'+ str(disk_name_out)+''}"
            - timeout: '${timeout}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        navigate:
          - SUCCESS: get_disk_size
          - FAILURE: undeploy_vm
    - check_disk_name_list_is_null:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${disk_name_list}'
        navigate:
          - IS_NULL: get_instance
          - IS_NOT_NULL: check_disk_name_type_is_null
    - check_disk_name_type_is_null:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${disk_type_list}'
        navigate:
          - IS_NULL: set_failure_message_if_disk_type_doesnt_exists
          - IS_NOT_NULL: get_disk_size
    - set_failure_message_if_disk_type_doesnt_exists:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.length: []
        publish:
          - failure_message: Invalid Disk Type List.
          - return_code: '-1'
        navigate:
          - SUCCESS: FAILURE
    - random_number_generator_for_vm_disk_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.math.random_number_generator:
            - min: '10000'
            - max: '99999'
        publish:
          - random_number
        navigate:
          - SUCCESS: append_vm_disk_name
          - FAILURE: on_failure
    - append_vm_disk_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${result_string}'
            - text: '${random_number}'
        publish:
          - disk_name: '${new_string}'
        navigate:
          - SUCCESS: list_iterator_get_disk_type
    - undeploy_vm:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          manjooshtest.recheck.undeploy_vm:
            - json_token:
                value: '${json_token}'
                sensitive: true
            - project_id:
                value: '${project_id}'
                sensitive: true
            - zone: '${zone}'
            - scopes: '${scopes}'
            - instance_name: '${instance_name_out}'
            - delete_all_disks: 'true'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - worker_group: '${worker_group}'
            - timeout: '${timeout}'
            - pretty_print: null
        publish:
          - return_code
          - return_result
          - exception
        navigate:
          - SUCCESS: set_failure_message_for_instance
          - FAILURE: on_failure
    - set_failure_message_for_instance:
        do:
          io.cloudslang.base.utils.do_nothing:
            - external_ips: null
            - internal_ips: null
            - instance_name_out: null
            - zone_operation_name: null
            - self_link: null
            - status: null
            - zone_out: null
            - vm_name: null
        publish:
          - external_ips: ''
          - internal_ips: ''
          - instance_name_out: ''
          - zone_operation_name: ''
          - self_link: ''
          - status: ''
          - zone_out: ''
          - vm_name: ''
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
    - set_success_message_for_instance_with_disk_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - instance_name_out: '${instance_name_out}'
        publish:
          - return_result: "${'Instance '+str(instance_name_out)+' was successfully created.'}"
        navigate:
          - SUCCESS: check_disk_name_list_is_null
          - FAILURE: on_failure
    - get_image_type_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${instance_image_details}'
            - json_path: 'disks[*].licenses'
        publish:
          - image_type: '${return_result.replace("[","").replace("]","")}'
        navigate:
          - SUCCESS: get_image_type
          - FAILURE: on_failure
    - get_image_type:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${image_type[1:-1]}'
            - delimiter: /
            - index: end
        publish:
          - image_type: '${return_result}'
        navigate:
          - SUCCESS: os_platform_is_windows
          - FAILURE: on_failure
    - set_success_message_for_unix_os:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - instance_name_out: '${instance_name_out}'
        publish:
          - return_result: "${'Instance '+str(instance_name_out)+' was successfully created.'}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_disk_size:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${disk_size_list}'
        publish:
          - disk_size: '${result_string}'
        navigate:
          - HAS_MORE: list_iterator_get_disk_name
          - NO_MORE: get_instance
          - FAILURE: on_failure
    - list_iterator_get_disk_type:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${disk_type_list}'
        publish:
          - disk_type: '${result_string}'
        navigate:
          - HAS_MORE: insert_disk
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - list_iterator_get_disk_name:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${disk_name_list}'
        publish:
          - result_string
        navigate:
          - HAS_MORE: random_number_generator_for_vm_disk_name
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - is_volume_disk_type_is_empty:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${volume_disk_type}'
        navigate:
          - IS_NULL: get_volume_disk_type
          - IS_NOT_NULL: form_volume_disk_type_url
    - get_volume_disk_type:
        do:
          io.cloudslang.base.utils.do_nothing:
            - volume_disk_type: '${volume_disk_type}'
        publish:
          - volume_disk_type
        navigate:
          - SUCCESS: insert_instance
          - FAILURE: on_failure
    - form_volume_disk_type_url:
        do:
          io.cloudslang.base.utils.do_nothing:
            - volume_disk_type: '${volume_disk_type}'
            - project_id: '${project_id}'
            - zone: '${zone}'
        publish:
          - volume_disk_type: "${'https://www.googleapis.com/compute/v1/projects/'+str(project_id)+'/zones/'+str(zone)+'/diskTypes/'+str(volume_disk_type)+''}"
        navigate:
          - SUCCESS: insert_instance
          - FAILURE: on_failure
  outputs:
    - self_link
    - return_code
    - zone_operation_name
    - external_ips
    - internal_ips
    - instance_id
    - instance_name_out
    - status
    - exception
    - return_result
    - disks
    - vm_name
    - image_type
    - zone_out
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_volume_disk_type:
        x: 457
        'y': 99
      check_disk_name_type_is_null:
        x: 756
        'y': 283
      set_failure_message_if_disk_type_doesnt_exists:
        x: 759
        'y': 480
        navigate:
          2d92886c-3b21-8f05-0052-fc86b64b8371:
            targetId: 155c7a8a-b77e-2249-630e-4322fa93b234
            port: SUCCESS
      random_number_generator_for_vm_disk_name:
        x: 1184
        'y': 285
      form_volume_disk_type_url:
        x: 325
        'y': 287
      list_iterator_get_disk_type:
        x: 1371
        'y': 466
        navigate:
          ec2679f7-81d2-bdc8-016c-136f5b882132:
            targetId: 9f8b2def-2919-d5f7-c843-ee45bb32d29d
            port: NO_MORE
      insert_disk:
        x: 1376
        'y': 723
      check_disk_name_list_is_null:
        x: 749
        'y': 106
      get_image_type:
        x: 1200
        'y': 79
      get_access_token:
        x: 12
        'y': 397
      reset_windows_password:
        x: 1515
        'y': 78
        navigate:
          d191572d-2ebd-acb5-8365-cdddced8755e:
            targetId: 39b3c3fe-524e-b2fb-d62e-f1abcd08f3ba
            port: SUCCESS
      append_vm_disk_name:
        x: 1365
        'y': 286
      is_volume_disk_type_is_empty:
        x: 328
        'y': 98
      attach_disk_to_instance:
        x: 1003
        'y': 713
      list_iterator_get_disk_name:
        x: 1197
        'y': 460
        navigate:
          0993d496-4663-dda8-a848-62eb0f303df2:
            targetId: 9f8b2def-2919-d5f7-c843-ee45bb32d29d
            port: NO_MORE
      set_success_message_for_unix_os:
        x: 1538
        'y': 261
        navigate:
          7c1c0664-c0b0-9c5e-8829-c27625f86cd5:
            targetId: 39b3c3fe-524e-b2fb-d62e-f1abcd08f3ba
            port: SUCCESS
      append_vm_prefix:
        x: 166
        'y': 89
      set_failure_message_for_instance:
        x: 443
        'y': 625
        navigate:
          cc0d03dd-5ad0-2868-3ec7-082f8b97f99b:
            targetId: 155c7a8a-b77e-2249-630e-4322fa93b234
            port: SUCCESS
      get_image_type_list:
        x: 1061
        'y': 79
      undeploy_vm:
        x: 219
        'y': 916
      set_success_message_for_instance_with_disk_name:
        x: 625
        'y': 263
      random_number_generator:
        x: 21
        'y': 85
      get_disk_size:
        x: 998
        'y': 285
      get_machine_type:
        x: 15
        'y': 242
      insert_instance:
        x: 624
        'y': 95
      get_instance:
        x: 917
        'y': 81
      os_platform_is_windows:
        x: 1356
        'y': 79
    results:
      SUCCESS:
        39b3c3fe-524e-b2fb-d62e-f1abcd08f3ba:
          x: 1670
          'y': 78
        9f8b2def-2919-d5f7-c843-ee45bb32d29d:
          x: 1284
          'y': 631
      FAILURE:
        155c7a8a-b77e-2249-630e-4322fa93b234:
          x: 610
          'y': 629
