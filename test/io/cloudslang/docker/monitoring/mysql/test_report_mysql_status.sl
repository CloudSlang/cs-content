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

namespace: io.cloudslang.docker.monitoring.mysql

imports:
  mysql: io.cloudslang.docker.monitoring.mysql
  containers_examples: io.cloudslang.docker.containers.examples
  maintenance: io.cloudslang.docker.maintenance
  utils: io.cloudslang.base.utils
  cmd: io.cloudslang.base.cmd

flow:
  name: test_report_mysql_status

  inputs:
    - docker_host
    - docker_port:
        required: false
    - docker_username
    - docker_password
    - mysql_username
    - mysql_password
    - email_host
    - email_username
    - email_port
    - email_sender
    - email_password
    - email_recipient

  workflow:
    - pre_test_cleanup:
        do:
         maintenance.clear_host:
           - docker_host
           - port: ${ docker_port }
           - docker_username
           - docker_password
        navigate:
         - SUCCESS: run_postfix
         - FAILURE: MACHINE_IS_NOT_CLEAN

    - run_postfix:
        do:
          cmd.run_command:
            - command: ${ 'docker run -p ' + email_port + ':' + '25' + ' -e maildomain=mail.example.com -e smtp_user=user:pwd --name postfix -d catatnight/postfix' }

    - wait_for_postfix:
        do:
          utils.sleep:
            - seconds: '10'

    - start_mysql_container:
        do:
          containers_examples.create_db_container:
            - host: ${ docker_host }
            - port: ${ docker_port }
            - username: ${ docker_username }
            - password: ${ docker_password }
        navigate:
          - SUCCESS: wait_for_mysql
          - FAILURE: FAIL_TO_START_MYSQL_CONTAINER

    - wait_for_mysql:
        do:
          utils.sleep:
            - seconds: '20'

    - report_mysql_status:
        do:
          mysql.report_mysql_status:
            - container: "mysqldb"
            - docker_host
            - docker_port
            - docker_username
            - docker_password
            - mysql_username
            - mysql_password
            - email_host
            - email_username
            - email_password
            - email_port
            - email_sender
            - email_recipient
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  results:
    - SUCCESS
    - MACHINE_IS_NOT_CLEAN
    - FAIL_TO_START_MYSQL_CONTAINER
    - FAILURE
