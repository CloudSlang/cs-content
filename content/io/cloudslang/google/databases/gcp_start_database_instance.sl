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
#! @description: This workflow is used to start the database instance.
#!
#! @input client_id: The client ID for your application.
#! @input client_secret: The client secret for your application.
#! @input refresh_token: Refresh token.
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input instance_name: Name of the database Instance
#! @input polling_interval: The number of seconds to wait until performing another check.Default: '20'Optional
#! @input polling_retries: The number of retries to check if the instance is started.Default: '30'Optional
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
#! @output instance_state: The current serving state of the Cloud SQL instance.
#! @output public_ip_address: The public ip address of the instance.
#! @output private_ip_address: The private ip address of the instance.
#!
#! @result SUCCESS: The database instance has been successfully started.
#! @result FAILURE: There was an error while trying to start the instance.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.databases
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: gcp_start_database_instance
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
        navigate:
          - SUCCESS: compare_power_state
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
          - SUCCESS: check_if_instance_is_in_running_state
          - FAILURE: on_failure
    - check_if_instance_is_in_running_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${instance_state}'
            - second_string: RUNNING
            - ignore_case: 'true'
        publish: []
        navigate:
          - SUCCESS: set_message
          - FAILURE: start_database_instance
    - set_message:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - instance_name: '${instance_name}'
        publish:
          - return_result: "${\"SQL instance \\\"\"+instance_name+\"\\\"  is already in running state, it cannot be started.\"}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - compare_power_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${instance_state}'
            - second_string: RUNNING
            - ignore_case: 'true'
        publish: []
        navigate:
          - SUCCESS: SUCCESS
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
          - SUCCESS: get_database_instance_details
          - FAILURE: on_failure
    - start_database_instance:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.google.databases.instances.start_database_instance:
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
          - SUCCESS: get_database_instance_details
          - FAILURE: on_failure
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
      set_message:
        x: 280
        'y': 400
        navigate:
          afa96346-a53b-2187-d714-77b060d1af47:
            targetId: be71f743-d67c-f681-04df-7ff71079985d
            port: SUCCESS
      check_if_instance_is_in_running_state:
        x: 280
        'y': 160
      get_database_instance:
        x: 80
        'y': 160
      get_database_instance_details:
        x: 680
        'y': 160
      sleep:
        x: 680
        'y': 400
      start_database_instance:
        x: 480
        'y': 160
      get_access_token_using_web_api:
        x: 80
        'y': 400
      counter:
        x: 880
        'y': 400
        navigate:
          2b6c0394-dfc4-3631-f796-c783f895153e:
            targetId: 969ae540-7184-6ea5-dd13-488958a5715f
            port: NO_MORE
      compare_power_state:
        x: 880
        'y': 160
        navigate:
          8da2eab9-23bb-179a-3d04-d25fa2da1db3:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 1120
          'y': 160
        be71f743-d67c-f681-04df-7ff71079985d:
          x: 480
          'y': 400
      FAILURE:
        969ae540-7184-6ea5-dd13-488958a5715f:
          x: 1120
          'y': 400

