#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Delete and release a floating IP
#
# Inputs:
#   - ip_id - Id of floating IP
#   - token - Auth token obtained by get_authenication_flow
#   - region - HP Cloud region; 'a' or 'b'  (US West or US East) 
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - status_code - normal status code is 204
# Results:
#   - SUCCESS - operation succeeded
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud.net

operation:
  name: delete_floating_ip
  inputs:
    - ip_id
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
        default: "'https://region-'+region+'.geo-1.network.hpcloudsvc.com/v2.0/floatingips/' + ip_id"
        overridable: false
    - body:
        default: "''"
        overridable: false
    - contentType:
        default: "'application/json'"
        overridable: false
    - method:
        default: "'delete'"
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - status_code: "'' if 'statusCode' not in locals() else statusCode"
  results:
    - SUCCESS:  "'statusCode' in locals() and statusCode == '204'"
    - FAILURE