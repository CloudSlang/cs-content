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

    - remove_app_container:
        do:
          containers.clear_container:
            - container_ID: app_container_name
            - docker_host
            - docker_username
            - docker_password:
                required: false
            - private_key_file:
                required: false
            - port: docker_ssh_port
        navigate:
          SUCCESS: remove_db_container
          FAILURE: REMOVE_APP_CONTAINER_PROBLEM

    - remove_db_container:
        do:
          containers.clear_container:
            - container_ID: db_container_name
            - docker_host
            - docker_username
            - docker_password:
                required: false
            - private_key_file:
                required: false
            - port: docker_ssh_port
        navigate:
          SUCCESS: SUCCESS
          FAILURE: REMOVE_DB_CONTAINER_PROBLEM

  results:
    - SUCCESS
    - REMOVE_APP_CONTAINER_PROBLEM
    - REMOVE_DB_CONTAINER_PROBLEM
    - FAILURE
