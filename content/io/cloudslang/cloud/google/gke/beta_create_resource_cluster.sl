#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Creates a Google Container Engine resource cluster.
#!               More information on https://cloud.google.com/container-engine/reference/rest/v1/projects.zones.clusters#Cluster
#! @input zone: optional - The name of the Google Compute Engine zone in which the cluster resides, or none for all zones
#!              Default: none
#! @input name: The name of the cluster to delete
#! @input description: An optional description of this cluster
#! @input initial_node_count: The number of nodes to create in this cluster. You must ensure that your Compute Engine
#!                            resource quota is sufficient for this number of instances. You must also have available
#!                            firewall and routes quota
#! @input machine_type:
#! @input disk_size_gb:
#! @input oauth_scopes:
#! @input masterauth_username:
#! @input masterauth_password:
#! @input logging_service:
#! @input monitoring_service:
#! @input network:
#! @input cluster_ipv4_cidr:
#! @input self_link:
#! @input endpoint:
#! @input initial_cluster_version:
#! @input current_master_version:
#! @input current_node_version:
#! @input create_time:
#! @input status:
#! @input status_message:
#! @input node_ipv4_cidr_size:
#! @input services_ipv4_cidr:
#! @output return_result: the response of the operation in case of success, the error message otherwise
#! @output error_message: return_result if return_code is '-1'
#! @output response: JSON response body containing an instance of Operation
#! @output return_code: '0' if success, '-1' otherwise
#!!#
####################################################

namespace: io.cloudslang.cloud.google.gke

operation:
  name: beta_create_resource_cluster
  inputs:
    - zone:
        required: false
    - name
    - description:
        required: false
    - initial_node_count
    - machine_type:
        required: false
    - disk_size_gb:
        required: false
    - oauth_scopes:
        required: false
    - masterauth_username
    - masterauth_password:
        sensitive: true
    - logging_service:
        required: false
    - monitoring_service:
        required: false
    - network:
        required: false
    - cluster_ipv4_cidr:
        required: false
    - self_link:
        required: false
    - endpoint:
        required: false
    - initial_cluster_version:
        required: false
    - current_master_version:
        required: false
    - current_node_version:
        required: false
    - create_time:
        required: false
    - status:
        required: false
    - status_message:
        required: false
    - node_ipv4_cidr_size:
        required: false
    - services_ipv4_cidr:
        required: false

  python_action:
    script: |
      try:
        import json

        json_main = {}
        json_body = {}
        json_nodeconfig = {}
        json_masterauth = {}

        if machine_type:
          json_nodeconfig['machineType'] = machine_type
        if disk_size_gb:
          json_nodeconfig['diskSizeGb'] = disk_size_gb
        if oauth_scopes:
          json_nodeconfig['oauthScopes'] = oauth_scopes

        if masterauth_username:
          json_masterauth['username'] = masterauth_username
        if masterauth_password:
          json_masterauth['password'] = masterauth_password

        if name:
          json_body['name'] = name
        if zone:
          json_body['zone'] = zone
        if description:
          json_body['description'] = description
        if initial_node_count:
          json_body['initial_node_count'] = initial_node_count
        if logging_service:
          json_body['loggingService'] = logging_service
        if monitoring_service:
          json_body['monitoringService'] = monitoring_service
        if network:
          json_body['network'] = network
        if cluster_ipv4_cidr:
          json_body['clusterIpv4Cidr'] = cluster_ipv4_cidr
        if self_link:
          json_body['selfLink'] = self_link
        if endpoint:
          json_body['endpoint'] = endpoint
        if initial_cluster_version:
          json_body['initialClusterVersion'] = initial_cluster_version
        if current_master_version:
          json_body['currentMasterVersion'] = current_master_version
        if current_node_version:
          json_body['currentNodeVersion'] = current_node_version
        if create_time:
          json_body['createTime'] = create_time
        if status:
          json_body['status'] = status
        if status_message:
          json_body['statusMessage'] = status_message
        if node_ipv4_cidr_size:
          json_body['nodeIpv4CidrSize'] = node_ipv4_cidr_size
        if services_ipv4_cidr:
          json_body['servicesIpv4Cidr'] = services_ipv4_cidr

        if json_nodeconfig:
          json_body['nodeConfig'] = json_nodeconfig
        if json_masterauth:
          json_body['masterAuth'] = json_masterauth
        json_main['cluster'] = json_body

        response = json.dumps(json_main, sort_keys=True)

        return_result = 'Success'
        return_code = '0'
      except:
        return_result = 'An error occurred.'
        return_code = '-1'

  outputs:
    - return_result
    - error_message: ${return_result if return_code == '-1' else ''}
    - response
    - return_code
