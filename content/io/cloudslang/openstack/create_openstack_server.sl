#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Creates an OpenStack server.
#
# Inputs:
#   - host - OpenStack machine host
#   - computePort - optional - port used for OpenStack computations - Default: 8774
#   - token - OpenStack token obtained after authentication
#   - tenant - OpenStack tenantID obtained after authentication
#   - serverName - server name
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
#   - imgRef - image reference for server to be created
# Outputs:
#   - return_result - response of the operation
#   - status_code - normal status code is 202
#   - error_message: returnResult if statusCode != '202'
# Results:
#   - SUCCESS - operation succeeded (statusCode == '202')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.openstack

operation:
  name: create_openstack_server
  inputs:
    - host
    - computePort:
        default: "'8774'"
    - token
    - tenant
    - serverName
    - proxy_host:
        default: "''"
    - proxy_port:
        default: "''"
    - proxyHost: "proxy_host if proxy_host != '' else ''"
    - proxyPort: "proxy_port if proxy_port != '' else ''"
    - imgRef
    - networkID:
        default: "''"
    - network:
        default: "',\"networks\": [{\"uuid\": \"'+ networkID + '\"}]' if networkID != '' else ''"
        overridable: false
    - headers:
        default: "'X-AUTH-TOKEN:' + token"
        overridable: false
    - url:
        default: "'http://'+ host + ':' + computePort + '/v2/' + tenant + '/servers'"
        overridable: false
    - body:
        default: "'{\"server\": { \"name\": \"' + serverName + '\" , \"imageRef\": \"' + imgRef + '\", \"flavorRef\":\"2\",\"max_count\":1,\"min_count\":1,\"security_groups\": [ {\"name\": \"default\"}]' + network + '}}'"
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