#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################

namespace: io.cloudslang.docker.containers

imports:
 containers: io.cloudslang.docker.containers
 maintenance: io.cloudslang.docker.maintenance

flow:
  name: test_demo_dev_ops
  inputs:
    - docker_host
    - docker_ssh_port:
        default: "'22'"
    - docker_username
    - docker_password:
        required: false
    - private_key_file:
        required: false
    - db_container_name:
        default: "'mysqldb'"
    - app_container_name:
        default: "'spring-boot-tomcat-mysql-app'"
    - app_port:
        default: "'8080'"
    - email_host
    - email_port
    - email_sender
    - email_recipient
    - timeout:
        default: "'30000000'"
  workflow:

    - execute_demo_dev_ops:
        do:
          containers.demo_dev_ops:
            - docker_host
            - docker_ssh_port
            - docker_username
            - docker_password:
                required: false
            - private_key_file:
                required: false
            - db_container_name
            - app_container_name
            - app_port
            - email_host
            - email_port
            - email_sender
            - email_recipient
        navigate:
          SUCCESS: SUCCESS # TODO: remove later - debugging scope
          DB_CONTAINER_STARTUP_PROBLEM: DB_CONTAINER_STARTUP_PROBLEM
          PULL_APP_IMAGE_PROBLEM: PULL_APP_IMAGE_PROBLEM
          START_LINKED_CONTAINER_PROBLEM: START_LINKED_CONTAINER_PROBLEM
          VERIFY_APP_IS_UP_PROBLEM: VERIFY_APP_IS_UP_PROBLEM
          FAILURE: FAILURE
          CONTAINER_DETAILS_PROBLEM: CONTAINER_DETAILS_PROBLEM

    - clear_docker_host:
        do:
          maintenance.clear_docker_host:
            - docker_host
            - docker_username
            - docker_password:
                required: false
            - private_key_file:
                required: false
            - timeout
            - port: docker_ssh_port
        navigate:
          SUCCESS: SUCCESS
          FAILURE: CLEAR_DOCKER_HOST_PROBLEM

  results:
    - SUCCESS
    - CLEAR_DOCKER_HOST_PROBLEM
    - FAILURE
    - DB_CONTAINER_STARTUP_PROBLEM # TODO: remove later - debugging scope
    - PULL_APP_IMAGE_PROBLEM
    - START_LINKED_CONTAINER_PROBLEM
    - VERIFY_APP_IS_UP_PROBLEM
    - CONTAINER_DETAILS_PROBLEM