#   (c) Copyright 2014-2017 EntIT Software LLC, a Micro Focus company, L.P.
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
namespace: io.cloudslang.base.utils

imports:
  utils: io.cloudslang.base.utils
  strings: io.cloudslang.base.strings

flow:
  name: test_uuid_generator

  inputs:
    - version:
        required: false

  workflow:
    - execute_uuid_generator:
        do:
          utils.uuid_generator:
            - version
        publish:
          - new_uuid
        navigate:
          - SUCCESS: verify_output_is_not_empty
          - FAILURE: FAILURE

    - verify_output_is_not_empty:
        do:
          utils.uuid_generator:
            - version: "1"
        publish:
          - new_uuid
        navigate:
          - SUCCESS: verify_version_is_1
          - FAILURE: FAILURE


    - verify_version_is_1:
        do:
          utils.uuid_generator:
            - version: "3"
            - name: "test"
        publish:
          - new_uuid
        navigate:
          - SUCCESS: verify_version_is_3
          - FAILURE: FAILURE

    - verify_version_is_3:
        do:
          utils.uuid_generator:
            - version: "4"
        publish:
          - new_uuid
        navigate:
          - SUCCESS: verify_version_is_4
          - FAILURE: FAILURE

    - verify_version_is_4:
        do:
          utils.uuid_generator:
            - version: "5"
            - name: "test"
        publish:
          - new_uuid
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  results:
    - SUCCESS
    - FAILURE