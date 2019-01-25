#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
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

namespace: io.cloudslang.docker.containers

imports:
  containers: io.cloudslang.docker.containers
  strings: io.cloudslang.base.strings
  lists: io.cloudslang.base.lists

flow:
  name: test_get_container_names

  inputs:
    - host
    - port:
        default: '22'
    - username
    - password:
        required: false
    - private_key_file:
        required: false
    - image_name:
        default: 'busybox'
        private: true
    - container_name1:
        default: 'busy1'
        private: true
    - container_name2:
        default: 'busy2'
        private: true
    - timeout:
        default: '6000000'

  workflow:
    - run_container1:
       do:
          containers.run_container:
            - container_name: ${container_name1}
            - container_command: ${'/bin/sh -c "while true; do echo hello world; sleep 1; done"'}
            - image_name
            - host
            - port
            - username
            - password: ${password}
            - private_key_file
            - timeout
       navigate:
         - SUCCESS: run_container2
         - FAILURE: RUN_CONTAINER1_PROBLEM

    - run_container2:
       do:
          containers.run_container:
            - container_name: ${ container_name2 }
            - container_command: ${'/bin/sh -c "while true; do echo hello world; sleep 1; done"'}
            - image_name
            - host
            - port
            - username
            - password
            - private_key_file
            - timeout
       navigate:
         - SUCCESS: get_container_names
         - FAILURE: RUN_CONTAINER2_PROBLEM

    - get_container_names:
       do:
          containers.get_container_names:
            - host
            - port
            - username
            - password
            - private_key_file
            - timeout
       publish:
        - container_names
       navigate:
         - SUCCESS: subtract_names
         - FAILURE: FAILURE

    - subtract_names:
        do:
          lists.subtract_sets:
            - set_1: ${container_names}
            - set_1_delimiter: ' '
            - set_2: ${container_name1 + ' ' + container_name2}
            - set_2_delimiter: ' '
            - result_set_delimiter: ' '
        publish:
          - result_set
        navigate:
          - SUCCESS: check_empty_set

    - check_empty_set:
        do:
          strings.string_equals:
            - first_string: ${result_set}
            - second_string: ''
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CONTAINER_NAMES_VERIFY_PROBLEM

  results:
    - SUCCESS
    - FAILURE
    - RUN_CONTAINER1_PROBLEM
    - RUN_CONTAINER2_PROBLEM
    - CONTAINER_NAMES_VERIFY_PROBLEM
