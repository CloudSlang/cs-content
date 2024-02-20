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
#! @description: This workflow is used to deploy the database instance in the specified project.
#!
#! @input client_id: The client ID of your application.
#! @input client_secret: The client secret of your application.
#! @input refresh_token: The refresh token of the client ID.
#! @input project_id: The name of the project in the Google Cloud.
#!                    Example: 'example-project-a'
#! @input region: The geographical region where the instance has to be created.
#!                Examples: 'us-central1','us-east1'.
#! @input zone: The name of the zone in which the disks has to be created.
#!              Examples: 'us-central1-a', 'us-central1-b', 'us-central1-c'.
#!              Optional
#! @input instance_name_prefix: The name of the resource, provided by the client when initially creating the resource. The
#!                              resource name must be 1-63 characters long, and comply with RFC1035. Specifically, the name
#!                              must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which
#!                              means the first character must be a lowercase letter, and all following characters must be a
#!                              dash, lowercase letter, or digit, except the last character, which cannot be a dash.
#!                              Example: 'instance-12345'
#! @input database_version: The database engine type and version. The databaseVersion field cannot be changed after
#!                          instance creation.
#!                          Examples: 'MYSQL_8_0','POSTGRES_10'.
#! @input machine_type: The tier (or machine type) for this instance.
#!                      Example:'db-custom-1-3840'.
#!                      Optional
#! @input cores: The number of vCPU's. The range lies between 1 to 96.
#!               Example: 2.
#!               Optional
#! @input memory: The memory of instance type . The range lies between 3.75 to 13 in GB.
#!                Example: 3.75
#!                Optional
#! @input database_instance_root_password: The initial root password. Use only on creation.
#! @input product_id: The product Id.
#! @input product_name: The product name.
#! @input business_unit: The business unit.
#! @input environment: The environment type.
#! @input data_disk_type: The type of data disk.
#!                        Default: 'PD_SSD'.
#!                        Valid Values: 'PD_SSD', 'PD_HDD'.
#! @input data_disk_size_gb: The size of data disk, in GB. The data disk size minimum is 10GB.
#!                           Default: '10'.
#! @input storage_auto_resize: The configuration to increase storage size automatically.
#!                             Default: 'true'.
#! @input availability_type: The availability type.
#!                           Valid values:- ZONAL: The instance serves data from only one zone.
#!                           Outages in that zone affect data accessibility.
#!                           REGIONAL: The instance can serve data from more than one zone in a region.
#!                           Default: 'REGIONAL'.
#! @input maintenance_window_day: Maintenance window day specifies the day of week (1-7),starting on Monday,when a Cloud
#!                                SQL instance is restarted for system maintenance purposes.
#!                                Default: '7'.
#! @input maintenance_window_hour: Maintenance window hour specifies the hour of day(0 to 23), when a Cloud SQL instance
#!                                 is restarted for system maintenance purposes.
#!                                 Default: '0'.
#! @input activation_policy: The activation policy specifies when the instance is activated;  it is applicable only when
#!                           the instance state is RUNNABLE.
#!                           Valid values: - ALWAYS: The instance remains on even in the absence of connection requests.
#!                           - NEVER: The instance is not activated, even if a connection request arrives.
#!                           Default: 'ALWAYS'.
#! @input ipv4_enabled: This specifies whether the instance is assigned a public IP address or not.
#!                      Default: 'true'.
#! @input private_network: The resource link for the VPC network from which the instance is accessible for private IP.
#!                         This setting can be updated, but it cannot be removed after it is set.
#!                         Example: '/projects/myProject/global/networks/default'.
#!                         Optional
#! @input deletion_protection_enabled: Configuration to protect against accidental instance deletion.
#!                                     Default: 'false'.
#! @input label_keys_list: The labels key list separated by comma(,).
#!                         Keys must conform to the following regexp: [a-zA-Z0-9-_]+, and be less than 128 bytes in
#!                         length. This is reflected as part of a URL in the metadata server. Additionally,
#!                         to avoid ambiguity, keys must not conflict with any other metadata keys for the project.
#!                         The length of the itemsKeysList must be equal with the length of the itemsValuesList.
#!                         Optional
#! @input label_values_list: The labels value list separated by comma(,).
#!                           Optional
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Default: '10'
#!                          Optional
#! @input polling_retries: The number of retries to check if the instance is stopped.
#!                         Default: '60'
#!                         Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input proxy_host: Proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services.
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: '..JAVA_HOME/java/lib/security/cacerts'
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#!
#! @output instance_name: The name of the database instance.
#! @output instance_state: The current current state of the database instance.
#! @output self_link: The URI of database instance resource.
#! @output connection_name: Connection name of the Cloud SQL instance used in connection strings.
#! @output public_ip_address: The public ip address of the instance.
#! @output private_ip_address: The private ip address of the instance.
#! @output pricing_plan: The pricing plan for this instance. This can be either PER_USE or PACKAGE.
#! @output replication_type: The type of replication this instance uses. This can be either ASYNCHRONOUS or SYNCHRONOUS.
#! @output return_result: This will contain the response entity.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output tier: The tier (or machine type) for this instance.
#! @output label_json: The JSON containing both organizational tags and custom tags.
#!
#! @result SUCCESS: The request to create a database instance was successfully sent.
#! @result FAILURE: An error occurred while trying to send the request.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.databases
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: gcp_deploy_database_instance
  inputs:
    - client_id
    - client_secret:
        sensitive: true
    - refresh_token:
        sensitive: true
    - project_id:
        sensitive: true
    - region
    - zone:
        required: false
    - instance_name_prefix:
        required: true
        sensitive: false
    - database_version:
        required: true
    - machine_type:
        required: false
    - cores:
        required: false
    - memory:
        required: false
    - database_instance_root_password:
        sensitive: true
    - product_id
    - product_name
    - business_unit
    - environment
    - data_disk_type:
        default: PD_SSD
        required: false
    - data_disk_size_gb:
        default: '10'
        required: false
    - storage_auto_resize:
        default: 'true'
        required: false
    - availability_type:
        default: REGIONAL
        required: false
    - maintenance_window_day:
        default: '7'
        required: false
    - maintenance_window_hour:
        default: '0'
        required: false
    - activation_policy:
        default: ALWAYS
        required: false
    - ipv4_enabled:
        default: 'true'
        required: false
    - private_network:
        required: false
    - deletion_protection_enabled:
        default: 'false'
        required: false
    - label_keys_list:
        private: false
        required: false
    - label_values_list:
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
    - get_access_token_using_web_api:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.google.authentication.get_access_token_using_web_api:
            - client_id: '${client_id}'
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
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - access_token
          - return_result
        navigate:
          - SUCCESS: list_to_json_for_labels
          - FAILURE: on_failure
    - is_machine_type_null:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${machine_type}'
        navigate:
          - IS_NULL: is_cores_null
          - IS_NOT_NULL: random_number_generator
    - is_cores_null:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${cores}'
        navigate:
          - IS_NULL: set_failure_message_due_to_missing_input_values
          - IS_NOT_NULL: is_memory_null
    - is_memory_null:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${memory}'
        navigate:
          - IS_NULL: set_failure_message_due_to_missing_input_values
          - IS_NOT_NULL: form_custom_machine_type_value
    - set_failure_message_due_to_missing_input_values:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - message: 'Either the "MachineType" or "cores" and "memory" values are required for SQL instance creation.'
        publish:
          - return_result: '${message}'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
    - random_number_generator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.math.random_number_generator:
            - min: '10000'
            - max: '99999'
        publish:
          - random_number
        navigate:
          - SUCCESS: form_instance_name
          - FAILURE: on_failure
    - insert_database_instance:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.google.databases.instances.insert_database_instance:
            - project_id:
                value: '${project_id}'
                sensitive: true
            - access_token:
                value: '${access_token}'
                sensitive: true
            - instance_name_prefix: '${instance_name}'
            - root_password:
                value: '${database_instance_root_password}'
                sensitive: true
            - region: '${region}'
            - zone: '${zone}'
            - instance_type: CLOUD_SQL_INSTANCE
            - database_version: '${database_version}'
            - tier: '${machine_type}'
            - data_disk_type: '${data_disk_type}'
            - data_disk_size_gb: '${data_disk_size_gb}'
            - storage_auto_resize: '${storage_auto_resize}'
            - availability_type: '${availability_type}'
            - maintenance_window_day: '${maintenance_window_day}'
            - maintenance_window_hour: '${maintenance_window_hour}'
            - activation_policy: '${activation_policy}'
            - ipv4_enabled: '${ipv4_enabled}'
            - private_network: '${private_network}'
            - deletion_protection_enabled: '${deletion_protection_enabled}'
            - label_keys_list: '${label_keys_list}'
            - label_values_list: '${label_values_list}'
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
          - database_instance_json
          - return_result
          - status_code
        navigate:
          - SUCCESS: get_database_instance
          - FAILURE: set_failure_message_of_create_database_instance
    - get_database_instance:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.google.databases.instances.get_database_instance:
            - access_token:
                value: '${access_token}'
                sensitive: true
            - project_id:
                value: '${project_id}'
                sensitive: true
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
          - instance_state
          - availability_type
          - data_disk_size_gb
          - data_disk_type
          - database_version
          - self_link
          - connection_name
          - public_ip_address
          - private_ip_address
          - database_instance_json
          - tier
        navigate:
          - SUCCESS: get_db_instance_state
          - FAILURE: on_failure
    - set_failure_message_of_create_database_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - message: "${'Unable to create SQL database instance ' + instance_name +' : ' + return_result}"
        publish:
          - return_result: '${message}'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
    - form_custom_machine_type_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.math.multiply_numbers:
            - value1: '${memory}'
            - value2: '1024'
            - cores: '${cores}'
        publish:
          - machine_type: "${'db-custom-'+cores+'-'+result}"
        navigate:
          - SUCCESS: random_number_generator
    - is_db_instance_in_runnable_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${db_instance_state}'
            - second_string: RUNNABLE
            - ignore_case: 'true'
        navigate:
          - SUCCESS: get_pricing_plan_of_db_instance
          - FAILURE: is_db_instance_in_failed_state
    - counter_for_db_instance_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.counter:
            - from: '1'
            - to: '${polling_retries}'
            - increment_by: '1'
        publish:
          - result
        navigate:
          - HAS_MORE: wait_for_db_instance_running_state
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - wait_for_db_instance_running_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '${polling_interval}'
        navigate:
          - SUCCESS: get_database_instance
          - FAILURE: on_failure
    - is_db_instance_in_failed_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${db_instance_state}'
            - second_string: FAILED
            - ignore_case: 'true'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: is_db_instance_in_unknown_state
    - is_db_instance_in_unknown_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${db_instance_state}'
            - second_string: SQL_INSTANCE_STATE_UNSPECIFIED
            - ignore_case: 'true'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: counter_for_db_instance_state
    - is_db_instance_in_pending_create_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${db_instance_state}'
            - second_string: PENDING_CREATE
            - ignore_case: 'true'
        navigate:
          - SUCCESS: counter_for_db_instance_state
          - FAILURE: is_db_instance_in_runnable_state
    - get_db_instance_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${database_instance_json}'
            - json_path: state
        publish:
          - db_instance_state: '${return_result}'
        navigate:
          - SUCCESS: is_db_instance_in_pending_create_state
          - FAILURE: on_failure
    - get_pricing_plan_of_db_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${database_instance_json}'
            - json_path: settings.pricingPlan
        publish:
          - pricing_plan: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: get_replication_type_of_db_instance
          - FAILURE: on_failure
    - get_replication_type_of_db_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${database_instance_json}'
            - json_path: settings.replicationType
        publish:
          - replication_type: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - form_instance_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${instance_name_prefix}'
            - text: '${random_number}'
        publish:
          - instance_name: '${new_string}'
        navigate:
          - SUCCESS: insert_database_instance
    - list_to_json_for_labels:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.databases.instances.utils.list_to_json_for_labels:
            - label_keys: '${label_keys_list}'
            - label_values: '${label_values_list}'
            - organizational_key_list: 'business_unit,product_id,product_name,environment'
            - organizational_value_list: "${business_unit+','+product_id+','+product_name+','+environment}"
        publish:
          - label_json
          - label_keys_list: '${key_list}'
          - label_values_list: '${value_list}'
        navigate:
          - SUCCESS: is_machine_type_null
  outputs:
    - instance_name
    - instance_state
    - self_link
    - connection_name
    - public_ip_address
    - private_ip_address
    - pricing_plan
    - replication_type
    - return_result
    - status_code
    - tier
    - label_json
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      is_db_instance_in_unknown_state:
        x: 1200
        'y': 240
        navigate:
          c61935ec-6de4-d935-5b51-ec20169d391b:
            targetId: 1e4f50be-4426-3e75-353f-3e957bcc5105
            port: SUCCESS
            vertices:
              - x: 1240
                'y': 480
      get_pricing_plan_of_db_instance:
        x: 1520
        'y': 80
      is_cores_null:
        x: 240
        'y': 240
      wait_for_db_instance_running_state:
        x: 880
        'y': 240
      list_to_json_for_labels:
        x: 80
        'y': 80
      is_db_instance_in_runnable_state:
        x: 1360
        'y': 80
      is_db_instance_in_failed_state:
        x: 1360
        'y': 240
        navigate:
          fd19b817-72e0-cb7d-df23-3e6b461feaaa:
            targetId: 1e4f50be-4426-3e75-353f-3e957bcc5105
            port: SUCCESS
            vertices:
              - x: 1400
                'y': 560
      counter_for_db_instance_state:
        x: 1040
        'y': 240
        navigate:
          1f99efb2-139e-e6d6-1e7c-bd186a1a70c8:
            targetId: 1e4f50be-4426-3e75-353f-3e957bcc5105
            port: NO_MORE
      get_database_instance:
        x: 880
        'y': 80
      is_memory_null:
        x: 240
        'y': 400
      is_db_instance_in_pending_create_state:
        x: 1200
        'y': 80
      insert_database_instance:
        x: 720
        'y': 80
        navigate:
          8a164750-c8c4-b67c-8b21-cc982433ff77:
            vertices:
              - x: 680
                'y': 280
            targetId: set_failure_message_1
            port: FAILURE
      set_failure_message_of_create_database_instance:
        x: 560
        'y': 280
        navigate:
          3e7879fb-d2ea-1c16-c9c3-abe32a229df4:
            targetId: 1e4f50be-4426-3e75-353f-3e957bcc5105
            port: SUCCESS
      get_replication_type_of_db_instance:
        x: 1520
        'y': 400
        navigate:
          caeb6ad2-6935-0600-9015-89d58517db0a:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      form_custom_machine_type_value:
        x: 400
        'y': 400
      random_number_generator:
        x: 400
        'y': 80
      form_instance_name:
        x: 560
        'y': 80
      get_access_token_using_web_api:
        x: 80
        'y': 240
      get_db_instance_state:
        x: 1040
        'y': 80
      is_machine_type_null:
        x: 240
        'y': 80
      set_failure_message_due_to_missing_input_values:
        x: 80
        'y': 400
        navigate:
          78fccac2-5a1e-453d-e935-8ab45418897a:
            targetId: 1e4f50be-4426-3e75-353f-3e957bcc5105
            port: SUCCESS
            vertices:
              - x: 160
                'y': 520
              - x: 480
                'y': 560
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 1720
          'y': 240
      FAILURE:
        1e4f50be-4426-3e75-353f-3e957bcc5105:
          x: 800
          'y': 520
