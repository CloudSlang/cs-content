#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Call to HP Cloud API to get auth token
#
# Inputs:
#   - username - HP Cloud account username 
#   - password - HP Cloud account password 
#   - tenant_name - Name of HP Cloud tenant e.g. 'bob.smith@hp.com-tenant1'
#   - token - Auth token obtained by get_authenication_flow
#   - region - HP Cloud region; 'a' or 'b'  (US West or US East) 
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - JSON response
#   - status_code - Normal status code is 200
#   - return_code - Return code 
#   - error_message - If error occurs, this contains error in JSON
# Results:
#   - SUCCESS - operation succeeded, token returned
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud

operation:
  name: get_authentication
  inputs:
    - username
    - password
    - tenant_name
    - region
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxyHost:
        default: "proxy_host if proxy_host is not None else ''"
        overridable: false
    - proxyPort:
        default: "proxy_port if proxy_port is not None else ''"
        overridable: false
    - url:
        default: "'https://region-'+region+'.geo-1.identity.hpcloudsvc.com:35357/v2.0/tokens'"
        overridable: false
    - body:
        default: >
          '{"auth": {"tenantName": "' + tenant_name +
          '","passwordCredentials": {"username": "' + username +
          '", "password": "' + password + '"}}}'
        overridable: false
    - method:
        default: "'post'"
        overridable: false
    - contentType:
        default: "'application/json'"
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - return_result: returnResult
    - status_code: "'' if 'statusCode' not in locals() else statusCode"
    - return_code: returnCode
    - error_message: returnResult if returnCode == '-1' or statusCode != 200 else ''
  results:
    - SUCCESS: "'statusCode' in locals() and returnCode != '-1' and statusCode == '200'"
    - FAILURE