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
  base_strings: io.cloudslang.base.strings
  base_print: io.cloudslang.base.print
  utils: io.cloudslang.base.utils
  network: io.cloudslang.base.network
flow:
  name: setup_marathon_on_different_hosts
  inputs:
    - marathon_host
    - username
    - private_key_file
    - marathon_port:
        required: false
    - is_core_os

  workflow:
    - check_is_core_os:
        do:
          utils.is_true:
            - bool_value: bool(is_core_os)
        navigate:
          SUCCESS: setup_marathon_core_os
          FAILURE: setup_marathon

    - setup_marathon_core_os:
        do:
          setup_marathon_core_os:
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
          network.verify_app_is_up:
              - ssl: 0
              - host: marathon_host
              - port: get('proxy_host', "8080")
              - attempts: 15
              - time_to_sleep: 5
        navigate:
          SUCCESS: SUCCESS
          FAILURE: SETUP_MARATHON_PROBLEM

  results:
    - SUCCESS
    - SETUP_MARATHON_PROBLEM