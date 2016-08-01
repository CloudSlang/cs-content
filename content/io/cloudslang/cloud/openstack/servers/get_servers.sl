#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Retrieves a list of OpenStack servers.
#! @input host: OpenStack machine host
#! @input compute_port: optional - port used for OpenStack computations - Default: '8774'
#! @input token: OpenStack token obtained after authentication
#! @input tenant_id: OpenStack tenantID obtained after authentication
#! @input proxy_host: optional - proxy server used to access web site
#! @input proxy_port: optional - proxy server port
#! @output return_result: response of operation
#! @output status_code: normal status_code is 202
#! @output error_message: error message
#! @result SUCCESS: operation succeeded (status_code == '200')
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.cloud.openstack.servers

operation:
  name: get_servers
  inputs:
    - host
    - compute_port: '8774'
    - token:
        sensitive: true
    - tenant_id
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
        default: ${'http://'+ host + ':' + compute_port + '/v2/' + tenant_id + '/servers'}
        private: true
    - method:
        default: 'get'
        private: true
  java_action:
    gav: 'io.cloudslang.content:score-http-client:0.1.65'
    class_name: io.cloudslang.content.httpclient.HttpClientAction
    method_name: execute
  outputs:
    - return_result: ${returnResult}
    - status_code: ${statusCode}
    - error_message: ${returnResult if statusCode != '202' else ''}
  results:
    - SUCCESS : ${'statusCode' in locals() and statusCode == '200'}
    - FAILURE
