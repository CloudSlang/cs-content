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
#! @description: This workflow creates scheduler for "aws start instance" and "aws stop instance" operations.
#!
#! @input schedule_time: Schedule time of the start instance.
#!                       Optional
#! @input schedule_time_zone: Schedule time zone of the start instance.
#!                            Optional
#! @input component_id: The service component ID.
#!                      Optional
#! @input service_instance_id: The service instance ID.Optional
#! @input action_name: The name of the user operation
#! @input start_instance_scheduler_id: Start instance scheduler ID.
#!                                     Optional
#! @input start_instance_scheduler_time: Start instance scheduler time.
#!                                       Optional
#! @input stop_instance_scheduler_id: Stop instance scheduler ID.
#!                                    Optional
#! @input stop_instance_scheduler_time: Stop instance scheduler time.
#!                                      Optional
#! @input on_behalf_of_user: The user login name on behalf of whom request is submitted.
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#!
#! @output updated_start_instance_scheduler_id: Start instance scheduler ID.
#! @output updated_start_instance_scheduler_time: Start instance scheduler time.
#! @output updated_stop_instance_scheduler_id: Updated stop instance scheduler id
#! @output updated_stop_instance_scheduler_time: Updated stop instance scheduler time.
#! @output scheduler_time_zone: The scheduler time zone.
#!
#! @result SUCCESS: The flow completed successfully.
#! @result FAILURE: The flow failed with some error
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings
  flow: io.cloudslang.base.utils
