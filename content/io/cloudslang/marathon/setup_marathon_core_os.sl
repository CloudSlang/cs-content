#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#######################################################################################################################
#!!
#! @description: Sets up a simple Marathon infrastructure on one CoreOS host.
#! @input host: Docker host
#! @input username: username for Docker host
#! @input private_key_file: private key file for host
#! @input marathon_port: optional - Marathon agent port - Default: 8080
#! @input timeout: optional - time in milliseconds to wait for one ssh command to complete - Default: 3000000 ms (50 min)
#! @result SUCCESS: setup succeeded
#! @result CLEAR_CONTAINERS_ON_HOST_PROBLEM: setup failed due to problem clearing containers
#! @result START_ZOOKEEPER_PROBLEM: setup failed due to problem starting ZooKeeper
#! @result START_MESOS_MASTER_PROBLEM: setup failed due to problem starting Mesos master
#! @result START_MESOS_SLAVE_PROBLEM: setup failed due to problem starting Mesos slave
#! @result START_MARATHON_PROBLEM: setup failed due to problem starting Marathon
#!!#
#######################################################################################################################

namespace: io.cloudslang.marathon

imports:
  containers: io.cloudslang.docker.containers
  print: io.cloudslang.base.print
flow:
  name: setup_marathon_core_os
  inputs:
    - host
    - username
    - private_key_file
    - marathon_port:
        default: "8080"
    - timeout: "3000000"
  workflow:
    - clear_containers_on_host:
       do:
         containers.clear_containers:
           - docker_host: ${host}
           - docker_username: ${username}
           - private_key_file
       navigate:
         - SUCCESS: print_before_zookeeper
         - FAILURE: CLEAR_CONTAINERS_ON_HOST_PROBLEM

    - print_before_zookeeper:
        do:
          print.print_text:
              - text: "Start zookeeper."
        navigate:
          - SUCCESS: start_zookeeper

    - start_zookeeper:
       do:
         containers.run_container:
           - container_name: "zookeeper"
           - container_params: >
              ${'-p 2181:218 ' +
              '-p 2888:2888 ' +
              '-p 3888:3888'}
           - image_name: "jplock/zookeeper"
           - host
           - username
           - private_key_file
           - timeout
       navigate:
         - SUCCESS: print_before_mesos_master
         - FAILURE: START_ZOOKEEPER_PROBLEM

    - print_before_mesos_master:
        do:
          print.print_text:
              - text: "Start mesos master."
        navigate:
          - SUCCESS: start_mesos_master

    - start_mesos_master:
       do:
         containers.run_container:
           - container_name: "mesos_master"
           - container_params: >
              ${'--link zookeeper:zookeeper ' +
              '-e MESOS_QUORUM=1 ' +
              '-e MESOS_LOG_DIR=/var/log/mesos/master ' +
              '-e MESOS_WORK_DIR=/var/lib/mesos/master ' +
              '-e MESOS_ZK=zk://zookeeper:2181/mesos ' +
              '-p 5050:5050'}
           - image_name: "mesosphere/mesos-master:0.24.1-0.2.35.ubuntu1404"
           - host
           - username
           - private_key_file
           - timeout
       navigate:
         - SUCCESS: print_before_mesos_slave
         - FAILURE: START_MESOS_MASTER_PROBLEM

    - print_before_mesos_slave:
        do:
          print.print_text:
              - text: "Start mesos slave."
        navigate:
          - SUCCESS: start_mesos_slave

    - start_mesos_slave:
       do:
         containers.run_container:
           - container_name: "mesos_slave"
           - container_params: >
              ${'--privileged=true ' +
              '--link zookeeper:zookeeper ' +
              '-e MESOS_LOG_DIR=/var/log/mesos/slave ' +
              '-e MESOS_MASTER=zk://zookeeper:2181/mesos ' +
              '-e MESOS_CONTAINERIZERS=docker ' +
              '-p 5051:5051 ' +
              '-v /sys:/sys ' +
              '-v /usr/bin/docker:/usr/bin/docker:ro ' +
              '-v /var/run/docker.sock:/var/run/docker.sock ' +
              '-v /lib64/libdevmapper.so.1.02:/lib/libdevmapper.so.1.02:ro ' +
              '-v /lib64/libpthread.so.0:/lib/libpthread.so.0:ro ' +
              '-v /lib64/libsqlite3.so.0:/lib/libsqlite3.so.0:ro ' +
              '-v /lib64/libudev.so.1:/lib/libudev.so.1:ro '}
           - image_name: "mesosphere/mesos-slave:0.24.1-0.2.35.ubuntu1404"
           - host
           - username
           - private_key_file
           - timeout
       navigate:
         - SUCCESS: print_before_marathon
         - FAILURE: START_MESOS_SLAVE_PROBLEM

    - print_before_marathon:
        do:
          print.print_text:
              - text: "Start Marathon."
        navigate:
          - SUCCESS: start_marathon

    - start_marathon:
       do:
         containers.run_container:
           - container_name: "marathon "
           - container_params: >
              ${'--link zookeeper:zookeeper ' +
              '--link mesos_master:mesos_master ' +
              '-p ' + marathon_port + ':8080'}
           - container_command: >
              ${'--master mesos_master:5050 ' +
              '--zk zk://zookeeper:2181/marathon'}
           - image_name: "mesosphere/marathon:v0.13.0"
           - host
           - username
           - private_key_file
           - timeout
       navigate:
         - SUCCESS: SUCCESS
         - FAILURE: START_MARATHON_PROBLEM
  results:
    - SUCCESS
    - CLEAR_CONTAINERS_ON_HOST_PROBLEM
    - START_ZOOKEEPER_PROBLEM
    - START_MESOS_MASTER_PROBLEM
    - START_MESOS_SLAVE_PROBLEM
    - START_MARATHON_PROBLEM
