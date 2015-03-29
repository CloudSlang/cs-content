#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
# Retrieves a MySQL server status from a Docker container.
#
# Inputs:
#   - container - name or ID of the Docker container that runs MySQL
#   - docker_host - Docker machine host
#   - docker_username - Docker machine username
#   - docker_password - Docker machine password
#   - private_key_file - optional - absolute path to private key file - Default: none
#   - mysql_username - MySQL instance username
#   - mysql_password - MySQL instance password
# Outputs:
#   - uptime - number of seconds MySQL server has been running
#   - threads - number of active threads (clients)
#   - questions - number of questions (queries) from clients since server was started
#   - slow_queries - number of queries that have taken more than long_query_time (MySQL system variable) seconds
#   - opens - number of tables server has opened
#   - flush_tables - number of flush-*, refresh, and reload commands server has executed
#   - open_tables - number of tables that are currently open
#   - queries_per_second_AVG - average value of number of queries per second
#   - error_message - possible error message, may contain the STDERR of the machine or the cause of an exception
##################################################################################################################################################

namespace: io.cloudslang.docker.maintenance

imports:
 docker_maintenance: io.cloudslang.docker.maintenance
 base_os_linux: io.cloudslang.base.os.linux

flow:
  name: retrieve_mysql_status

  inputs:
    - container
    - docker_host
    - docker_username
    - docker_password
    - private_key_file:
        default: "''"
    - mysql_username
    - mysql_password

  workflow:
    - validate_linux_machine_ssh_access:
            do:
              base_os_linux.validate_linux_machine_ssh_access:
                - host: docker_host
                - username: docker_username
                - password: docker_password
                - privateKeyFile: private_key_file
            publish:
                - error_message

    - check_mysql_is_up:
            do:
              docker_maintenance.check_mysql_is_up:
                - container
                - host: docker_host
                - username: docker_username
                - password: docker_password
                - privateKeyFile: private_key_file
                - mysqlUsername: mysql_username
                - mysqlPassword: mysql_password
            publish:
                - error_message

    - get_mysql_status:
            do:
              docker_maintenance.get_mysql_status:
                - container
                - host: docker_host
                - username: docker_username
                - password: docker_password
                - privateKeyFile: private_key_file
                - mysqlUsername: mysql_username
                - mysqlPassword: mysql_password
            publish:
                - uptime
                - threads
                - questions
                - slow_queries
                - opens
                - flush_tables
                - open_tables
                - queries_per_second_AVG
                - error_message

  outputs:
    - uptime
    - threads
    - questions
    - slow_queries
    - opens
    - flush_tables
    - open_tables
    - queries_per_second_AVG
    - error_message
