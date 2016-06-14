#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Sends an HTTP request to create a Marathon app.
#! @input marathon_host: Marathon agent host
#! @input marathon_port: optional - Marathon agent port - Default: 8080
#! @input body: application resource JSON
#! @input proxy_host: optional - proxy host
#! @input proxy_port: optional - proxy port
#! @output return_result: response of the operation
#! @output status_code: normal status code is 200
#! @output return_code: if return_code == -1 then there was an error
#! @output error_message: return_result if return_code == -1 or status_code != 200
#! @result SUCCESS: operation succeeded (return_code != '-1' and status_code == '200')
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.marathon

operation:
  name: send_create_app_req
  inputs:
    - marathon_host
    - marathon_port:
        default: "8080"
        required: false
    - body
    - url:
        default: ${'http://'+ marathon_host + ':' + marathon_port +'/v2/apps'}
        private: true
    - method:
        default: "post"
        private: true
    - contentType:
        default: "application/json"
        private: true
    - proxy_host:
        required: false
        sensitive: true
    - proxyHost:
        default: ${get('proxy_host', None)}
        required: false
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get('proxy_port', None)}
        required: false
        
  java_action:
    gav: 'io.cloudslang.content:score-http-client:0.1.65'
    class_name: io.cloudslang.content.httpclient.HttpClientAction
    method_name: execute
  outputs:
    - return_result: ${returnResult}
    - status_code: ${statusCode}
    - return_code: ${returnCode}
    - error_message: ${returnResult if returnCode == '-1' or statusCode != '201' else ''}
  results:
    - SUCCESS: ${returnCode != '-1' and statusCode == '201'}
    - FAILURE
