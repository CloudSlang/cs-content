#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow creates a Google Container Engine resource cluster. More information on https://cloud.google.com/container-engine/reference/rest/v1/projects.zones.clusters#Cluster
#
#
# Inputs:
#   - projectId - The Google Developers Console project ID or project number
#   - zone - optional - The name of the Google Compute Engine zone in which the cluster resides, or none for all zones
#   - jSonGoogleAuthPath - FileSystem Path to Google Authentitification json key file. Example : C:\\Temp\\cloudslang-026ac0ebb6e0.json
#   - name - The name of the cluster to delete
#   - description - An optional description of this cluste
#   - initialNodeCount - The number of nodes to create in this cluster. You must ensure that your Compute Engine resource quota is sufficient for this number of instances. You must also have available firewall and routes quota
#   - machineType
#   - diskSizeGb
#   - oauthScopes
#   - masterauthUsername
#   - masterauthPassword
#   - loggingService
#   - monitoringService
#   - network
#   - clusterIpv4Cidr
#   - selfLink
#   - endpoint
#   - initialClusterVersion
#   - currentMasterVersion
#   - currentNodeVersion
#   - createTime
#   - status
#   - statusMessage
#   - nodeIpv4CidrSize
#   - servicesIpv4Cidr
# Outputs:
#   - return_code - "0" if success, "-1" otherwise
#   - return_result - the response of the operation in case of success, the error message otherwise
#   - reponse - jSon response body containing an instance of Operation
#   - error_message - return_result if return_code is not "0"
####################################################

namespace: io.cloudslang.cloud_provider.google.gke

operation:
  name: create_resource_cluster
  inputs:
    - zone:
        required: false
    - name:
        required: true
    - description:
        required: false
    - initialNodeCount:
        required: true
    - machineType:
        required: false
    - diskSizeGb:
        required: false
    - oauthScopes:
        required: false
    - masterauthUsername:
        required: true
    - masterauthPassword:
        required: true
    - loggingService:
        required: false
    - monitoringService:
        required: false
    - network:
        required: false
    - clusterIpv4Cidr:
        required: false
    - selfLink:
        required: false
    - endpoint:
        required: false
    - initialClusterVersion:
        required: false
    - currentMasterVersion:
        required: false
    - currentNodeVersion:
        required: false
    - createTime:
        required: false
    - status:
        required: false
    - statusMessage:
        required: false
    - nodeIpv4CidrSize:
        required: false
    - servicesIpv4Cidr:
        required: false
  action:
    python_script: |
                import json

                json_main = {}
                json_body = {}
                json_nodeconfig = {}
                json_masterauth = {}

                if machineType:
                    json_nodeconfig['machineType'] = machineType
                if diskSizeGb:
                    json_nodeconfig['diskSizeGb'] = diskSizeGb
                if oauthScopes:
                    json_nodeconfig['oauthScopes'] = oauthScopes

                if masterauthPassword:
                    json_masterauth['password'] = masterauthPassword
                if masterauthUsername:
                    json_masterauth['username'] = masterauthUsername

                if name:
                    json_body['name'] = name
                if zone:
                    json_body['zone'] = zone
                if description:
                    json_body['description'] = description
                if initialNodeCount:
                    json_body['initialNodeCount'] = initialNodeCount
                if loggingService:
                    json_body['loggingService'] = loggingService
                if monitoringService:
                    json_body['monitoringService'] = monitoringService
                if network:
                    json_body['network'] = network
                if clusterIpv4Cidr:
                    json_body['clusterIpv4Cidr'] = clusterIpv4Cidr
                if selfLink:
                    json_body['selfLink'] = selfLink
                if endpoint:
                    json_body['endpoint'] = endpoint
                if initialClusterVersion:
                    json_body['initialClusterVersion'] = initialClusterVersion
                if currentMasterVersion:
                    json_body['currentMasterVersion'] = currentMasterVersion
                if currentNodeVersion:
                    json_body['currentNodeVersion'] = currentNodeVersion
                if createTime:
                    json_body['createTime'] = createTime
                if status:
                    json_body['status'] = status
                if statusMessage:
                    json_body['statusMessage'] = statusMessage
                if nodeIpv4CidrSize:
                    json_body['nodeIpv4CidrSize'] = nodeIpv4CidrSize
                if servicesIpv4Cidr:
                    json_body['servicesIpv4Cidr'] = servicesIpv4Cidr

                if json_nodeconfig:
                    json_body['nodeConfig'] = json_nodeconfig
                if json_masterauth:
                    json_body['masterAuth'] = json_masterauth
                json_main['cluster'] = json_body

                with open('c:\Temp\json.txt', 'w') as json_file:
                    json.dump(json_main, json_file)

                response = json.dumps(json_main, sort_keys=True)
                return_code = '0'
                return_result = 'Success'
  outputs:
    - return_code
    - return_result
    - response
    - error_message: return_result if return_code == '-1' else ''
  results:
    - SUCCESS: return_code == '0'
    - FAILURE