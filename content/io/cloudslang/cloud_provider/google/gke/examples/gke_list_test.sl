#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Sample workflow for Google Container Engine
#
# Inputs:
#
# Outputs:
#   - return_result - response of the operation
#   - status_code - normal status code is 202
#   - error_message: returnResult if statusCode != '202'
# Results:
#   - SUCCESS - operation succeeded (statusCode == '202')
#   - FAILURE - otherwise
####################################################
namespace: io.cloudslang.cloud_provider.google.gke
namespace: io.cloudslang.cloud_provider.google.gke.examples

imports:
  gke: io.cloudslang.cloud_provider.google.gke
  utils: io.cloudslang.base.utils
  print: io.cloudslang.base.print

flow:
  name: gke_list_test
  inputs:
    - projectId
    - zone
    - jSonGoogleAuthPath
    - name
    - initialNodeCount
    - network
    - operationId
  workflow:
    - ListClusters:
        do:
          gke.list_clusters:
            - projectId
            - jSonGoogleAuthPath
        publish:
          - return_result
          - response
          - error_message
          - response_body: return_result

    - print_ListClusters:
        do:
          print.print_text:
            - text: response

    - ListOperations:
        do:
          gke.list_operations:
            - projectId
            - jSonGoogleAuthPath
        publish:
          - return_result
          - response
          - error_message
          - response_body: return_result

    - print_ListOperations:
        do:
          print.print_text:
            - text: response

    - getServerconfig:
        do:
          gke.get_serverconfig:
            - projectId
            - jSonGoogleAuthPath
        publish:
          - return_result
          - response
          - error_message
          - response_body: return_result

    - print_getServerconfig:
        do:
          print.print_text:
            - text: response

    - getOperation:
        do:
          gke.get_operations:
            - projectId
            - zone
            - jSonGoogleAuthPath
            - operationId
        publish:
          - return_result
          - response
          - error_message
          - response_body: return_result

    - print_getOperations:
        do:
          print.print_text:
            - text: response
  outputs:
    - return_result
    - error_message
  results:
    - SUCCESS
    - FAILURE

