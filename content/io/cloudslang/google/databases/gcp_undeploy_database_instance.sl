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
#! @description: This workflow is used to delete the database instance.
#!
#! @input client_id: The client ID of your application.
#! @input client_secret: The client secret of your application.
#! @input refresh_token: The refresh token of the client ID.
#! @input project_id: The name of the project in the Google Cloud.
#!                    Example: 'example-project-a'
#! @input instance_name: The name of the resource, provided by the client when initially creating the resource.
#!                       Example: 'instance123456'
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
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Default: '10'
#!                          Optional
#! @input polling_retries: The number of retries to check if the instance is stopped.
#!                         Default: '60'
#!                         Optional
#!
#! @output return_result: This will contain the response entity.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#!
#! @result SUCCESS: The database instance deleted successfully.
#! @result FAILURE: An error occurred while deleting the database instance.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.databases

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: gcp_undeploy_database_instance
  inputs:
    - client_id
    - client_secret:
        sensitive: true
    - refresh_token:
        sensitive: true
    - project_id:
        sensitive: true
    - instance_name:
        required: true
        sensitive: false
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
    - polling_interval:
        default: '20'
        required: false
    - polling_retries:
        default: '30'
        required: false
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
          - SUCCESS: get_database_instance
          - FAILURE: on_failure
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
          - instances_json
        navigate:
          - SUCCESS: delete_database_instance
          - FAILURE: FAILURE
    - delete_database_instance:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.google.databases.instances.delete_database_instance:
            - project_id:
                value: '${project_id}'
                sensitive: true
            - access_token:
                value: '${access_token}'
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
          - return_result
          - status_code
        navigate:
          - SUCCESS: get_database_instance_post_delete_operation
          - FAILURE: get_error_message
    - get_error_message:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result}'
            - json_path: error.message
        publish:
          - return_result: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
    - counter_for_db_instance_deletion:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.counter:
            - from: '1'
            - to: '${polling_retries}'
            - increment_by: '1'
        publish:
          - result
        navigate:
          - HAS_MORE: wait_for_db_instance_deletion
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - wait_for_db_instance_deletion:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '${polling_interval}'
        navigate:
          - SUCCESS: get_database_instance_post_delete_operation
          - FAILURE: on_failure
    - get_database_instance_post_delete_operation:
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
          - status_code
        navigate:
          - SUCCESS: counter_for_db_instance_deletion
          - FAILURE: is_db_instance_not_found
    - is_db_instance_not_found:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '404'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: counter_for_db_instance_deletion
  outputs:
    - return_result
    - status_code
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_access_token_using_web_api:
        x: 80
        'y': 80
      get_database_instance:
        x: 240
        'y': 80
        navigate:
          6b3d8cfe-ad0a-3191-80f6-41b0dbaaa3a3:
            targetId: 6a738976-2b46-3b67-a9ff-09eddf569dfa
            port: FAILURE
      delete_database_instance:
        x: 400
        'y': 80
      get_error_message:
        x: 400
        'y': 280
        navigate:
          fef872a0-4cc4-43ee-30da-c5e93db6e38b:
            targetId: 6a738976-2b46-3b67-a9ff-09eddf569dfa
            port: SUCCESS
      counter_for_db_instance_deletion:
        x: 720
        'y': 280
        navigate:
          9ab23209-ac46-9112-e2a2-bb37ac20e7f0:
            targetId: 6a738976-2b46-3b67-a9ff-09eddf569dfa
            port: NO_MORE
            vertices:
              - x: 680
                'y': 480
              - x: 360
                'y': 480
      wait_for_db_instance_deletion:
        x: 560
        'y': 280
      get_database_instance_post_delete_operation:
        x: 560
        'y': 80
      is_db_instance_not_found:
        x: 720
        'y': 80
        navigate:
          e49e1ff1-d905-08bf-a458-694edc28d4e7:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 880
          'y': 80
      FAILURE:
        6a738976-2b46-3b67-a9ff-09eddf569dfa:
          x: 240
          'y': 280
