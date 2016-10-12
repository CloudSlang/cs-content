#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

########################################################################################################################
#!!
#! @description: Retrieves a MySQL server status from a Docker container.
#! @input container: name or ID of the Docker container that runs MySQL
#! @input host: Docker machine host
#! @input port: optional - Docker machine port
#! @input username: Docker machine username
#! @input password: optional - Docker machine password
#! @input private_key_file: optional - path to private key file
#! @input mysql_username: MySQL instance username
#! @input mysql_password: MySQL instance password
#! @output uptime: number of seconds MySQL server has been running
#! @output threads: number of active threads (clients)
#! @output questions: number of questions (queries) from clients since server was started
#! @output slow_queries: number of queries that have taken more than long_query_time (MySQL system variable) seconds
#! @output opens: number of tables server has opened
#! @output flush_tables: number of flush-*, refresh, and reload commands server has executed
#! @output open_tables: number of tables that are currently open
#! @output queries_per_second_AVG: average value of number of queries per second
#! @output error_message: possible error message, may contain the STDERR of the machine or the cause of an exception
#! @result SUCCESS: successful
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.monitoring.mysql

imports:
  mysql: io.cloudslang.docker.monitoring.mysql

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
        sensitive: true
    - private_key_file:
        required: false
    - mysql_username
    - mysql_password:
        sensitive: true

  workflow:
    - check_mysql_is_up:
        do:
          mysql.check_mysql_is_up:
            - container
            - host
            - port
            - username
            - password
            - private_key_file
            - mysql_username
            - mysql_password
        publish:
            - error_message

    - get_mysql_status:
        do:
          mysql.get_mysql_status:
            - container
            - host
            - port
            - username
            - password
            - private_key_file
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
