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

namespace: io.cloudslang.marathon

imports:
  marathon: io.cloudslang.marathon

flow:
  name: test_update_app

  inputs:
    - marathon_host
    - username
    - private_key_file
    - marathon_port:
        required: false
    - json_file_for_creation
    - json_file_for_update
    - created_app_id
    - is_core_os
  workflow:
    - setup_marathon_on_different_hosts:
        do:
          marathon.setup_marathon_on_different_hosts:
            - marathon_host
            - username
            - private_key_file
            - marathon_port
            - is_core_os
        navigate:
          - SUCCESS: create_marathon_app
          - SETUP_MARATHON_PROBLEM: SETUP_MARATHON_PROBLEM
          - WAIT_FOR_MARATHON_STARTUP_TIMED_OUT: WAIT_FOR_MARATHON_STARTUP_TIMED_OUT

    - create_marathon_app:
        do:
          marathon.create_app:
            - marathon_host
            - marathon_port
            - json_file: ${json_file_for_creation}
        navigate:
          - SUCCESS: wait_for_marathon_app_startup
          - FAILURE: FAIL_TO_CREATE

    - wait_for_marathon_app_startup:
        do:
          marathon.wait_for_marathon_app_startup:
            - marathon_host
            - marathon_port
            - created_app_id
            - attempts: '30'
            - time_to_sleep: '10'
        navigate:
          - SUCCESS: update_marathon_app
          - FAILURE: WAIT_FOR_MARATHON_APP_STARTUP_TIMED_OUT

    - update_marathon_app:
        do:
          marathon.update_app:
            - marathon_host
            - marathon_port
            - json_file: ${json_file_for_update}
            - app_id: ${created_app_id}
        navigate:
          - SUCCESS: delete_marathon_app
          - FAILURE: FAIL_TO_UPDATE

    - delete_marathon_app:
        do:
          marathon.delete_app:
             - marathon_host
             - marathon_port
             - app_id: ${created_app_id}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAIL_TO_DELETE

  results:
    - SUCCESS
    - SETUP_MARATHON_PROBLEM
    - WAIT_FOR_MARATHON_APP_STARTUP_TIMED_OUT
    - WAIT_FOR_MARATHON_STARTUP_TIMED_OUT
    - FAIL_TO_CREATE
    - FAIL_TO_DELETE
    - FAIL_TO_UPDATE
