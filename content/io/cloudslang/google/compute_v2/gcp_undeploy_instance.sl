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
#########################################################################################################################
#!!
#! @description: This workflow is used to Undeploy an instance in Google cloud.
#!
#! @input client_id: The client ID for your application.
#! @input client_secret: The client secret for your application.
#! @input refresh_token: The refresh token of the client.
#! @input project_id: Google Cloud project id.
#!                    Example: 'example-project-a'
#! @input zone: The name of the zone where the disk is located.
#!              Examples: 'us-central1-a, us-central1-b, us-central1-c'
#! @input instance_name: The name of the instance.
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Default: '20'
#!                          Optional
#! @input polling_retries: The number of retries to check if the instance is started.
#!                         Default: '30'
#!                         Optional
#! @input proxy_host: The proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: The proxy server port.
#!                    Optional
#! @input proxy_username: The proxy server username.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#!                                 Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#!
#! @output status: The current state of the instance.
#! @output return_result: contains the exception in case of failure, success message otherwise.
#! @output exception: exception if there was an error when executing, empty otherwise.
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#!
#! @result FAILURE: There was an error while trying to undeploy instance.
#! @result SUCCESS: Undeploy instance completed  successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute_v2
flow:
  name: gcp_undeploy_instance
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
    - polling_interval:
        default: '20'
        required: false
    - polling_retries:
        default: '30'
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
          - SUCCESS: get_instance
          - FAILURE: set_failure_message_for_authentication
    - get_instance:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          gcp.checkin.get_instance:
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
          - instance_json
          - status_code: status_code
        navigate:
          - SUCCESS: delete_instance
          - FAILURE: set_failure_message_for_to_get_instance
    - delete_instance:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.google.compute_v2.instances.delete_instance:
            - project_id:
                value: '${project_id}'
                sensitive: true
            - access_token:
                value: '${access_token}'
                sensitive: true
            - zone: '${zone}'
            - instance_name: '${instance_name}'
            - worker_group: '${worker_group}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${trust_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - instance_json
          - status_code
        navigate:
          - SUCCESS: get_instance_details
          - FAILURE: set_failure_message_for_instance
    - get_instance_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          gcp.checkin.get_instance:
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
          - instance_json
          - status_code
        navigate:
          - SUCCESS: compare_power_state
          - FAILURE: is_status_code
    - set_failure_message_for_authentication:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing: []
        publish:
          - return_result: Unable to authenticate.
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
    - compare_power_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status}'
            - second_string: STOPPING
            - ignore_case: 'true'
        publish:
          - status: STOPPING
        navigate:
          - SUCCESS: counter
          - FAILURE: on_failure
    - wait_before_check:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '${polling_interval}'
        navigate:
          - SUCCESS: get_instance_details
          - FAILURE: on_failure
    - is_status_code:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '404'
            - ignore_case: 'false'
        navigate:
          - SUCCESS: set_success_message_for_instance
          - FAILURE: on_failure
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
    - counter:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.counter:
            - from: '1'
            - to: '${polling_retries}'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: wait_before_check
          - NO_MORE: FAILURE
          - FAILURE: on_failure
  outputs:
    - status
    - return_result
    - exception
    - return_code
    - status_code
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_instance_details:
        x: 640
        'y': 80
      set_failure_message_for_to_get_instance:
        x: 200
        'y': 280
        navigate:
          572f3742-25f6-1645-41e9-057db372476c:
            targetId: 2a8e1762-d81b-3723-74a1-9f4a27bc2ab0
            port: SUCCESS
      is_status_code:
        x: 880
        'y': 80
      delete_instance:
        x: 360
        'y': 80
      wait_before_check:
        x: 520
        'y': 360
      set_failure_message_for_instance:
        x: 360
        'y': 280
        navigate:
          24f7c555-c602-4eaa-68f0-d5d3c19e123b:
            targetId: 2a8e1762-d81b-3723-74a1-9f4a27bc2ab0
            port: SUCCESS
      set_failure_message_for_authentication:
        x: 40
        'y': 280
        navigate:
          bc99f64f-3930-7585-0f95-b7bf3730d781:
            targetId: 2a8e1762-d81b-3723-74a1-9f4a27bc2ab0
            port: SUCCESS
      get_access_token_using_web_api:
        x: 40
        'y': 80
      set_success_message_for_instance:
        x: 1080
        'y': 80
        navigate:
          1dd3cb8e-5adb-9da3-bc9c-4e1a101e8e2c:
            targetId: 3754bc18-f158-2264-152a-0148a17c1171
            port: SUCCESS
      counter:
        x: 760
        'y': 360
        navigate:
          0eab0170-33cb-3e37-881b-1a419b651d86:
            targetId: f8501923-9451-6871-f819-a386c8a10e05
            port: NO_MORE
      compare_power_state:
        x: 920
        'y': 240
      get_instance:
        x: 200
        'y': 80
    results:
      FAILURE:
        2a8e1762-d81b-3723-74a1-9f4a27bc2ab0:
          x: 200
          'y': 480
        f8501923-9451-6871-f819-a386c8a10e05:
          x: 1000
          'y': 360
      SUCCESS:
        3754bc18-f158-2264-152a-0148a17c1171:
          x: 1080
          'y': 320

