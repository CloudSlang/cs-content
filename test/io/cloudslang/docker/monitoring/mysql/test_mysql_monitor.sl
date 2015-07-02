#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.docker.monitoring.mysql

imports:
  docker_containers_examples: io.cloudslang.docker.containers.examples
  maintenance: io.cloudslang.docker.maintenance
  docker_monitoring_mysql: io.cloudslang.docker.monitoring.mysql
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
           maintenance.clear_docker_host:
             - docker_host: host
             - port:
                 required: false
             - docker_username: username
             - docker_password: password
         navigate:
           SUCCESS: start_mysql_container
           FAILURE: MACHINE_IS_NOT_CLEAN

    - start_mysql_container:
        do:
          docker_containers_examples.create_db_container:
            - host
            - port:
                required: false
            - username
            - password
        navigate:
          SUCCESS: sleep
          FAILURE: FAIL_TO_START_MYSQL_CONTAINER

    - sleep:
        do:
          utils.sleep:
            - seconds: 20
        navigate:
          SUCCESS: get_mysql_status
          FAILURE: FAILED_TO_SLEEP

    - get_mysql_status:
        do:
          docker_monitoring_mysql.retrieve_mysql_status:
            - container: "'mysqldb'"
            - host: host
            - port:
                required: false
            - username: username
            - password: password
            - mysql_username: "'user'"
            - mysql_password: "'pass'"
        navigate:
          SUCCESS: post_test_cleanup
          FAILURE: MYSQL_CONTAINER_STATUES_CAN_BE_FETCHED

    - post_test_cleanup:
         do:
           maintenance.clear_docker_host:
             - docker_host: host
             - port:
                 required: false
             - docker_username: username
             - docker_password: password
         navigate:
           SUCCESS: SUCCESS
           FAILURE: MACHINE_IS_NOT_CLEAN
  results:
    - SUCCESS
    - FAIL_VALIDATE_SSH
    - MACHINE_IS_NOT_CLEAN
    - FAIL_TO_START_MYSQL_CONTAINER
    - MYSQL_CONTAINER_NOT_UP
    - MYSQL_CONTAINER_STATUES_CAN_BE_FETCHED
    - FAILED_TO_SLEEP
