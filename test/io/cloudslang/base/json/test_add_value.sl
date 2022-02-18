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
namespace: io.cloudslang.base.json

imports:
  json: io.cloudslang.base.json

flow:
  name: test_add_value

  inputs:
    - json_before
    - json_path
    - value:
        required: false
    - json_after

  workflow:
    - add_value:
        do:
          json.add_value:
            - json_input: ${ json_before }
            - json_path
            - value
        publish:
          - json_output: ${return_result}
        navigate:
          - SUCCESS: test_equality
          - FAILURE: CREATEFAILURE
    - test_equality:
        do:
          json.equals:
            - json_input1: ${ json_output }
            - json_input2: ${ json_after }

        navigate:
          - EQUALS: SUCCESS
          - NOT_EQUALS: EQUALITY_FAILURE
          - FAILURE: FAILURE

  results:
    - SUCCESS
    - FAILURE
    - EQUALITY_FAILURE
    - CREATEFAILURE
