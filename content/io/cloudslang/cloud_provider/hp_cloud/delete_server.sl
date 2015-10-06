#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Call to HP Cloud API to terminate a server instance 
#
# Inputs:
#   - server_id - Id of server to be terminated
#   - tenant - Tenant id obtained by get_authenication_flow
#   - token - Auth token obtained by get_authenication_flow
#   - region - HP Cloud region; 'a' or 'b'  (US West or US East) 
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - JSON response
#   - status_code - normal status code is 204
#   - error_message - If error occurs, this contains error in JSON
# Results:
#   - SUCCESS - operation succeeded, server deleted
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud

operation:
  name: delete_server
  inputs:
    - server_id
    - tenant
    - token
    - region  
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxyHost:
        default: "proxy_host if proxy_host else ''"
        overridable: false
    - proxyPort:
        default: "proxy_port if proxy_port else ''"
        overridable: false
    - headers:
        default: "'X-AUTH-TOKEN:' + token"
        overridable: false
    - url:
        default: "'https://region-'+region+'.geo-1.compute.hpcloudsvc.com/v2/' + tenant + '/servers/' + server_id"
        overridable: false
    - method:
        default: "'delete'"
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - return_result: "'' if 'returnResult' not in locals() else returnResult"
    - status_code: statusCode
    - error_message: returnResult if statusCode != '204' else ''
  results:
    - SUCCESS: "'statusCode' in locals() and statusCode == '204'"
    - FAILURE