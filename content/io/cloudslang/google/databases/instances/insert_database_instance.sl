#   (c) Copyright 2023 Micro Focus, L.P.
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
#! @description: This operation can be used to creates an database instance in the specified project.
#!
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input access_token: The authorization token for google cloud.
#! @input instance_name_prefix: The name of the resource, provided by the client when initially creating the resource. The
#!                              resource name must be 1-63 characters long, and comply with RFC1035. Specifically, the name
#!                              must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which
#!                              means the first character must be a lowercase letter, and all following characters must be a
#!                              dash, lowercase letter, or digit, except the last character, which cannot be a dash.
#!                              Example: 'instance-1234'
#! @input root_password: The initial root password. Use only on creation.
#! @input region: The geographical region where the instance has to be created.
#!                Examples: 'us-central1','us-east1'.
#! @input zone: The name of the zone in which the disks has to be created.
#!              Examples: 'us-central1-a', 'us-central1-b', 'us-central1-c'.
#!              Optional
#! @input instance_type: The instance type.
#!                       Examples: 'CLOUD_SQL_INSTANCE','ON_PREMISES_INSTANCE'
#!                       Optional
#! @input database_version: The database engine type and version. The databaseVersion field cannot be changed after
#!                          instance creation.
#!                          Examples: 'MYSQL_8_0','POSTGRES_10'.
#! @input tier: The tier (or machine type) for this instance.
#!              Example:'db-custom-1-3840'.
#! @input data_disk_type: The type of data disk.
#!                       Default: 'PD_SSD'.
#!                       Valid Values: 'PD_SSD', 'PD_HDD'.
#! @input data_disk_size_gb: The size of data disk, in GB. The data disk size minimum is 10GB.
#!                          Default: '10'.
#! @input storage_auto_resize: The configuration to increase storage size automatically.
#!                            Default: 'true'.
#! @input availability_type: Availability type.
#!                           Valid values: - ZONAL: The instance serves data from only one zone.
#!                                                  Outages in that zone affect data accessibility.
#!                                         - REGIONAL: The instance can serve data from more than one zone in a region.
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
#!                                         - NEVER: The instance is not activated, even if a connection request arrives.
#!                           Default: 'ALWAYS'.
#! @input ipv4_enabled: This specifies whether the instance is assigned a public IP address or not.
#!                      Default: 'true'.
#! @input private_network: The resource link for the VPC network from which the instance is accessible for private IP.
#!                         This setting can be updated, but it cannot be removed after it is set.
#!                         Example: '/projects/myProject/global/networks/default'.
#!                         Optional
#! @input deletion_protection_enabled: Configuration to protect against accidental instance deletion.
#!                                     Default: 'false'.
#! @input label_keys: The labels key list separated by comma(,).
#!                    Keys must conform to the following regexp: [a-zA-Z0-9-_]+, and be less than 128 bytes in
#!                    length. This is reflected as part of a URL in the metadata server. Additionally,
#!                    to avoid ambiguity, keys must not conflict with any other metadata keys for the project.
#!                    The length of the itemsKeysList must be equal with the length of the itemsValuesList.
#!                    Optional
#! @input label_values: The labels value list separated by comma(,).
#!                      Optional
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
#! @output database_instance_json: A JSON list containing the Instance information.
#! @output return_result: This will contain the response entity.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#!
#! @result SUCCESS: The request to create a database instance was successfully sent.
#! @result FAILURE: An error occurred while trying to send the request.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.databases.instances
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: insert_database_instance
  inputs:
    - project_id:
        sensitive: true
    - access_token:
        sensitive: true
    - instance_name_prefix:
        required: true
        sensitive: false
    - root_password:
        sensitive: true
    - region
    - zone:
        required: false
    - instance_type:
        required: false
    - database_version:
        required: true
    - tier:
        required: true
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
    - insert_instance_request_body:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.databases.instances.utils.insert_database_instance_request_body:
            - instance_name_prefix: '${instance_name_prefix}'
            - root_password: '${root_password}'
            - region: '${region}'
            - zone: '${zone}'
            - instance_type: '${instance_type}'
            - database_version: '${database_version}'
            - tier: '${tier}'
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
        publish:
          - request_body: '${return_result}'
        navigate:
          - SUCCESS: api_call_to_create_the_instance
    - api_call_to_create_the_instance:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${'https://sqladmin.googleapis.com/v1/projects/'+project_id+'/instances'}"
            - auth_type: anonymous
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
            - request_character_set: UTF-8
            - headers: "${'Authorization: '+access_token}"
            - query_params: null
            - body: '${request_body}'
            - content_type: application/json
            - worker_group: '${worker_group}'
        publish:
          - return_result
          - error_message
          - status_code
        navigate:
          - SUCCESS: set_success_message
          - FAILURE: on_failure
    - set_success_message:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - message: "${'The instance '+ instance_name_prefix+' created successfully.'}"
            - database_instance_json: '${return_result}'
        publish:
          - return_result: '${message}'
          - database_instance_json
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - database_instance_json
    - return_result
    - status_code
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      set_success_message:
        x: 400
        'y': 160
        navigate:
          5b2f36b4-9be2-4b4f-2ea4-5c767cb0f885:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      api_call_to_create_the_instance:
        x: 240
        'y': 160
      insert_instance_request_body:
        x: 80
        'y': 160
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 560
          'y': 160