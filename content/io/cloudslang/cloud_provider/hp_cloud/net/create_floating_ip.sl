#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Create a floating IP bound to the external (public) network
#
# Inputs:
#   - ext_network_id - Id of the external network to get an an IP for
#   - token - Auth token obtained by get_authenication_flow
#   - region - HP Cloud region; 'a' or 'b'  (US West or US East) 
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - JSON response with new IP details
#   - status_code - normal status code is 201
#   - error_message: returnResult if statusCode != 201
# Results:
#   - SUCCESS - operation succeeded
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud.net

operation:
  name: create_floating_ip
  inputs:
    - ext_network_id
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
        default: "'https://region-'+region+'.geo-1.network.hpcloudsvc.com/v2.0/floatingips'"
        overridable: false
    - body:
        default: >
          '{"floatingip": { "floating_network_id": "'+ext_network_id+'" }}'
        overridable: false
    - contentType:
        default: "'application/json'"
        overridable: false
    - method:
        default: "'post'"
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - return_result: returnResult
    - status_code: "'' if 'statusCode' not in locals() else statusCode"
    - error_message: returnResult if 'statusCode' not in locals() or statusCode != '201' else ''

  results:
    - SUCCESS: "'statusCode' in locals() and statusCode == '201'"
    - FAILURE