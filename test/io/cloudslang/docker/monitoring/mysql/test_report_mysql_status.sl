namespace: io.cloudslang.docker.monitoring.mysql

imports:
  docker_containers_examples: io.cloudslang.docker.containers.examples
  maintenance: io.cloudslang.docker.maintenance
  docker_monitoring_mysql: io.cloudslang.docker.monitoring.mysql
  utils: io.cloudslang.base.utils
  mysql: io.cloudslang.docker.monitoring.mysql

flow:
  name: test_report_mysql_status
  inputs:
    - host
    - port:
        required: false
    - username
    - password
    - mysql_username
    - mysql_password
    - email_host
    - email_port
    - email_sender
    - email_password
    - email_recipient

  workflow:
#    - pre_test_cleanup:
#         do:
#           maintenance.clear_docker_host:
#             - docker_host: host
#             - port:
#                 required: false
#             - docker_username: username
#             - docker_password: password
#         navigate:
#           SUCCESS: start_mysql_container
#           FAILURE: MACHINE_IS_NOT_CLEAN
#
    - start_mysql_container:
        do:
          docker_containers_examples.create_db_container:
            - host
            - port:
                required: false
            - username
            - password
        navigate:
          SUCCESS: report_mysql_status
          FAILURE: FAIL_TO_START_MYSQL_CONTAINER

    - report_mysql_status:
        do:
          mysql.report_mysql_status:
            - container: "'mysqldb'"
            - host
            - port
            - username
            - password
            - mysql_username
            - mysql_password
            - email_host
            - email_port
            - email_sender
            - email_recipient
            - email_password
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE

  results:
    - SUCCESS
    - FAIL_VALIDATE_SSH
    - MACHINE_IS_NOT_CLEAN
    - FAIL_TO_START_MYSQL_CONTAINER
    - MYSQL_CONTAINER_NOT_UP
    - MYSQL_CONTAINER_STATUES_CAN_BE_FETCHED
    - FAILED_TO_SLEEP
    - FAILURE