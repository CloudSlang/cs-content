#   (c) Copyright 2015-2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
############################################################################################################################################################################################

namespace: io.cloudslang.google.gke

imports:
  gke: io.cloudslang.google.gke
  utils: io.cloudslang.base.utils
  print: io.cloudslang.base.print

flow:
  name: test_create
  inputs:
    - project_id
    - zone
    - json_google_auth_path
    - name
    - initial_node_count
    - network
    - masterauth_username
    - masterauth_password

  workflow:
    - createResourceCluster:
        do:
          gke.beta_create_resource_cluster:
            - name
            - initial_node_count
            - masterauth_username
            - masterauth_password
        publish:
          - return_result
          - response
          - error_message
          - response_body: ${return_result}
        navigate:
          - SUCCESS: print_createResourceCluster
          - FAILURE: FAILURE

    - print_createResourceCluster:
        do:
          print.print_text:
            - text: ${response}
        navigate:
          - SUCCESS: createCluster

    - createCluster:
        do:
          gke.beta_create_clusters:
            - project_id
            - zone
            - json_google_auth_path
            - cluster: ${response}
        publish:
          - return_result
          - response
          - cluster_name
          - error_message
          - response_body: ${return_result}
        navigate:
          - SUCCESS: print_createCluster
          - FAILURE: FAILURE

    - print_createCluster:
        do:
          print.print_text:
            - text: ${cluster_name}
        navigate:
          - SUCCESS: SleepTime

    - SleepTime:
        do:
          utils.sleep:
            - seconds: '240'
        navigate:
          - SUCCESS: deleteCluster
          - FAILURE: FAILURE

    - deleteCluster:
        do:
          gke.beta_delete_clusters:
            - project_id
            - zone
            - json_google_auth_path
            - cluster_id: ${name}
        publish:
          - return_result
          - response
          - error_message
          - response_body: ${return_result}
        navigate:
          - SUCCESS: print_deleteCluster
          - FAILURE: FAILURE

    - print_deleteCluster:
        do:
          print.print_text:
            - text: ${cluster_name}
        navigate:
          - SUCCESS: SUCCESS

  outputs:
    - return_result
    - error_message

  results:
    - SUCCESS
    - FAILURE