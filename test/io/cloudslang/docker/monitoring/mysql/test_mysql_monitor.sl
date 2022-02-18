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

namespace: io.cloudslang.docker.monitoring.mysql

imports:
  mysql: io.cloudslang.docker.monitoring.mysql
  containers_examples: io.cloudslang.docker.containers.examples
  maintenance: io.cloudslang.docker.maintenance
  utils: io.cloudslang.base.utils

flow:
  name: test_mysql_monitor

  inputs:
    - host
    - port:
        required: false
    - username
    - password

  workflow:
    - pre_test_cleanup:
        do:
         maintenance.clear_host:
           - docker_host: ${ host }
           - port
           - docker_username: ${ username }
           - docker_password: ${ password }
        navigate:
         - SUCCESS: start_mysql_container
         - FAILURE: MACHINE_IS_NOT_CLEAN

    - start_mysql_container:
        do:
          containers_examples.create_db_container:
            - host
            - port
            - username
            - password
        navigate:
          - SUCCESS: sleep
          - FAILURE: FAIL_TO_START_MYSQL_CONTAINER

    - sleep:
        do:
          utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: get_mysql_status
          - FAILURE: FAILED_TO_SLEEP

    - get_mysql_status:
        do:
          mysql.retrieve_mysql_status:
            - container: "mysqldb"
            - host: ${ host }
            - port
            - username: ${ username }
            - password: ${ password }
            - mysql_username: "user"
            - mysql_password: "pass"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: MYSQL_CONTAINER_STATUES_CAN_BE_FETCHED

  results:
    - SUCCESS
    - MACHINE_IS_NOT_CLEAN
    - FAIL_TO_START_MYSQL_CONTAINER
    - MYSQL_CONTAINER_STATUES_CAN_BE_FETCHED
    - FAILED_TO_SLEEP
