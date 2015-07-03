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
    - docker_host
    - docker_port:
        required: false
    - docker_username
    - docker_password
    - mysql_username
    - mysql_password
    - email_host
    - email_port
    - email_sender
    - email_password
    - email_recipient

  workflow:

    - pre_test_cleanup:
         do:
           maintenance.clear_docker_host:
             - docker_host
             - port:
                 required: false
             - docker_username: username
             - docker_password: password
         navigate:
           SUCCESS: pull_postfix
           FAILURE: MACHINE_IS_NOT_CLEAN
    - pull_postfix:
        do:
          cmd.run_command:
            - command: "'docker pull catatnight/postfix'"
        navigate:
          SUCCESS: run_postfix
          FAILURE: FAIL_TO_PULL_POSTFIX

    - run_postfix:
        do:
          cmd.run_command:
            - command: "'docker run -p ' + email_port + ':' + email_port + ' -e maildomain=mail.example.com -e smtp_user=user:pwd --name postfix -d catatnight/postfix'"

    - sleep:
        do:
          utils.sleep:
            - seconds: 5

    - verify_postfix:
        do:
          network.verify_app_is_up:
            - host: docker_host
            - port: email_port
        navigate:
          SUCCESS: start_mysql_container
          FAILURE: FAIL_TO_START_POSTFIX

    - start_mysql_container:
        do:
          docker_containers_examples.create_db_container:
            - host: docker_host
            - port:
                default: docker_port
                required: false
            - username: docker_username
            - password: docker_password
        navigate:
          SUCCESS: sleep_2
          FAILURE: FAIL_TO_START_MYSQL_CONTAINER

    - sleep_2:
        do:
          utils.sleep:
            - seconds: 20
        navigate:
          SUCCESS: report_mysql_status

    - report_mysql_status:
        do:
          mysql.report_mysql_status:
            - container: "'mysqldb'"
            - host: docker_host
            - port: docker_port
            - username: docker_username
            - password: docker_password
            - mysql_username
            - mysql_password
            - email_host
            - email_port
            - email_sender
            - email_recipient
        navigate:
          SUCCESS: post_test_cleanup
          FAILURE: FAILURE

    - post_test_cleanup:
         do:
           maintenance.clear_docker_host:
             - docker_host
             - port:
                 default: docker_port
                 required: false
             - docker_username
             - docker_password
         navigate:
           SUCCESS: SUCCESS
           FAILURE: MACHINE_IS_NOT_CLEAN


  results:
    - SUCCESS
    - FAIL_TO_PULL_POSTFIX
    - FAIL_TO_START_POSTFIX
    - MACHINE_IS_NOT_CLEAN
    - FAIL_TO_START_MYSQL_CONTAINER
    - FAILURE