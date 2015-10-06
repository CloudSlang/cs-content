#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Call to HP Cloud API to create a server instance 
#
# Inputs:
#   - server_name - Name for the new server
#   - img_ref - Image id to use for the new server (operating system)
#   - flavor_ref - Flavor id to set the new server size
#   - keypair - Keypair used to access the new server
#   - tenant - Tenant id obtained by get_authenication_flow
#   - token - Auth token obtained by get_authenication_flow
#   - region - HP Cloud region; 'a' or 'b'  (US West or US East) 
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - JSON response with server details, id etc
#   - status_code - normal status code is 202
#   - error_message: If error occurs, this contains error in JSON
# Results:
#   - SUCCESS - operation succeeded, server created
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud

operation:
  name: create_server
  inputs:
    - server_name
    - img_ref
    - flavor_ref
    - keypair
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
    - network_id:
        required: false
    - network:
        default: >
          ', "networks" : [{"uuid": "' + network_id + '"}]' if network_id else ''
        overridable: false
    - headers:
        default: "'X-AUTH-TOKEN:' + token"
        overridable: false
    - url:
        default: "'https://region-'+region+'.geo-1.compute.hpcloudsvc.com/v2/' + tenant + '/servers'"
        overridable: false
    - body:
        default: >
          '{"server": { "name": "' + server_name + '" , "imageRef": "' + img_ref +
          '", "flavorRef":"'+flavor_ref+'", "key_name":"'+keypair+'", "max_count":1, "min_count":1, "security_groups": [ {"name": "default"} ]' +
          network + '}}'
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
    - error_message: returnResult if 'statusCode' not in locals() or statusCode != '202' else ''

  results:
    - SUCCESS: "'statusCode' in locals() and statusCode == '202'"
    - FAILURE