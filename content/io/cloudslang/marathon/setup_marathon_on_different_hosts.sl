#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#######################################################################################################################
#!!
#! @description: Sets up a simple Marathon infrastructure on one CoreOS host or on one Docker host based on the is_core_os input.
#! @input marathon_host: Marathon host
#! @input username: username for host
#! @input private_key_file: private key file used for host
#! @input marathon_port: optional - Marathon agent port - Default: 8080
#! @input is_core_os: true if the host is CoreOS - Default: false
#! @result SUCCESS:
#! @result SETUP_MARATHON_PROBLEM:
#! @result WAIT_FOR_MARATHON_STARTUP_TIMED_OUT:
#!!#
#######################################################################################################################

namespace: io.cloudslang.marathon

imports:
  marathon: io.cloudslang.marathon
  utils: io.cloudslang.base.utils
  network: io.cloudslang.base.network
  print: io.cloudslang.base.print
flow:
  name: setup_marathon_on_different_hosts
  inputs:
    - marathon_host
    - username
    - private_key_file
    - marathon_port: "8080"
    - is_core_os: false

  workflow:
    - check_is_core_os:
        do:
          utils.is_true:
            - bool_value: ${bool(is_core_os)}
        navigate:
          - SUCCESS: setup_marathon_core_os
          - FAILURE: setup_marathon_docker_host

    - setup_marathon_core_os:
        do:
          marathon.setup_marathon_core_os:
            - host: ${marathon_host}
            - username
            - private_key_file
            - marathon_port
        navigate:
          - SUCCESS: print_before_wait
          - CLEAR_CONTAINERS_ON_HOST_PROBLEM: SETUP_MARATHON_PROBLEM
          - START_ZOOKEEPER_PROBLEM: SETUP_MARATHON_PROBLEM
          - START_MESOS_MASTER_PROBLEM: SETUP_MARATHON_PROBLEM
          - START_MESOS_SLAVE_PROBLEM: SETUP_MARATHON_PROBLEM
          - START_MARATHON_PROBLEM: SETUP_MARATHON_PROBLEM

    - setup_marathon_docker_host:
        do:
          marathon.setup_marathon_docker_host:
            - host: ${marathon_host}
            - username
            - private_key_file
            - marathon_port
        navigate:
          - SUCCESS: print_before_wait
          - CLEAR_CONTAINERS_ON_HOST_PROBLEM: SETUP_MARATHON_PROBLEM
          - START_ZOOKEEPER_PROBLEM: SETUP_MARATHON_PROBLEM
          - START_MESOS_MASTER_PROBLEM: SETUP_MARATHON_PROBLEM
          - START_MESOS_SLAVE_PROBLEM: SETUP_MARATHON_PROBLEM
          - START_MARATHON_PROBLEM: SETUP_MARATHON_PROBLEM

    - print_before_wait:
        do:
          print.print_text:
              - text: "Wait for Marathon start-up."
        navigate:
          - SUCCESS: wait_for_marathon_startup

    - wait_for_marathon_startup:
        do:
          network.verify_url_is_accessible:
              - url: ${'http://'+ marathon_host + ':' + marathon_port +'/v2/apps'}
              - attempts: 30
              - time_to_sleep: 10
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: WAIT_FOR_MARATHON_STARTUP_TIMED_OUT

  results:
    - SUCCESS
    - SETUP_MARATHON_PROBLEM
    - WAIT_FOR_MARATHON_STARTUP_TIMED_OUT
