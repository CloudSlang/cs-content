#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.docker.maintenance

imports:
  images: io.cloudslang.docker.images
  containers: io.cloudslang.docker.containers
  maintenance: io.cloudslang.docker.maintenance
  ssh: io.cloudslang.base.remote_command_execution.ssh
  strings: io.cloudslang.base.strings

flow:
  name: test_mysql_monitor
  inputs:
    - host
    - port:
        required: false
    - username
    - password

  workflow:
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
          containers.create_db_container:
            - host
            - port:
                required: false
            - username
            - password
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAIL_TO_START_MYSQL_CONTAINER

  results:
    - SUCCESS
    - FAIL_VALIDATE_SSH
    - MACHINE_IS_NOT_CLEAN
    - FAIL_TO_START_MYSQL_CONTAINER
