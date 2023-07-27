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
#! @description: This workflow is used to reset the instance.
#!
#! @input client_id: The client ID for your application.
#! @input client_secret: The client secret for your application.
#! @input refresh_token: Refresh token.
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
#! @output external_ips: The external IP's of the instance.
#! @output status: The current state of the instance.
#! @output return_result: contains the exception in case of failure, success message otherwise.
#! @output exception: exception if there was an error when executing, empty otherwise.
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#!
#! @result FAILURE: There was an error while trying to reset the instance.
#! @result SUCCESS: The instance reset successful.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute_v2
flow:
  name: gcp_reset_instance
  inputs:
    - client_id
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
          - FAILURE: on_failure
    - check_if_instance_is_in_running_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status}'
            - second_string: RUNNING
            - ignore_case: 'true'
        navigate:
          - SUCCESS: reset_instance
          - FAILURE: set_failure_message_for_instance
    - set_failure_message_for_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - instance_name: '${instance_name}'
        publish:
          - output: "${\"Cannot reset the instance \\\"\"+instance_name+\"\\\"  because it's not in running state.\"}"
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
          - instance_json
        navigate:
          - SUCCESS: check_if_instance_is_in_running_state
          - FAILURE: on_failure
    - reset_instance:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.google.compute_v2.instances.reset_instance:
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
          - SUCCESS: get_instance_details
          - FAILURE: set_failure_message_for_reset_instance
    - get_instance_details:
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
          - external_ips
          - instance_json
          - status
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
          - SUCCESS: set_success_message_for_instance
          - FAILURE: counter
    - sleep:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '${polling_interval}'
        navigate:
          - SUCCESS: get_instance_details
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
          - HAS_MORE: sleep
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - set_success_message_for_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - instance_name: '${instance_name}'
        publish:
          - return_result: "${\"Instance \\\"\"+instance_name+\"\\\" has been successfully reset.\"}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - set_failure_message_for_reset_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - instance_name: '${instance_name}'
        publish:
          - output: "${\"Instance \\\"\"+instance_name+\"\\\" has  failed to reset.\"}"
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
  outputs:
    - external_ips
    - status
    - return_result
    - exception
    - return_code
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_instance_details:
        x: 840
        'y': 80
      reset_instance:
        x: 640
        'y': 80
      set_failure_message_for_reset_instance:
        x: 640
        'y': 280
        navigate:
          98712e59-fb3e-25cd-e637-ad2a05643905:
            targetId: 9eddf307-ecb2-a1bc-1574-8e7e560bdef1
            port: SUCCESS
      check_if_instance_is_in_running_state:
        x: 440
        'y': 80
      set_failure_message_for_instance:
        x: 440
        'y': 280
        navigate:
          b36844ff-baf3-9186-0275-f42c0e1eeeaa:
            targetId: f610fb9f-08b4-2adc-e2c7-9439f62d77cb
            port: SUCCESS
      sleep:
        x: 840
        'y': 320
      get_access_token_using_web_api:
        x: 40
        'y': 80
      set_success_message_for_instance:
        x: 1200
        'y': 80
        navigate:
          b2fd2ce2-5f67-c655-f143-b99d60aaf63c:
            targetId: e104c40a-d81e-dbcf-ed47-b859689c4260
            port: SUCCESS
      counter:
        x: 1040
        'y': 320
        navigate:
          06792458-cc95-a97b-8d2d-87084dae066a:
            targetId: 88ef1e27-5525-3146-7084-8e31c7c14d57
            port: NO_MORE
      compare_power_state:
        x: 1040
        'y': 80
      get_instance:
        x: 200
        'y': 80
    results:
      FAILURE:
        f610fb9f-08b4-2adc-e2c7-9439f62d77cb:
          x: 440
          'y': 480
        88ef1e27-5525-3146-7084-8e31c7c14d57:
          x: 1240
          'y': 320
        9eddf307-ecb2-a1bc-1574-8e7e560bdef1:
          x: 640
          'y': 480
      SUCCESS:
        e104c40a-d81e-dbcf-ed47-b859689c4260:
          x: 1400
          'y': 80

