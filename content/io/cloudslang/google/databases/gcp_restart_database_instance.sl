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
#! @description: This operation is used to restart the database instance.
#!
#! @input client_id: The client ID for your application.
#! @input client_secret: The client secret for your application.
#! @input refresh_token: Refresh token.
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input instance_name: The name of the database instance
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Default: '20'
#!                          Optional
#! @input polling_retries: The number of retries to check if the instance is started.
#!                         Default: '30'
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
#! @output return_result: This will contain the response entity.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#!
#! @result SUCCESS: The database instance restarted successfully.
#! @result FAILURE: The database instance fail to restart.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.databases
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: gcp_restart_database_instance
  inputs:
    - client_id:
        sensitive: false
    - client_secret:
        sensitive: true
    - refresh_token:
        sensitive: true
    - project_id:
        sensitive: true
    - instance_name
    - polling_interval: '20'
    - polling_retries: '30'
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
            - client_secret: '${client_secret}'
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
        navigate:
          - SUCCESS: get_database_instance
          - FAILURE: on_failure
    - get_database_instance_details:
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
          - public_ip_address
          - private_ip_address
          - return_result: "${\"SQL instance \\\"\"+instance_name+\"\\\"  is restarted.\"}"
        navigate:
          - SUCCESS: SUCCESS
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
          - public_ip_address
          - private_ip_address
        navigate:
          - SUCCESS: check_if_instance_is_in_stopped_state
          - FAILURE: on_failure
    - check_if_instance_is_in_stopped_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${instance_state}'
            - second_string: STOPPED
            - ignore_case: 'true'
        navigate:
          - SUCCESS: set_message
          - FAILURE: restart_database_instance
    - set_message:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - instance_name: '${instance_name}'
        publish:
          - return_result: "${\"SQL instance \\\"\"+instance_name+\"\\\"  is in stopped state and hence cannot be restarted.\"}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - compare_operation_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status}'
            - second_string: DONE
            - ignore_case: 'true'
        publish: []
        navigate:
          - SUCCESS: get_database_instance_details
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
          - SUCCESS: get_database_operation_details
          - FAILURE: on_failure
    - restart_database_instance:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.google.databases.instances.restart_database_instance:
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
          - return_result
          - status_code
          - database_instance_json
        navigate:
          - SUCCESS: get_operation_details
          - FAILURE: on_failure
    - get_database_operation_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.google.databases.instances.get_database_operation_details:
            - access_token:
                value: '${access_token}'
                sensitive: true
            - project_id:
                value: '${project_id}'
                sensitive: true
            - name: '${name}'
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
          - return_result
          - status
        navigate:
          - SUCCESS: compare_operation_state
          - FAILURE: on_failure
    - get_operation_details:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.databases.instances.utils.get_operation_details:
            - instance_json: '${database_instance_json}'
        publish:
          - self_link
          - status
          - name
        navigate:
          - SUCCESS: get_database_operation_details
  outputs:
    - return_result
    - status_code
    - instance_state
    - public_ip_address
    - private_ip_address
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_operation_details:
        x: 600
        'y': 160
      restart_database_instance:
        x: 440
        'y': 160
      set_message:
        x: 280
        'y': 400
        navigate:
          afa96346-a53b-2187-d714-77b060d1af47:
            targetId: be71f743-d67c-f681-04df-7ff71079985d
            port: SUCCESS
      get_database_operation_details:
        x: 760
        'y': 160
      get_database_instance:
        x: 80
        'y': 160
      get_database_instance_details:
        x: 1080
        'y': 160
        navigate:
          0e4a2a11-52d5-dd05-605a-5df220d637a4:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      sleep:
        x: 640
        'y': 400
      check_if_instance_is_in_stopped_state:
        x: 280
        'y': 160
      get_access_token_using_web_api:
        x: 80
        'y': 400
      counter:
        x: 880
        'y': 400
        navigate:
          dbd8783f-4c6f-d9ba-0908-4530d50359b2:
            targetId: 969ae540-7184-6ea5-dd13-488958a5715f
            port: NO_MORE
      compare_operation_state:
        x: 880
        'y': 160
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 1320
          'y': 160
        be71f743-d67c-f681-04df-7ff71079985d:
          x: 480
          'y': 400
      FAILURE:
        969ae540-7184-6ea5-dd13-488958a5715f:
          x: 1080
          'y': 400
