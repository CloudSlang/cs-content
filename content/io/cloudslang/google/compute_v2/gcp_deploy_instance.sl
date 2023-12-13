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
#! @description: This flow deploys an instance in Google cloud.
#!
#! @input client_id: The client ID for your application.
#! @input client_secret: The client secret for your application.
#! @input refresh_token: The refresh token of the client.
#! @input project_id: The Google Cloud project id.Example: 'example-project-a'
#! @input zone: The name of the zone where the disk is located.
#!              Examples: 'us-central1-a, us-central1-b, us-central1-c'
#! @input instance_name: The prefix of the instance name.
#! @input machine_type: The machine type used for this instance.
#!                      Example : 'n1-standard-1'.
#! @input network: The URL of the network resource for this instance. When creating an instance,if neither the network nor
#!                 the subnetwork is specified, the default network global/networks/default is used.
#!                 If the network is not specified but the subnetwork is specified, the network is inferred.
#!                 This field is optional when creating a firewall rule. If not specified when creating a firewall rule,
#!                 the default network global/networks/default is used.
#!                 Example : 'https://www.googleapis.com/compute/v1/projects/project/global/networks/network'
#!                 Optional
#! @input sub_network: The URL of the Subnetwork resource for this instance. If the network resource is in legacy mode,
#!                     do not provide this property. If the network is in auto subnet mode,If the network is in custom subnet mode,
#!                     then this field should be specified.
#!                     Example : 'https://www.googleapis.com/compute/v1/projects/project/regions/region/subnetworks/subnetwork'
#!                     Optional
#! @input boot_disk_source_image: The source image required to create a boot disk.
#!                                Example : 'https://www.googleapis.com/compute/v1/projects/windows-cloud/global/images/image'
#! @input boot_disk_size: Specifies the size in GB of the disk on which the system will be installed.
#! @input instance_description: The description of this instance.
#!                              Optional
#! @input auto_delete: Specifies whether the disk will be auto-deleted when the instance is deleted (but not when thedisk is detached from the instance).Default: 'true'.Optional
#! @input boot_disk_name: Specifies the disk name. If not specified, the default is to use the name of the instance. If adisk with the same name already exists in the given region, the existing disk is attached to thenew instance and the new disk is not created.
#! @input boot_disk_type: Specifies the disk type to use to create this instance.
#!                        Valid values: pd-ssd,pd-balanced,pd-standard,pd-extreme
#!                        Optional
#! @input boot_disk_description: An optional description of this resource. Provide this property when you create the resource.
#! @input additional_disk_name: The name of the additional disk.
#! @input additional_disk_type: The type of the additional disk.
#! @input additional_disk_size: The size of the additional disk.
#! @input label_keys: The labels key list separated by comma(,).Keys must conform to the following regexp: [a-zA-Z0-9-_]+, and be less than 128 bytes inlength. This is reflected as part of a URL in the metadata server. Additionally,to avoid ambiguity, keys must not conflict with any other metadata keys for the project.The length of the itemsKeysList must be equal with the length of the itemsValuesList.Optional
#! @input label_values: The labels value list separated by comma(,).Optional
#! @input tags_list: The list of tags to apply to this instance. Tags are used to identify valid sources or targets fornetwork firewalls and are specified by the client during instance creation. The tags can be latermodified by the setTags method. Each tag within the list must comply with RFC1035. Multiple tagscan be specified via the 'tags.items' field. The values should be separated by comma(,).Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input proxy_host: The proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: The proxy server used to access the provider services.
#!                    Optional
#! @input proxy_username: The proxy server username.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL.Default: 'false'Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name inthe subject's Common Name (CN) or subjectAltName field of the X.509 certificateValid: 'strict', 'browser_compatible', 'allow_all'Default: 'strict'Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates fromother parties that you expect to communicate with, or from Certificate Authorities thatyou trust to identify other parties.  If the protocol (specified by the 'url') is not'https' or if trust_all_roots is 'true' this input is ignored.Default value: '..JAVA_HOME/java/lib/security/cacerts'Format: Java KeyStore (JKS)Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is falseand trust_keystore is empty, trust_password default will be supplied.Optional
#!
#! @output return_result: contains the exception in case of failure, success message otherwise.
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output exception: exception if there was an error when executing, empty otherwise.
#! @output external_ips: A comma-separated list of external IPs, accessible from outside of the Google Cloud Network, allocated to the instance.
#! @output internal_ips: A comma-separated list of internal IPs, accessible only from inside of the Google Cloud Network, allocated to the instance.
#! @output instance_id: The ID of this instance.
#! @output status: The status of this instance.
#! @output image_type: The type of the OS image used to create the instance.
#! @output disk_device_names: A list of all the disk device names that are attached to this instance.
#! @output self_link: The server-defined URL for this instance.
#! @output instance_final_name: The name of the created instance.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute_v2
flow:
  name: gcp_deploy_instance
  inputs:
    - client_id:
        sensitive: false
    - client_secret:
        sensitive: true
    - refresh_token:
        sensitive: true
    - project_id:
        sensitive: true
    - zone
    - instance_name
    - machine_type
    - network:
        required: true
    - sub_network:
        required: true
    - boot_disk_source_image
    - boot_disk_size:
        required: true
    - instance_description:
        required: false
    - auto_delete:
        default: 'true'
        required: false
    - boot_disk_name:
        required: false
    - boot_disk_type:
        required: false
    - boot_disk_description:
        required: false
    - additional_disk_name:
        required: false
    - additional_disk_type:
        required: false
    - additional_disk_size:
        required: false
    - label_keys:
        required: false
    - label_values:
        required: false
    - tags_list:
        required: false
    - polling_interval:
        default: '20'
        required: false
    - polling_retries:
        default: '30'
        required: false
    - worker_group:
        default: RAS_Operator_Path
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
  workflow:
    - check_label_keys_values_equal:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.compute_v2.utils.check_label_keys_values_equal:
            - label_keys: '${label_keys}'
            - label_values: '${label_values}'
        publish:
          - return_result: '${error_message}'
        navigate:
          - SUCCESS: get_access_token_using_web_api
          - FAILURE: on_failure
    - get_access_token_using_web_api:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.google.authentication.get_access_token_using_web_api:
            - client_id:
                value: '${client_id}'
                sensitive: true
            - client_secret:
                value: '${client_secret}'
                sensitive: true
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
        publish:
          - access_token
          - return_result
          - status_code
        navigate:
          - SUCCESS: random_number_generator
          - FAILURE: on_failure
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
          - SUCCESS: is_disk_type_is_empty
    - is_additional_disk_name_is_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${additional_disk_name}'
        navigate:
          - IS_NULL: get_instance
          - IS_NOT_NULL: check_disk_name_type_is_null
    - check_disk_name_type_is_null:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${additional_disk_type}'
        navigate:
          - IS_NULL: default_additional_disk_type_url
          - IS_NOT_NULL: form_additional_disk_type_url
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
            - origin_string: '${additional_disk_name}'
            - text: '${random_number}'
        publish:
          - additional_disk_name: '${new_string}'
        navigate:
          - SUCCESS: insert_disk
    - is_disk_type_is_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${boot_disk_type}'
        navigate:
          - IS_NULL: default_disk_type_url
          - IS_NOT_NULL: form_disk_type_url
    - form_disk_type_url:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - boot_disk_type: '${boot_disk_type}'
            - project_id: '${project_id}'
            - zone: '${zone}'
            - machine_type: '${machine_type}'
        publish:
          - boot_disk_type: "${'https://www.googleapis.com/compute/v1/projects/'+str(project_id)+'/zones/'+str(zone)+'/diskTypes/'+str(boot_disk_type)+''}"
          - machine_type: "${'https://www.googleapis.com/compute/v1/projects/'+str(project_id)+'/zones/'+str(zone)+'/machineTypes/'+str(machine_type)+''}"
        navigate:
          - SUCCESS: insert_instance
          - FAILURE: on_failure
    - default_disk_type_url:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - boot_disk_type: '${boot_disk_type}'
            - project_id: '${project_id}'
            - zone: '${zone}'
            - machine_type: '${machine_type}'
        publish:
          - boot_disk_type: "${'https://www.googleapis.com/compute/v1/projects/'+str(project_id)+'/zones/'+str(zone)+'/diskTypes/pd-standard'}"
          - machine_type: "${'https://www.googleapis.com/compute/v1/projects/'+str(project_id)+'/zones/'+str(zone)+'/machineTypes/'+str(machine_type)+''}"
        navigate:
          - SUCCESS: insert_instance
          - FAILURE: on_failure
    - insert_instance:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.google.compute_v2.instances.insert_instance:
            - project_id:
                value: '${project_id}'
                sensitive: true
            - access_token:
                value: '${access_token}'
                sensitive: true
            - zone: '${zone}'
            - instance_name: '${instance_name}'
            - machine_type: '${machine_type}'
            - network: '${network}'
            - subnetwork: '${sub_network}'
            - instance_description: '${instance_description}'
            - access_config_name: External NAT
            - auto_delete: '${auto_delete}'
            - disk_device_name: '${instance_name}'
            - disk_source_image: '${boot_disk_source_image}'
            - disk_name: '${instance_name}'
            - disk_description: '${disk_description}'
            - disk_size: '${boot_disk_size}'
            - disk_type: '${boot_disk_type}'
            - label_keys: '${label_keys}'
            - label_values: '${label_values}'
            - tags_list: '${tags_list}'
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
          - instance_json
          - return_result
        navigate:
          - SUCCESS: is_additional_disk_name_is_empty
          - FAILURE: on_failure
    - default_additional_disk_type_url:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - project_id: '${project_id}'
            - zone: '${zone}'
        publish:
          - additional_disk_type: "${'https://www.googleapis.com/compute/v1/projects/'+str(project_id)+'/zones/'+str(zone)+'/diskTypes/pd-standard'}"
        navigate:
          - SUCCESS: random_number_generator_for_vm_disk_name
          - FAILURE: on_failure
    - insert_disk:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.google.compute_v2.disks.insert_disk:
            - project_id:
                value: '${project_id}'
                sensitive: true
            - access_token:
                value: '${access_token}'
                sensitive: true
            - zone: '${zone}'
            - disk_name: '${additional_disk_name}'
            - disk_type: '${additional_disk_type}'
            - disk_size: '${additional_disk_size}'
            - label_keys: '${label_keys}'
            - label_values: '${label_values}'
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
          - status_code
          - disk_json
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: delete_disk
    - attach_disk:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.google.compute_v2.disks.attach_disk:
            - project_id:
                value: '${project_id}'
                sensitive: true
            - access_token:
                value: '${access_token}'
                sensitive: true
            - zone: '${zone}'
            - instance_name: '${instance_name}'
            - disk_name: '${additional_disk_name}'
            - auto_delete: '${auto_delete}'
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
        navigate:
          - SUCCESS: get_instance
          - FAILURE: delete_disk
    - delete_disk:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.google.compute_v2.disks.delete_disk:
            - project_id:
                value: '${project_id}'
                sensitive: true
            - access_token:
                value: '${access_token}'
                sensitive: true
            - zone: '${zone}'
            - disk_name: '${additional_disk_name}'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
    - get_instance:
        worker_group:
          value: '${worker_group}'
          override: true
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
          - internal_ips
          - external_ips
          - metadata
          - status_code
          - instance_json
          - instance_id
          - self_link
          - instance_final_name: '${resource_id}'
        navigate:
          - SUCCESS: compare_power_state
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
          - SUCCESS: get_image_type_list
          - FAILURE: counter
    - counter:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.counter:
            - from: '1'
            - to: '${polling_retries}'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: sleep
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - sleep:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '${polling_interval}'
        navigate:
          - SUCCESS: get_instance
          - FAILURE: on_failure
    - get_image_type_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${instance_json}'
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
          - SUCCESS: get_disk_device_names
          - FAILURE: on_failure
    - get_disk_device_names:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${instance_json}'
            - json_path: 'disks[*].deviceName'
        publish:
          - disk_device_names: "${return_result.replace(\"[\",\"\").replace(\"]\",\"\").replace('\"',\"\")}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - form_additional_disk_type_url:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - additional_disk_type: '${additional_disk_type}'
            - project_id: '${project_id}'
            - zone: '${zone}'
        publish:
          - additional_disk_type: "${'https://www.googleapis.com/compute/v1/projects/'+str(project_id)+'/zones/'+str(zone)+'/diskTypes/'+str(additional_disk_type)+''}"
        navigate:
          - SUCCESS: random_number_generator_for_vm_disk_name
          - FAILURE: on_failure
    - get_disk:
        do:
          io.cloudslang.google.compute_v2.disks.get_disk:
            - access_token:
                value: '${access_token}'
                sensitive: true
            - project_id:
                value: '${project_id}'
                sensitive: true
            - zone: '${zone}'
            - resource_id: '${additional_disk_name}'
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
          - disk_json
        navigate:
          - SUCCESS: json_path_query_1
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${disk_json}'
            - json_path: targetLink
        publish:
          - disk_resource_id: '${return_result}'
        navigate:
          - SUCCESS: get_disk
          - FAILURE: on_failure
    - json_path_query_1:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${disk_json}'
            - json_path: status
        publish:
          - disk_status: '${return_result}'
        navigate:
          - SUCCESS: compare_power_state_1
          - FAILURE: on_failure
    - compare_power_state_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${disk_status}'
            - second_string: READY
            - ignore_case: 'true'
        publish: []
        navigate:
          - SUCCESS: attach_disk
          - FAILURE: counter_1
    - counter_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.counter:
            - from: '1'
            - to: '${polling_retries}'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: sleep_1
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - sleep_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '${polling_interval}'
        navigate:
          - SUCCESS: get_disk
          - FAILURE: on_failure
  outputs:
    - return_result
    - return_code
    - exception
    - external_ips
    - internal_ips
    - instance_id
    - status
    - image_type
    - disk_device_names
    - self_link
    - instance_final_name
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      check_label_keys_values_equal:
        x: 40
        'y': 440
      check_disk_name_type_is_null:
        x: 640
        'y': 280
        navigate:
          13868285-1c93-bce9-cc55-9c193c6256f2:
            vertices:
              - x: 640
                'y': 440
            targetId: default_additional_disk_type_url
            port: IS_NULL
      random_number_generator_for_vm_disk_name:
        x: 800
        'y': 280
      insert_disk:
        x: 960
        'y': 280
      json_path_query:
        x: 1000
        'y': 200
      get_disk:
        x: 1080
        'y': 320
      get_image_type:
        x: 1640
        'y': 280
      sleep_1:
        x: 1605.7777099609375
        'y': 429.5555419921875
      append_vm_disk_name:
        x: 800
        'y': 480
      is_additional_disk_name_is_empty:
        x: 640
        'y': 80
        navigate:
          0e5001f7-877d-ac64-4f05-ca773bdbcc08:
            vertices:
              - x: 760
                'y': 200
            targetId: check_disk_name_type_is_null
            port: IS_NOT_NULL
          7bca4121-e58c-258f-657d-acc4c438879a:
            vertices:
              - x: 800
                'y': 80
              - x: 880
                'y': 80
            targetId: get_instance
            port: IS_NULL
      default_disk_type_url:
        x: 360
        'y': 80
      counter_1:
        x: 1400
        'y': 360
        navigate:
          d5596f52-6a7b-0f04-0bb2-dafa3cc01111:
            targetId: 155c7a8a-b77e-2249-630e-4322fa93b234
            port: NO_MORE
      form_additional_disk_type_url:
        x: 800
        'y': 120
      compare_power_state_1:
        x: 1320
        'y': 440
      is_disk_type_is_empty:
        x: 360
        'y': 280
        navigate:
          bbfd2da2-0e28-9514-f88e-e18c2cd4d632:
            vertices:
              - x: 320
                'y': 240
            targetId: default_disk_type_url
            port: IS_NULL
          ae4e4cbf-280c-73e4-330b-a73292f7c180:
            vertices:
              - x: 320
                'y': 440
            targetId: form_disk_type_url
            port: IS_NOT_NULL
      form_disk_type_url:
        x: 360
        'y': 480
      delete_disk:
        x: 960
        'y': 480
        navigate:
          a4f90d1f-2309-1f46-f9f7-08a260c1614b:
            targetId: 155c7a8a-b77e-2249-630e-4322fa93b234
            port: SUCCESS
      default_additional_disk_type_url:
        x: 640
        'y': 480
      append_vm_prefix:
        x: 200
        'y': 280
      get_image_type_list:
        x: 1640
        'y': 80
      json_path_query_1:
        x: 1200
        'y': 440
      sleep:
        x: 1320
        'y': 280
      attach_disk:
        x: 1240
        'y': 320
      get_disk_device_names:
        x: 1800
        'y': 280
        navigate:
          6509c166-e60d-4545-a968-fe87b306346b:
            targetId: 39b3c3fe-524e-b2fb-d62e-f1abcd08f3ba
            port: SUCCESS
      random_number_generator:
        x: 200
        'y': 80
        navigate:
          0d9f6793-9c2b-e1c3-5168-30f2bc9b4dee:
            vertices:
              - x: 160
                'y': 240
            targetId: append_vm_prefix
            port: SUCCESS
      insert_instance:
        x: 520
        'y': 280
      get_access_token_using_web_api:
        x: 40
        'y': 80
      counter:
        x: 1480
        'y': 280
        navigate:
          36d38ce3-c08c-a034-fb91-464be8ba08da:
            targetId: 155c7a8a-b77e-2249-630e-4322fa93b234
            port: NO_MORE
      compare_power_state:
        x: 1480
        'y': 80
      get_instance:
        x: 960
        'y': 80
    results:
      SUCCESS:
        39b3c3fe-524e-b2fb-d62e-f1abcd08f3ba:
          x: 2000
          'y': 80
      FAILURE:
        155c7a8a-b77e-2249-630e-4322fa93b234:
          x: 1480
          'y': 480