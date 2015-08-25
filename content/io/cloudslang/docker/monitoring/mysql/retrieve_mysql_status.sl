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
#   - host - Docker machine host
#   - port - optional - Docker machine port
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - private_key_file - optional - path to private key file
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
# Results:
#   - SUCCESS - successful
#   - FAILURE - otherwise
##################################################################################################################################################

namespace: io.cloudslang.docker.monitoring.mysql

imports:
 base_os_linux: io.cloudslang.base.os.linux

flow:
  name: retrieve_mysql_status

  inputs:
    - container
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - private_key_file:
        required: false
    - mysql_username
    - mysql_password

  workflow:
    - check_mysql_is_up:
        do:
          check_mysql_is_up:
            - container
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - private_key_file:
                required: false
            - mysql_username
            - mysql_password
        publish:
            - error_message

    - get_mysql_status:
        do:
          get_mysql_status:
            - container
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - private_key_file:
                required: false
            - mysql_username
            - mysql_password
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
