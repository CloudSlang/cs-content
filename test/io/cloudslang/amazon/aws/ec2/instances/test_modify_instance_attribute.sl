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
####################################################

namespace: io.cloudslang.amazon.aws.ec2.instances

imports:
  instances: io.cloudslang.amazon.aws.ec2.instances
  lists: io.cloudslang.base.lists

flow:
  name: test_modify_instance_attribute

  inputs:
    - endpoint: 'https://ec2.amazonaws.com'
    - identity:
        default: ''
        required: false
    - credential:
        default: ''
        required: false
    - proxy_host:
        default: ''
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - version:
        default: '2016-09-15'
        required: false
    - instance_id

  workflow:
    - modify_instance_attribute:
        do:
          instances.modify_instance_attribute:
            - endpoint
            - identity
            - credential
            - proxy_host
            - proxy_port
            - version
            - instance_id
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_results
          - FAILURE: UPDATE_SERVER_TYPE_FAILURE

    - check_results:
        do:
          lists.compare_lists:
            - list_1: ${return_code}
            - list_2: "0"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESULTS_FAILURE

  results:
    - SUCCESS
    - UPDATE_SERVER_TYPE_FAILURE
    - CHECK_RESULTS_FAILURE
