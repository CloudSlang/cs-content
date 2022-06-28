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
#
########################################################################################################################
#!!
#! @description: This workflow deletes the given scheduler.
#!
#! @input scheduler_id: The scheduler id to be deleted.
#! @input start_instance_scheduler_id: Start instance scheduler ID.
#!                                     Optional
#! @input start_instance_scheduler_time: Start instance scheduler time.
#!                                       Optional
#! @input stop_instance_scheduler_id: Stop instance scheduler ID.
#!                                    Optional
#! @input stop_instance_scheduler_time: Stop instance scheduler time.
#!                                      Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#!
#! @output updated_start_instance_scheduler_id: Start instance scheduler ID.
#! @output updated_start_instance_scheduler_time: Start instance scheduler time.
#! @output updated_stop_instance_scheduler_id: Stop instance scheduler ID.
#! @output updated_stop_instance_scheduler_time: Stop instance scheduler time.
#!
#! @result FAILURE: There was an error while trying to run every step of the flow.
#! @result SUCCESS: The flow completed successfully.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings
  flow: io.cloudslang.base.utils
flow:
  name: delete_scheduler_of_aws_user_operation
  inputs:
    - scheduler_id:
        required: true
    - start_instance_scheduler_id:
        required: false
    - start_instance_scheduler_time:
        required: false
    - stop_instance_scheduler_id:
        required: false
    - stop_instance_scheduler_time:
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - get_tenant_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - dnd_rest_user: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_user')}"
            - start_instance_scheduler_id: '${start_instance_scheduler_id}'
            - start_instance_scheduler_id_time: '${start_instance_scheduler_time}'
            - stop_instance_scheduler_id: '${stop_instance_scheduler_id}'
            - stop_instance_scheduler_time: '${stop_instance_scheduler_time}'
            - scheduler_id_in: '${scheduler_id}'
            - action_name: '${scheduler_id}'
        publish:
          - dnd_rest_user
          - dnd_tenant_id: '${dnd_rest_user.split("/")[0]}'
          - updated_start_instance_scheduler_id: '${start_instance_scheduler_id}'
          - updated_start_instance_scheduler_time: '${start_instance_scheduler_id_time}'
          - updated_stop_instance_scheduler_id: '${stop_instance_scheduler_id}'
          - updated_stop_instance_scheduler_time: '${stop_instance_scheduler_time}'
          - scheduler_id: '${scheduler_id_in.split("::")[0]}'
          - action_name: '${scheduler_id_in.split("::")[1]}'
        navigate:
          - SUCCESS: api_call_to_delete_scheduler
          - FAILURE: on_failure
    - api_call_to_delete_scheduler:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_delete:
            - url: "${get_sp('io.cloudslang.microfocus.content.oo_rest_uri')+'/scheduler/rest/v1/'+dnd_tenant_id+'/schedules/'+scheduler_id.strip()}"
            - username: '${dnd_rest_user}'
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
            - trust_keystore: "${get_sp('io.cloudslang.microfocus.content.trust_keystore')}"
            - trust_password:
                value: "${get_sp('io.cloudslang.microfocus.content.trust_password')}"
                sensitive: true
            - socket_timeout: "${get_sp('io.cloudslang.microfocus.content.socket_timeout')}"
        publish:
          - return_result_delete_scheduler: '${return_result}'
          - error_message
        navigate:
          - SUCCESS: check_action_name_start_instance
          - FAILURE: delete_scheduler_failure_message
    - set_scheduler_id_and_time:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - start_instance_scheduler_id: ''
            - start_instance_scheduler_time: ''
        publish:
          - updated_start_instance_scheduler_id: '${start_instance_scheduler_id}'
          - updated_start_instance_scheduler_time: '${start_instance_scheduler_time}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - delete_scheduler_failure_message:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - delete_scheduler_failure_message: '${return_result_delete_scheduler}'
        publish:
          - return_result: '${delete_scheduler_failure_message}'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
    - check_action_name_start_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${action_name}'
            - second_string: AWS Start Instance
        navigate:
          - SUCCESS: set_scheduler_id_and_time
          - FAILURE: check_action_name_stop_instance
    - check_action_name_stop_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${action_name}'
            - second_string: AWS Stop Instance
        navigate:
          - SUCCESS: set_scheduler_id_and_time_empty
          - FAILURE: on_failure
    - set_scheduler_id_and_time_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - stop_instance_scheduler_id: ''
            - stop_instance_scheduler_time: ''
        publish:
          - updated_stop_instance_scheduler_id: '${stop_instance_scheduler_id}'
          - updated_stop_instance_scheduler_time: '${stop_instance_scheduler_time}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - updated_start_instance_scheduler_id
    - updated_start_instance_scheduler_time
    - updated_stop_instance_scheduler_id
    - updated_stop_instance_scheduler_time
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_tenant_id:
        x: 40
        'y': 80
      api_call_to_delete_scheduler:
        x: 240
        'y': 80
      set_scheduler_id_and_time:
        x: 640
        'y': 80
        navigate:
          99783dd6-ce92-c061-c3d9-4302cabf3e82:
            targetId: 8e73a0ae-cb72-504f-2288-a2fc2056a679
            port: SUCCESS
      delete_scheduler_failure_message:
        x: 240
        'y': 320
        navigate:
          f9214639-8c11-37b9-3f07-c3e0ae93b175:
            targetId: 5d212021-cc45-bbd6-1aa1-a96ba466651c
            port: SUCCESS
      set_scheduler_id_and_time_empty:
        x: 640
        'y': 320
        navigate:
          e9194770-6158-cbbe-2dbc-188b0223f6c0:
            targetId: 8e73a0ae-cb72-504f-2288-a2fc2056a679
            port: SUCCESS
      check_action_name_start_instance:
        x: 440
        'y': 80
      check_action_name_stop_instance:
        x: 440
        'y': 320
    results:
      FAILURE:
        5d212021-cc45-bbd6-1aa1-a96ba466651c:
          x: 40
          'y': 320
      SUCCESS:
        8e73a0ae-cb72-504f-2288-a2fc2056a679:
          x: 800
          'y': 200

