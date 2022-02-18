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

namespace: io.cloudslang.amazon.aws.ec2.instances

imports:
  instances: io.cloudslang.amazon.aws.ec2.instances
  lists: io.cloudslang.base.lists

flow:
  name: test_describe_instances

  inputs:
    - endpoint: 'https://ec2.amazonaws.com'
    - identity
    - credential
    - proxy_host:
        default: ''
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        default: ''
        required: false
    - proxy_password:
        default: ''
        required: false
        sensitive: true
    - headers:
        default: ''
        required: false
    - query_params:
        default: ''
        required: false
    - version:
        default: '2016-09-15'
        required: false
    - delimiter:
        default: ','
        required: false
    - filter_names_string:
        default: ''
        required: false
    - filter_values_string:
        default: ''
        required: false
    - instance_ids_string:
        default: ''
        required: false
    - max_results:
        default: ''
        required: false
    - next_token:
        default: ''
        required: false

  workflow:
    - describe_instances:
        do:
          instances.describe_instances:
            - endpoint
            - identity
            - credential
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - headers
            - query_params
            - version
            - delimiter
            - filter_names_string
            - filter_values_string
            - instance_ids_string
            - max_results
            - next_token
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_result
          - FAILURE: LIST_SERVERS_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${str(exception) + "," + return_code}
            - list_2: ",0"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESULT_FAILURE

  results:
    - SUCCESS
    - LIST_SERVERS_FAILURE
    - CHECK_RESULT_FAILURE
