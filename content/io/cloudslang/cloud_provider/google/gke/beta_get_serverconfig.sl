#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Returns configuration info about the Container Engine service in Google Container Engine platform
#
# Note: Google authentication JSON key file downloaded from the Google APIs console is required.
#       This referred to in GOOGLE_APPLICATION_CREDENTIALS is expected to contain information about credentials
#       that are ready to use. This means either service account information or user account information with a
#       ready-to-use refresh token.
#
#       Example:
#         {                                       {
#            'type': 'authorized_user',              'type': 'service_account',
#            'client_id': '...',                     'client_id': '...',
#            'client_secret': '...',       OR        'client_email': '...',
#            'refresh_token': '...,                  'private_key_id': '...',
#         }                                          'private_key': '...',
#                                                 }
#
# Inputs:
#   - project_id - The Google Developers Console project ID or project number
#   - zone - optional - The name of the Google Compute Engine zone in which the cluster resides, or none for all zones
#   - json_google_auth_path - FileSystem path to Google authentication JSON key file.
#                          Example : C:\\Temp\\cloudslang-026ac0ebb6e0.json
#
# Outputs:
#   - return_result - the response of the operation in case of success, the error message otherwise
#   - error_message - return_result if return_code is not "0"
#   - response - JSON response body containing an instance of Operation
#   - return_code - "0" if success, "-1" otherwise
####################################################

namespace: io.cloudslang.cloud_provider.google.gke

operation:
  name: beta_get_serverconfig
  inputs:
    - project_id
    - zone:
        default: '-'
        required: false
    - json_google_auth_path

  action:
    python_script: |
      try:
        import os
        from apiclient import discovery
        from oauth2client.client import GoogleCredentials
        os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = json_google_auth_path
        credentials = GoogleCredentials.get_application_default()
        service = discovery.build('container', 'v1', credentials=credentials)
        request = service.projects().zones().getServerconfig(projectId=project_id, zone=zone)
        response = request.execute()

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