#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Creates an embedded cartridge in gke
# NOTE: This is experimental and while the app is created it cannot run yet
# WIP
#
# Inputs:
#   - cartridgeName - cartridge name
#   - applicationName - gke application name
#   - scale - optional - Mark application as scalable. Value : true, false
#   - gear_size- optional - Size of the gear. Value : small, medium
#   - host - gke host
#   - username - gke username
#   - password - gke username
#   - domain - gke domain
# Outputs:
#   - return_result - response of the operation
#   - status_code - normal status code is 202
#   - error_message: returnResult if statusCode != '202'
# Results:
#   - SUCCESS - operation succeeded (statusCode == '202')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.cloud_provider.gke2

namespace: io.cloudslang.cloud_provider.gke2.examples

imports:
  gke: io.cloudslang.cloud_provider.gke
  utils: io.cloudslang.base.utils
  print: io.cloudslang.base.print

flow:
  name: gke_testing2
  inputs:
    - projectId
    - zone
    - jSonGoogleAuthPath
    - name
    - initialNodeCount
    - network
    - machineType
    - masterauthUsername
    - masterauthPassword
  workflow:
    - createRessourceCluster:
        do:
          gke.create_resource_cluster:
            - name
            - initialNodeCount
            - masterauthUsername
            - masterauthPassword
        publish:
          - return_result
          - response
          - error_message
          - response_body: return_result

    - print_createResourceCluster:
        do:
          print.print_text:
            - text: response

    - createCluster:
        do:
          gke.create_clusters:
            - projectId
            - zone
            - jSonGoogleAuthPath
            - cluster: response
        publish:
          - return_result
          - response
          - cluster_name
          - error_message
          - response_body: return_result

    - print_createCluster:
        do:
          print.print_text:
            - text: cluster_name

    - deleteCluster:
        do:
          gke.delete_clusters:
            - projectId
            - zone
            - jSonGoogleAuthPath
            - clusterId: name 
        publish:
          - return_result
          - response
          - cluster_name
          - error_message
          - response_body: return_result

    - print_deleteCluster:
        do:
          print.print_text:
            - text: cluster_name
  outputs:
    - return_result
    - error_message
  results:
    - SUCCESS
    - FAILURE

