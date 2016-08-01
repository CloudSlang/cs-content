#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Deletes an OpenStack server.
#! @input host: OpenStack machine host
#! @input compute_port: optional - port used for OpenStack computations - Default: '8774'
#! @input token: OpenStack token obtained after authentication
#! @input tenant_id: OpenStack tenantID obtained after authentication
#! @input server_id: ID of server to be deleted
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port
#! @output return_result: response of the operation
#! @output status_code: normal status code is '204'
#! @output error_message: return_result if status_code != '204'
#! @result SUCCESS: operation succeeded (status_code == '204')
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.cloud.openstack.servers

operation:
  name: delete_server
  inputs:
    - host
    - compute_port: '8774'
    - token:
        sensitive: true
    - tenant_id
    - server_id
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
    - headers:
        default: ${'X-AUTH-TOKEN:' + token}
        private: true
    - url:
        default: ${'http://'+ host + ':' + compute_port + '/v2/' + tenant_id + '/servers/' + server_id}
        private: true
    - method:
        default: 'delete'
        private: true
  java_action:
    gav: 'io.cloudslang.content:score-http-client:0.1.65'
    class_name: io.cloudslang.content.httpclient.HttpClientAction
    method_name: execute
  outputs:
    - return_result: ${'' if 'returnResult' not in locals() else returnResult}
    - status_code: ${statusCode}
    - error_message: ${returnResult if statusCode != '204' else ''}
  results:
    - SUCCESS: ${'statusCode' in locals() and statusCode == '204'}
    - FAILURE
