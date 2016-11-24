#   (c) Copyright 2015-2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################

namespace: io.cloudslang.google.gke

imports:
  gke: io.cloudslang.google.gke
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
          gke.beta_list_clusters:
            - project_id
            - json_google_auth_path
        publish:
          - return_result
          - response
          - error_message
          - response_body: ${return_result}
        navigate:
          - SUCCESS: print_ListClusters
          - FAILURE: FAILURE

    - print_ListClusters:
        do:
          print.print_text:
            - text: ${response}
        navigate:
          - SUCCESS: ListOperations

    - ListOperations:
        do:
          gke.beta_list_operations:
            - project_id
            - json_google_auth_path
        publish:
          - return_result
          - response
          - error_message
          - response_body: ${return_result}
        navigate:
          - SUCCESS: print_ListOperations
          - FAILURE: FAILURE

    - print_ListOperations:
        do:
          print.print_text:
            - text: ${response}
        navigate:
          - SUCCESS: getServerconfig

    - getServerconfig:
        do:
          gke.beta_get_serverconfig:
            - project_id
            - json_google_auth_path
        publish:
          - return_result
          - response
          - error_message
          - response_body: ${return_result}
        navigate:
          - SUCCESS: print_getServerconfig
          - FAILURE: FAILURE

    - print_getServerconfig:
        do:
          print.print_text:
            - text: ${response}
        navigate:
          - SUCCESS: getOperation

    - getOperation:
        do:
          gke.beta_get_operation_details:
            - project_id
            - zone
            - json_google_auth_path
            - operation_id
        publish:
          - return_result
          - response
          - error_message
          - response_body: ${return_result}
        navigate:
          - SUCCESS: print_getOperations
          - FAILURE: FAILURE

    - print_getOperations:
        do:
          print.print_text:
            - text: ${response}
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - return_result
    - error_message
  results:
    - SUCCESS
    - FAILURE
