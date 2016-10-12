#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Creates an OpenStack server.
#! @input host: OpenStack machine host
#! @input compute_port: optional - port used for OpenStack computations - Default: '8774'
#! @input token: OpenStack token obtained after authentication
#! @input tenant_id: OpenStack tenantID obtained after authentication
#! @input server_name: server name
#! @input proxy_host: optional - proxy server used to access web site
#! @input proxy_port: optional - proxy server port
#! @input img_ref: image reference for server to be created
#! @input network_id: optional - ID of network to connect to
#! @output return_result: response of the operation
#! @output status_code: normal status code is 202
#! @output error_message: returnResult if statusCode != '202'
#! @result SUCCESS: operation succeeded (statusCode == '202')
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.cloud.openstack.servers

operation:
  name: create_server
  inputs:
    - host
    - compute_port: '8774'
    - token:
        sensitive: true
    - tenant_id
    - server_name
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        private: true
        required: false
    - proxyPort:
        default: ${get("proxy_port", "")}
        private: true
        required: false
    - img_ref
    - network_id:
        required: false
    - network:
        default: >
          ${', "networks" : [{"uuid": "' + network_id + '"}]' if network_id else ''}
        private: true
    - headers:
        default: ${'X-AUTH-TOKEN:' + token}
        private: true
    - url:
        default: ${'http://' + host + ':' + compute_port + '/v2/' + tenant_id + '/servers'}
        private: true
    - body:
        default: >
          ${'{"server": { "name": "' + server_name + '" , "imageRef": "' + img_ref +
          '", "flavorRef":"2", "max_count":1, "min_count":1, "security_groups": [ {"name": "default"} ]' +
          network + '}}'}
        private: true
    - contentType:
        default: 'application/json'
        private: true
    - method:
        default: 'post'
        private: true
  java_action:
    gav: 'io.cloudslang.content:score-http-client:0.1.65'
    class_name: io.cloudslang.content.httpclient.HttpClientAction
    method_name: execute
  outputs:
    - return_result: ${returnResult}
    - status_code: ${'' if 'statusCode' not in locals() else statusCode}
    - error_message: ${returnResult if 'statusCode' not in locals() or statusCode != '202' else ''}

  results:
    - SUCCESS: ${'statusCode' in locals() and statusCode == '202'}
    - FAILURE
