#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.base.network.example

imports:
  maintenance: io.cloudslang.docker.maintenance
  utils: io.cloudslang.base.utils
  cmd: io.cloudslang.base.cmd
  network: io.cloudslang.base.network
  example: io.cloudslang.base.network.example

flow:
  name: test_ping_hosts
  inputs:
    - ip_list
    - docker_host
    - docker_port:
        required: false
    - docker_username
    - docker_password
    - email_host:
        system_property: io.cloudslang.base.hostname
    - email_port:
        system_property: io.cloudslang.base.port

  workflow:

    - pre_test_cleanup:
         do:
           maintenance.clear_docker_host:
             - docker_host
             - port:
                 required: false
                 default: docker_port
             - docker_username
             - docker_password
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
            - command: "'docker run -p ' + email_port + ':' + email_port + ' -e maildomain=' + email_host + ' -e smtp_user=user:pwd --name postfix -d catatnight/postfix'"

    - sleep:
        do:
          utils.sleep:
            - seconds: 5

    - verify_postfix:
        do:
          network.verify_app_is_up:
            - host: docker_host
            - port:
                system_property: io.cloudslang.base.port
        navigate:
          SUCCESS: ping_hosts
          FAILURE: FAIL_TO_START_POSTFIX
    - ping_hosts:
        do:
          example.ping_hosts:
            - ip_list
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
    - FAILURE
