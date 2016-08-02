#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Created by Florian TEISSEDRE - florian.teissedre@hpe.com
####################################################
namespace: io.cloudslang.cloud.heroku.domains

imports:
  domains: io.cloudslang.cloud.heroku.domains
  lists: io.cloudslang.base.lists

flow:
  name: test_delete_domain

  inputs:
    - username
    - password
    - app_id_or_name
    - domain_id_or_hostname

  workflow:
    - delete_domain:
        do:
          domains.delete_domain:
            - username
            - password
            - app_id_or_name
            - domain_id_or_hostname
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: check_result
          - FAILURE: DELETE_DOMAIN_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${[str(error_message), int(return_code), int(status_code)]}
            - list_2: ['', 0, 200]
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESULT_FAILURE

  results:
    - SUCCESS
    - DELETE_DOMAIN_FAILURE
    - CHECK_RESULT_FAILURE
