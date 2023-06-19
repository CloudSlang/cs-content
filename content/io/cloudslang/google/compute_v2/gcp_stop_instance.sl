#   (c) Copyright 2023 Open Text
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
#! @description: This workflow is used to stop the instance.
#!
#! @input client_id: The client ID for your application.
#! @input client_secret: The client secret for your application.
#! @input refresh_token: Refresh token.
#! @input project_id: Google Cloud project id.
#!                    Example: 'example-project-a'
#! @input scheduler_time_zone: scheduler Time Zone.Optional
#! @input stop_instance_scheduler_id: Stop  Instance scheduler ID.Optional
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
#! @output updated_scheduler_id: Stop Instance scheduler ID.
#! @output updated_stop_instance_scheduler_time: Stop Instance scheduler time.
#!
#! @result FAILURE: There was an error while trying to stop the instance.
#! @result SUCCESS: The instance stopped successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute_v2
flow:
  name: gcp_stop_instance
  inputs:
    - client_id
    - client_secret:
        sensitive: true
    - refresh_token:
        sensitive: true
    - project_id:
        sensitive: true
    - scheduler_time_zone:
        required: false
    - stop_instance_scheduler_id:
        required: false
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
    - check_stop_instance_scheduler_id_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${stop_instance_scheduler_id}'
            - second_string: ''
        navigate:
          - SUCCESS: get_access_token_using_web_api
          - FAILURE: set_tenant
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
    - check_if_instance_is_in_stopped_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status}'
            - second_string: TERMINATED
            - ignore_case: 'true'
        navigate:
          - SUCCESS: set_failure_message_for_instance
          - FAILURE: stop_instance
    - set_failure_message_for_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - instance_name: '${instance_name}'
        publish:
          - output: "${\"Cannot stop the instance \\\"\"+instance_name+\"\\\"  because it's not running or being repaired.\"}"
        navigate:
          - SUCCESS: get_instance_details
          - FAILURE: on_failure
    - sleep:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '${polling_interval}'
        navigate:
          - SUCCESS: get_instance_details
          - FAILURE: on_failure
    - compare_power_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status}'
            - second_string: TERMINATED
            - ignore_case: 'true'
        publish:
          - status: TERMINATED
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: counter
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
          - SUCCESS: check_if_instance_is_in_stopped_state
          - FAILURE: on_failure
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
          - status
        navigate:
          - SUCCESS: compare_power_state
          - FAILURE: on_failure
    - stop_instance:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.google.compute_v2.instances.stop_instance:
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
    - get_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: nextFireTime
        publish:
          - next_run_in_unix_time: '${return_result}'
        navigate:
          - SUCCESS: convert_epoch_time
          - FAILURE: on_failure
    - get_scheduler_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get_sp('io.cloudslang.microfocus.content.oo_rest_uri')+'/scheduler/rest/v1/'+dnd_tenant_id+'/schedules/'+stop_instance_scheduler_id.strip()}"
            - username: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_user')}"
            - password:
                value: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_password')}"
                sensitive: true
            - proxy_host: "${get_sp('io.cloudslang.microfocus.content.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.microfocus.content.proxy_port')}"
            - proxy_username: "${get_sp('io.cloudslang.microfocus.content.proxy_username')}"
            - proxy_password:
                value: "${get_sp('io.cloudslang.microfocus.content.proxy_password')}"
                sensitive: true
            - trust_all_roots: "${get_sp('io.cloudslang.microfocus.content.trust_all_roots')}"
            - x_509_hostname_verifier: "${get_sp('io.cloudslang.microfocus.content.x_509_hostname_verifier')}"
        publish:
          - return_result
          - error_message
        navigate:
          - SUCCESS: get_value
          - FAILURE: on_failure
    - set_tenant:
        worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        do:
          io.cloudslang.base.utils.do_nothing:
            - dnd_rest_user: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_user')}"
            - stop_instance_scheduler_id: '${stop_instance_scheduler_id}'
        publish:
          - dnd_rest_user
          - dnd_tenant_id: '${dnd_rest_user.split("/")[0]}'
          - updated_scheduler_id: '${stop_instance_scheduler_id}'
        navigate:
          - SUCCESS: get_scheduler_details
          - FAILURE: on_failure
    - convert_epoch_time:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.convert_epoch_time:
            - epoch_time: '${next_run_in_unix_time}'
            - time_zone: '${scheduler_time_zone}'
        publish:
          - updated_stop_instance_scheduler_time: '${date_format + ".000" + time_zone.split("UTC")[1].split(")")[0] + time_zone.split(")")[1]}'
        navigate:
          - SUCCESS: get_access_token_using_web_api
          - FAILURE: on_failure
  outputs:
    - external_ips
    - status
    - return_result
    - exception
    - return_code
    - updated_scheduler_id
    - updated_stop_instance_scheduler_time
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_instance_details:
        x: 1040
        'y': 160
      set_tenant:
        x: 240
        'y': 320
      get_value:
        x: 200
        'y': 480
      convert_epoch_time:
        x: 360
        'y': 480
      check_stop_instance_scheduler_id_empty:
        x: 80
        'y': 160
      stop_instance:
        x: 840
        'y': 160
      get_scheduler_details:
        x: 40
        'y': 480
      set_failure_message_for_instance:
        x: 840
        'y': 360
      sleep:
        x: 1040
        'y': 360
      check_if_instance_is_in_stopped_state:
        x: 680
        'y': 160
      get_access_token_using_web_api:
        x: 360
        'y': 160
      counter:
        x: 1280
        'y': 360
        navigate:
          ffa7b1f2-6949-56af-0f21-cf13a29dccf7:
            targetId: d936eeea-5cc9-d7fe-db69-2345f7db4695
            port: NO_MORE
      compare_power_state:
        x: 1280
        'y': 160
        navigate:
          649043f8-1950-152b-2ddf-858591e896eb:
            targetId: e104c40a-d81e-dbcf-ed47-b859689c4260
            port: SUCCESS
      get_instance:
        x: 520
        'y': 160
    results:
      FAILURE:
        d936eeea-5cc9-d7fe-db69-2345f7db4695:
          x: 1440
          'y': 360
      SUCCESS:
        e104c40a-d81e-dbcf-ed47-b859689c4260:
          x: 1440
          'y': 160