flow:
  name: create_scheduler_for_aws_user_operation
  inputs:
    - schedule_time:
        required: true
    - schedule_time_zone:
        required: true
    - component_id:
        required: true
    - service_instance_id
    - action_name
    - start_instance_scheduler_id:
        required: false
    - start_instance_scheduler_time:
        required: false
    - stop_instance_scheduler_id:
        required: false
    - stop_instance_scheduler_time:
        required: false
    - on_behalf_of_user:
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
        publish:
          - dnd_rest_user
          - dnd_tenant_id: '${dnd_rest_user.split("/")[0]}'
          - updated_stop_instance_scheduler_id: '${stop_instance_scheduler_id}'
          - updated_stop_instance_scheduler_time: '${stop_instance_scheduler_time}'
          - updated_start_instance_scheduler_id: '${start_instance_scheduler_id}'
          - updated_start_instance_scheduler_time: '${start_instance_scheduler_id_time}'
          - on_behalf_of_user: '${dnd_rest_user.split("/")[1]}'
        navigate:
          - SUCCESS: get_user_identifier
          - FAILURE: on_failure
    - scheduler_time:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.utils.schedule_time:
            - scheduler_time: '${schedule_time}'
            - scheduler_time_zone: '${schedule_time_zone}'
        publish:
          - scheduler_start_time
          - trigger_expression
          - time_zone
          - exception
          - scheduler_time_zone
        navigate:
          - SUCCESS: check_action_name_start_instance
          - FAILURE: on_failure
    - get_scheduler_id_of_start_instance_scheduler:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - input1: '${response_headers.split("Location: /schedules/")[1]}'
            - scheduler_start_time: '${scheduler_start_time}'
            - time_zone: '${time_zone}'
        publish:
          - updated_start_instance_scheduler_id: '${input1.split("X-Content-Type-Options:")[0]}'
          - updated_start_instance_scheduler_time: "${scheduler_start_time + ' ' + time_zone}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - api_call_to_create_scheduler:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get_sp('io.cloudslang.microfocus.content.oo_rest_uri')+'/scheduler/rest/v1/'+dnd_tenant_id+'/schedules'}"
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
            - connect_timeout: "${get_sp('io.cloudslang.microfocus.content.connect_timeout')}"
            - socket_timeout: "${get_sp('io.cloudslang.microfocus.content.socket_timeout')}"
            - body: '${scheduler_json_body}'
            - content_type: application/json
            - worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        publish:
          - response_headers
          - status_code
          - error_message
        navigate:
          - SUCCESS: check_action_name_aws_start_instance
          - FAILURE: on_failure
    - check_action_name_start_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${action_name}'
            - second_string: AWS Start Instance
            - ignore_case: 'true'
        navigate:
          - SUCCESS: check_aws_start_instance_scheduler_already_present
          - FAILURE: check_action_name_stop_instance
    - start_instance_json_body:
        do:
          io.cloudslang.base.utils.do_nothing:
            - start_instance_json_body: "${'{ \"flowIdentifier\": \"io.cloudslang.amazon.aws.ec2.utils.aws_user_operation_callback\",\"scheduleName\": \"Execute AWS Start Instance - \"+\"'+aws_instance_id+'\",\"triggerExpression\":\"' + trigger_expression + '\",\"timezone\":\"' + time_zone + '\",\"startDate\":\"' + scheduler_start_time + '\",\"enabled\": true,\"misfireInstruction\": 0,\"useEmptyValueForPrompts\": true,\"exclusions\": {\"dateTimeExclusionList\": null,\"dateExclusionList\": null,\"timeExclusionList\": null},\"runLogLevel\": \"STANDARD\", \"inputs\": [{\"name\": \"component_id\", \"value\": \"' + component_id + '\", \"sensitive\": false},{\"name\": \"service_instance_id\",\"value\": \"'+service_instance_id +'\",\"sensitive\": false},{\"name\": \"on_behalf_of_user\",\"value\": \"'+on_behalf_of_user +'\",\"sensitive\": false},{\"name\": \"action_name\",\"value\": \"'+action_name +'\",\"sensitive\": false},{\"name\": \"worker_group\",\"value\": \"' + worker_group + '\",\"sensitive\": false}],\"licenseType\": 0}'}"
        publish:
          - scheduler_json_body: '${start_instance_json_body}'
        navigate:
          - SUCCESS: api_call_to_create_scheduler
          - FAILURE: on_failure
    - check_action_name_stop_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${action_name}'
            - second_string: AWS Stop Instance
            - ignore_case: 'true'
        navigate:
          - SUCCESS: check_stop_instance_scheduler_is_present
          - FAILURE: on_failure
    - stop_instance_json_body:
        do:
          io.cloudslang.base.utils.do_nothing:
            - aws_stop_instance_json_body: "${'{\"flowIdentifier\": \"io.cloudslang.amazon.aws.ec2.utils.aws_user_operation_callback\",\"scheduleName\": \"Execute AWS Stop Instance - \"+\"'+aws_instance_id+'\",\"triggerExpression\":\"' + trigger_expression + '\",\"timezone\":\"' + time_zone + '\",\"startDate\":\"' + scheduler_start_time + '\",\"enabled\": true,\"misfireInstruction\": 0,\"useEmptyValueForPrompts\": true,\"exclusions\": {\"dateTimeExclusionList\": null,\"dateExclusionList\": null,\"timeExclusionList\": null},\"runLogLevel\": \"STANDARD\", \"inputs\": [{\"name\": \"component_id\", \"value\": \"' + component_id + '\", \"sensitive\": false},{\"name\": \"service_instance_id\",\"value\": \"'+service_instance_id +'\",\"sensitive\": false},{\"name\": \"on_behalf_of_user\",\"value\": \"'+on_behalf_of_user +'\",\"sensitive\": false},{\"name\": \"action_name\",\"value\": \"'+action_name +'\",\"sensitive\": false},{\"name\": \"worker_group\",\"value\": \"' + worker_group + '\",\"sensitive\": false}],\"licenseType\": 0}'}"
        publish:
          - scheduler_json_body: '${aws_stop_instance_json_body}'
        navigate:
          - SUCCESS: api_call_to_create_scheduler
          - FAILURE: on_failure
    - check_action_name_aws_start_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${action_name}'
            - second_string: AWS Start Instance
        navigate:
          - SUCCESS: get_scheduler_id_of_start_instance_scheduler
          - FAILURE: check_action_name_stop_instance_operation
    - check_action_name_stop_instance_operation:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${action_name}'
            - second_string: AWS Stop Instance
        navigate:
          - SUCCESS: get_scheduler_id_of_stop_instance_scheduler
          - FAILURE: on_failure
    - get_scheduler_id_of_stop_instance_scheduler:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - input1: '${response_headers.split("Location: /schedules/")[1]}'
            - scheduler_start_time: '${scheduler_start_time}'
            - time_zone: '${time_zone}'
        publish:
          - updated_stop_instance_scheduler_id: '${input1.split("X-Content-Type-Options:")[0]}'
          - updated_stop_instance_scheduler_time: "${scheduler_start_time + ' ' + time_zone}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - check_aws_start_instance_scheduler_already_present:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${start_instance_scheduler_id}'
        navigate:
          - SUCCESS: start_instance_json_body
          - FAILURE: failure_message_start_instance_scheduler_already_present
    - check_stop_instance_scheduler_is_present:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${stop_instance_scheduler_id}'
        navigate:
          - SUCCESS: stop_instance_json_body
          - FAILURE: failure_message_stop_instance_scheduler_already_present
    - failure_message_start_instance_scheduler_already_present:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - text: aws_start_instance_v3 operation.
            - origin_string: 'Already scheduler is present for '
        publish:
          - error_message: '${new_string}'
        navigate:
          - SUCCESS: FAILURE
    - failure_message_stop_instance_scheduler_already_present:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - text: aws_stop_instance_v3 operation.
            - origin_string: 'Already scheduler is present for '
        publish:
          - error_message: '${new_string}'
        navigate:
          - SUCCESS: FAILURE
    - check_on_behalf_of_user_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${on_behalf_of_user}'
        navigate:
          - SUCCESS: set_default_on_behalf_of_user
          - FAILURE: set_given_on_behalf_of_user
    - set_given_on_behalf_of_user:
        do:
          io.cloudslang.base.utils.do_nothing:
            - on_behalf_of_user: '${on_behalf_of_user}'
        publish:
          - on_behalf_of_user
        navigate:
          - SUCCESS: scheduler_time
          - FAILURE: on_failure
    - set_default_on_behalf_of_user:
        do:
          io.cloudslang.base.utils.do_nothing:
            - dnd_rest_user: '${dnd_rest_user}'
        publish:
          - on_behalf_of_user: '${dnd_rest_user.split("/")[1]}'
        navigate:
          - SUCCESS: scheduler_time
          - FAILURE: on_failure
    - get_user_identifier:
        do:
          io.cloudslang.microfocus.content.get_user_identifier: []
        publish:
          - user_identifier: '${id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_artifact_properties
    - get_artifact_properties:
        do:
          io.cloudslang.microfocus.content.get_artifact_properties:
            - user_identifier: '${user_identifier}'
            - artifact_id: '${component_id}'
            - property_names: cloud_instance_id
        publish:
          - aws_instance_id: '${property_value_list.split(";")[1]}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: check_on_behalf_of_user_empty
  outputs:
    - updated_start_instance_scheduler_id
    - updated_start_instance_scheduler_time
    - updated_stop_instance_scheduler_id
    - updated_stop_instance_scheduler_time
    - scheduler_time_zone
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      api_call_to_create_scheduler:
        x: 1000
        'y': 320
      check_on_behalf_of_user_empty:
        x: 40
        'y': 640
      get_tenant_id:
        x: 40
        'y': 120
      set_given_on_behalf_of_user:
        x: 200
        'y': 600
        navigate:
          13b09adc-c7f4-6842-a335-c15251724c0e:
            vertices:
              - x: 360
                'y': 360
            targetId: scheduler_time
            port: SUCCESS
      start_instance_json_body:
        x: 840
        'y': 120
      stop_instance_json_body:
        x: 840
        'y': 600
      check_stop_instance_scheduler_is_present:
        x: 400
        'y': 600
      set_default_on_behalf_of_user:
        x: 200
        'y': 360
      failure_message_start_instance_scheduler_already_present:
        x: 600
        'y': 320
        navigate:
          9725f4b6-0fbe-4ef5-a2bc-dbfdd2efb11c:
            targetId: c888ea14-3778-b642-bb37-c8006a95007a
            port: SUCCESS
      check_action_name_stop_instance:
        x: 400
        'y': 320
      scheduler_time:
        x: 200
        'y': 120
      check_action_name_start_instance:
        x: 400
        'y': 120
      get_user_identifier:
        x: 40
        'y': 320
      failure_message_stop_instance_scheduler_already_present:
        x: 600
        'y': 520
        navigate:
          42198ae2-f312-5f3c-bc90-8eee24e40a2f:
            targetId: c888ea14-3778-b642-bb37-c8006a95007a
            port: SUCCESS
      check_action_name_aws_start_instance:
        x: 1160
        'y': 120
      get_artifact_properties:
        x: 40
        'y': 480
      check_action_name_stop_instance_operation:
        x: 1160
        'y': 480
      check_aws_start_instance_scheduler_already_present:
        x: 600
        'y': 120
      get_scheduler_id_of_stop_instance_scheduler:
        x: 1360
        'y': 480
        navigate:
          c5ddfd1b-903f-1d78-891f-db34141eb072:
            targetId: 49f71b73-1825-42e1-f00c-2b1e4388e4f9
            port: SUCCESS
      get_scheduler_id_of_start_instance_scheduler:
        x: 1360
        'y': 120
        navigate:
          d6486dc7-558f-b4fc-b737-22095f6070a4:
            targetId: 49f71b73-1825-42e1-f00c-2b1e4388e4f9
            port: SUCCESS
    results:
      SUCCESS:
        49f71b73-1825-42e1-f00c-2b1e4388e4f9:
          x: 1360
          'y': 320
      FAILURE:
        c888ea14-3778-b642-bb37-c8006a95007a:
          x: 840
          'y': 320
