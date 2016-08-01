#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Deletes the cluster, including the Kubernetes endpoint and all worker nodes in Google Container Engine platform
#!               Firewalls and routes that were configured during cluster creation are also deleted.
#!               Note: Google authentication JSON key file downloaded from the Google APIs console is required.
#!               This referred to in GOOGLE_APPLICATION_CREDENTIALS is expected to contain information about credentials that
#!               are ready to use. This means either service account information or user account information with a
#!               ready-to-use refresh token.
#!               Example:
#!               {                                       {
#!                 'type': 'authorized_user',              'type': 'service_account',
#!                 'client_id': '...',                     'client_id': '...',
#!                 'client_secret': '...',       OR        'client_email': '...',
#!                 'refresh_token': '...,                  'private_key_id': '...',
#!               }                                         'private_key': '...',
#!                                                       }
#! @input project_id: The Google Developers Console project ID or project number
#! @input zone: optional - The name of the Google Compute Engine zone in which the cluster resides, or none for all zones
#!              Default: none
#! @input json_google_auth_path: FileSystem path to Google authentication JSON key file
#!                               System Property: io.cloudslang.cloud_provider.json_google_auth_path
#! @input cluster_id: The name of the cluster to delete
#! @output return_result: the response of the operation in case of success, the error message otherwise
#! @output error_message: return_result if return_code is '-1'
#! @output response: jSon response body containing an instance of Operation
#! @output return_code: '0' if success, '-1' otherwise
#! @output cluster_name: cluster name identifier
#!!#
####################################################

namespace: io.cloudslang.cloud.google.gke

operation:
  name: beta_delete_clusters
  inputs:
    - project_id
    - zone:
        default: '-'
        required: false
    - json_google_auth_path: ${get_sp('io.cloudslang.cloud.google.gke.json_google_auth_path')}
    - cluster_id

  python_action:
    script: |
      try:
        import os
        from apiclient import discovery
        from oauth2client.client import GoogleCredentials
        os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = json_google_auth_path
        credentials = GoogleCredentials.get_application_default()
        service = discovery.build('container', 'v1', credentials=credentials)
        request = service.projects().zones().clusters().delete(projectId=project_id, zone=zone, clusterId=cluster_id)
        response = request.execute()
        cluster_name = response['name']

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
    - cluster_name
