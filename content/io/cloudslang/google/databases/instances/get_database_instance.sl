#   (c) Copyright 2023 Open Text
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
#! @description: This operation is used to retrieve the database instance details.
#!
#! @input access_token: The authorization token for google cloud.
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input instance_name: The name of the database instance
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
#! @output return_result: This will contain the response entity.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output database_instance_json: A JSON list containing the Instances information.
#! @output instance_state: The current current state of the database instance.
#! @output availability_type: The availability type of the Cloud SQL instance, high availability (REGIONAL) or single zone (ZONAL).
#! @output data_disk_size_gb: The size of data disk, in GB.
#! @output data_disk_type: The type of data disk.
#! @output region: The geographical region where the instance has to be created.
#! @output database_version: The database engine type and version.
#! @output self_link: The URI of this resource.
#! @output connection_name: Connection name of the Cloud SQL instance used in connection strings.
#! @output zone: The name of the zone in which the disks has to be created.
#! @output public_ip_address: The public ip address of the instance.
#! @output private_ip_address: The private ip address of the instance.
#! @output tier: The Machine type of the instance.
#!
#! @result SUCCESS: The database instance details successfully retrieved.
#! @result FAILURE: The database instance details were not found or some inputs were given incorrectly
#!!#
########################################################################################################################
namespace: io.cloudslang.google.databases.instances
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: get_database_instance
  inputs:
    - access_token:
        sensitive: true
    - project_id:
        sensitive: true
    - instance_name
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
    - api_to_get_instance:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://sqladmin.googleapis.com/v1/projects/'+project_id+'/instances/'+instance_name}"
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
            - headers: "${'Authorization: '+access_token}"
            - content_type: application/json
            - worker_group: '${worker_group}'
            - instance: '${instance_name}'
        publish:
          - database_instance_json: '${return_result}'
          - status_code
        navigate:
          - SUCCESS: get_database_details_extract
          - FAILURE: on_failure
    - set_success_message:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - message: Information about the DB Instance has been successfully retrieved.
            - instance_json: '${database_instance_json}'
        publish:
          - return_result: '${message}'
          - database_instance_json: '${instance_json}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_database_details_extract:
        do:
          io.cloudslang.google.databases.instances.utils.get_database_details_extract:
            - instance_json: '${database_instance_json}'
        publish:
          - instance_name
          - self_link
          - database_version
          - connection_name
          - instance_state
          - availability_type
          - data_disk_size_gb
          - data_disk_type
          - region
          - zone
          - public_ip_address
          - private_ip_address
          - tier
        navigate:
          - SUCCESS: set_success_message
  outputs:
    - return_result
    - status_code
    - database_instance_json
    - instance_state
    - availability_type
    - data_disk_size_gb
    - data_disk_type
    - region
    - database_version
    - self_link
    - connection_name
    - zone
    - public_ip_address
    - private_ip_address
    - tier
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      api_to_get_instance:
        x: 160
        'y': 200
      set_success_message:
        x: 520
        'y': 200
        navigate:
          07fcb95b-c35b-4733-c816-ea61f64cc0ee:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      get_database_details_extract:
        x: 360
        'y': 200
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 720
          'y': 200
