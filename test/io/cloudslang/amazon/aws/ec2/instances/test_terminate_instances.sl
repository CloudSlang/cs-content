#   (c) Copyright 2017 EntIT Software LLC, a Micro Focus company, L.P.
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
####################################################

namespace: io.cloudslang.amazon.aws.ec2.instances

imports:
  instances: io.cloudslang.amazon.aws.ec2.instances
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings

flow:
  name: test_terminate_instances

  inputs:
    - provider: 'amazon'
    - endpoint: 'https://ec2.amazonaws.com'
    - identity:
        required: false
    - credential:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - debug_mode:
        default: 'false'
        required: false
    - region:
        default: 'us-east-1'
        required: false
    - instance_id

  workflow:
    - terminate_instances:
        do:
          instances.terminate_instances:
            - provider
            - endpoint
            - identity
            - credential
            - proxy_host
            - proxy_port
            - debug_mode
            - region
            - instance_ids_string: ${instance_id}
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_call_result
          - FAILURE: TERMINATE_SERVER_CALL_FAILURE

    - check_call_result:
        do:
          lists.compare_lists:
            - list_1: ${str(exception) + "," + return_code}
            - list_2: ",0"
        navigate:
          - SUCCESS: check_first_possible_current_state_result
          - FAILURE: CHECK_CALL_RESULT_FAILURE

    - check_first_possible_current_state_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${return_result}
            - string_to_find: 'currentState=terminated'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: check_second_possible_current_state_result

    - check_second_possible_current_state_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${return_result}
            - string_to_find: 'currentState=shutting-down'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: SHUTTING_DOWN_FAILURE

  results:
    - SUCCESS
    - TERMINATE_SERVER_CALL_FAILURE
    - CHECK_CALL_RESULT_FAILURE
    - SHUTTING_DOWN_FAILURE
