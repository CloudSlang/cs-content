namespace: io.cloudslang.docker.monitoring.mysql

imports:
  docker_containers_examples: io.cloudslang.docker.containers.examples
  maintenance: io.cloudslang.docker.maintenance
  docker_monitoring_mysql: io.cloudslang.docker.monitoring.mysql
  utils: io.cloudslang.base.utils
  mysql: io.cloudslang.docker.monitoring.mysql
  cmd: io.cloudslang.base.cmd
  network: io.cloudslang.base.network

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
    - pull_postfix:
        do:
          cmd.run_command:
            - command: "'docker pull catatnight/postfix'"
        navigate:
          SUCCESS: run_postfix
          FAILURE: FIAL_TO_PULL_POSTFIX

    - run_postfix:
        do:
          cmd.run_command:
            - command: "'docker run -p 25:25 -e maildomain=mail.example.com -e smtp_user=user:pwd --name postfix -d catatnight/postfix'"

    - verify_postfix:
        do:
          network.verify_app_is_up:
            - host
            - port: 25
        navigate:
          SUCCESS: pre_test_cleanup
          FAILURE: FAIL_TO_START_POSTFIX

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
          SUCCESS: report_mysql_status
          FAILURE: FAILED_TO_SLEEP

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
          SUCCESS: post_test_cleanup
          FAILURE: FAILURE

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

    - postfix_cleanup:
        do:
          cmd.run_command:
            - command: "'sudo docker stop postfix && docker rm postfix'"
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FIAL_TO_CLEAN_POSTFIX
  results:
    - SUCCESS
    - FIAL_TO_PULL_POSTFIX
    - FAIL_TO_START_POSTFIX
    - FAIL_VALIDATE_SSH
    - MACHINE_IS_NOT_CLEAN
    - FAIL_TO_START_MYSQL_CONTAINER
    - MYSQL_CONTAINER_NOT_UP
    - MYSQL_CONTAINER_STATUES_CAN_BE_FETCHED
    - FAILED_TO_SLEEP
    - FIAL_TO_CLEAN_POSTFIX
    - FAILURE