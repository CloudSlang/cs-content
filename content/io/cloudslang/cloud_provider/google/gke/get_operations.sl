#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow Gets the specified operation.
#
# Note : Google Authentitification json key file downloaded from the Google APIs console is required. This referred to in GOOGLE_APPLICATION_CREDENTIALS is 
# expected to contain information about credentials that are ready to use. This means either service account information or user account information with 
# a ready-to-use refresh token:
#       {                                       {
#          'type': 'authorized_user',              'type': 'service_account',
#          'client_id': '...',                     'client_id': '...',
#          'client_secret': '...',       OR        'client_email': '...',
#          'refresh_token': '...,                  'private_key_id': '...',
#      }                                           'private_key': '...',
#                                              }
#
# Inputs:
#   - projectId - The Google Developers Console project ID or project number
#   - zone - optional - The name of the Google Compute Engine zone in which the cluster resides, or none for all zones
#   - jSonGoogleAuthPath - FileSystem Path to Google Authentitification json key file. Example : C:\\Temp\\cloudslang-026ac0ebb6e0.json
#   - operationId - The server-assigned name of the operation.
# Outputs:
#   - return_code - "0" if success, "-1" otherwise
#   - return_result - the response of the operation in case of success, the error message otherwise
#   - reponse - jSon response body containing an instance of Operation
#   - error_message - return_result if return_code is not "0"
####################################################

namespace: io.cloudslang.cloud_provider.google.gke

operation:
  name: get_operations
  inputs:
    - projectId:
        required: true
    - zone:
        required: true
    - jSonGoogleAuthPath:
        required: true
    - operationId:
        required: true
  action:
    python_script: |
            try:
                import os
                from apiclient import discovery
                from oauth2client.client import GoogleCredentials
                os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = jSonGoogleAuthPath
                credentials = GoogleCredentials.get_application_default()
                service = discovery.build('container', 'v1', credentials=credentials)
                request = service.projects().zones().operations().get(projectId=projectId,zone=zone,operationId=operationId)
                response = request.execute()
                return_code = '0'
                return_result = 'Success'
            except: 
                return_code = '-1'
                return_result = 'Error'
  outputs:
    - return_code
    - return_result
    - response
    - error_message: return_result if return_code == '-1' else ''