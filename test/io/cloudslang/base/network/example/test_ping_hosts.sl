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

flow:
  name: test_ping_hosts
  inputs:
    - ip_list

  workflow:
    - ping_hosts:
        do:
          ping_hosts:
            - ip_list
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE

  results:
    - SUCCESS
    - FAIL_TO_PULL_POSTFIX
    - FAIL_TO_START_POSTFIX
    - MACHINE_IS_NOT_CLEAN
    - FAILURE