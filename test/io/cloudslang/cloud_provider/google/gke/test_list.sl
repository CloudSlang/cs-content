#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.cloud_provider.google.gke

imports:
  utils: io.cloudslang.base.utils
  print: io.cloudslang.base.print

flow:
  name: test_list
  inputs:
    - project_id
    - zone
    - json_google_auth_path
    - name
    - network
    - operation_id
  workflow:
    - ListClusters:
        do:
          beta_list_clusters:
            - project_id
            - json_google_auth_path
        publish:
          - return_result
          - response
          - error_message
          - response_body: ${return_result}

    - print_ListClusters:
        do:
          print.print_text:
            - text: ${response}

    - ListOperations:
        do:
          beta_list_operations:
            - project_id
            - json_google_auth_path
        publish:
          - return_result
          - response
          - error_message
          - response_body: ${return_result}

    - print_ListOperations:
        do:
          print.print_text:
            - text: ${response}

    - getServerconfig:
        do:
          beta_get_serverconfig:
            - project_id
            - json_google_auth_path
        publish:
          - return_result
          - response
          - error_message
          - response_body: ${return_result}

    - print_getServerconfig:
        do:
          print.print_text:
            - text: ${response}

    - getOperation:
        do:
          beta_get_operations:
            - project_id
            - zone
            - json_google_auth_path
            - operation_id
        publish:
          - return_result
          - response
          - error_message
          - response_body: ${return_result}

    - print_getOperations:
        do:
          print.print_text:
            - text: ${response}
  outputs:
    - return_result
    - error_message
  results:
    - SUCCESS
    - FAILURE