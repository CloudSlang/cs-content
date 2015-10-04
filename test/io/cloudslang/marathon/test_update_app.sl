#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.marathon

imports:
  utils: io.cloudslang.base.utils

flow:
  name: test_update_app
  inputs:
    - marathon_host
    - username
    - private_key_file
    - marathon_port:
        required: false
    - json_file_for_creation
    - json_file_for_update
    - created_app_id
  workflow:
    - setup_marathon:
        do:
          setup_marathon:
            - host: marathon_host
            - username
            - private_key_file
            - marathon_port
        navigate:
          SUCCESS: wait_for_marathon_startup
          CLEAR_CONTAINERS_ON_HOST_PROBLEM: SETUP_MARATHON_PROBLEM
          START_ZOOKEEPER_PROBLEM: SETUP_MARATHON_PROBLEM
          START_MESOS_MASTER_PROBLEM: SETUP_MARATHON_PROBLEM
          START_MESOS_SLAVE_PROBLEM: SETUP_MARATHON_PROBLEM
          START_MARATHON_PROBLEM: SETUP_MARATHON_PROBLEM

    - wait_for_marathon_startup:
        do:
          utils.sleep:
              - seconds: 20

    - create_marathon_app:
         do:
           create_app:
             - marathon_host
             - marathon_port
             - json_file: json_file_for_creation
         navigate:
           SUCCESS: wait_for_app_to_deploy
           FAILURE: FAIL_TO_CREATE

    - wait_for_app_to_deploy:
        do:
          utils.sleep:
              - seconds: 5

    - update_marathon_app:
        do:
          update_app:
            - marathon_host
            - marathon_port
            - json_file: json_file_for_update
            - app_id: created_app_id
        navigate:
          SUCCESS: delete_marathon_app
          FAILURE: FAIL_TO_UPDATE

    - delete_marathon_app:
        do:
          delete_app:
             - marathon_host
             - marathon_port
             - app_id: created_app_id
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAIL_TO_DELETE

  results:
    - SUCCESS
    - FAILURE
    - SETUP_MARATHON_PROBLEM
    - FAIL_TO_CREATE
    - FAIL_TO_DELETE
    - FAIL_TO_UPDATE
