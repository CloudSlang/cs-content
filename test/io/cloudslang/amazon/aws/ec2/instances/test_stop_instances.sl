#   (c) Copyright 2015-2017 EntIT Software LLC, a Micro Focus company, L.P.
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
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.instances

imports:
  instances: io.cloudslang.amazon.aws.ec2.instances
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils

flow:
  name: test_stop_instances
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
    - delimiter:
        required: false
    - debug_mode:
        default: 'false'
        required: false
    - region:
        default: 'us-east-1'
        required: false
    - instance_id
    - seconds:
        default: '45'
        required: false

  workflow:
    - stop_instances:
        do:
          instances.stop_instances:
            - provider
            - endpoint
            - identity
            - credential
            - proxy_host
            - proxy_port
            - debug_mode
            - region
            - instance_ids_string: ${instance_id}
            - force_stop
        navigate:
          - SUCCESS: sleep
          - FAILURE: STOP_FAILURE

    - sleep:
        do:
          utils.sleep:
            - seconds
        navigate:
          - SUCCESS: describe_instances
          - FAILURE: STOPPED_FAILURE

    - describe_instances:
        do:
          instances.describe_instances:
            - provider
            - endpoint
            - identity
            - credential
            - proxy_host
            - proxy_port
            - region
            - delimiter
        navigate:
          - SUCCESS: check_result
          - FAILURE: LIST_FAILURE
        publish:
          - return_result
          - return_code
          - exception

    - check_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${return_result}
            - string_to_find: ${server_id + ', state=stopped'}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: STOPPED_FAILURE

  results:
    - SUCCESS
    - STOP_FAILURE
    - LIST_FAILURE
    - STOPPED_FAILURE
