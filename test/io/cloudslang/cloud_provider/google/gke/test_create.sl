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
          beta_create_resource_cluster:
            - name
            - initial_node_count
            - masterauth_username
            - masterauth_password
        publish:
          - return_result
          - response
          - error_message
          - response_body: ${return_result}

    - print_createResourceCluster:
        do:
          print.print_text:
            - text: ${response}

    - createCluster:
        do:
          beta_create_clusters:
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

    - print_createCluster:
        do:
          print.print_text:
            - text: ${cluster_name}

    - SleepTime:
        do:
          utils.sleep:
            - seconds: '240'

    - deleteCluster:
        do:
          beta_delete_clusters:
            - project_id
            - zone
            - json_google_auth_path
            - clusterId: ${name}
        publish:
          - return_result
          - response
          - error_message
          - response_body: ${return_result}

    - print_deleteCluster:
        do:
          print.print_text:
            - text: ${cluster_name}

  outputs:
    - return_result
    - error_message

  results:
    - SUCCESS
    - FAILURE