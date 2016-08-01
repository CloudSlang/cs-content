#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Retrieves an unparsed OpenStack authentication token and tenantID.
#! @input host: OpenStack machine host
#! @input identity_port: optional - port used for OpenStack authentication - Default: '5000'
#! @input username: OpenStack username
#! @input password: OpenStack password
#! @input tenant_name: name of project on OpenStack
#! @input proxy_host: optional - proxy server used to access web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @input proxy_username: optional - username used when connecting to proxy
#! @input proxy_password: optional - proxy server password associated with <proxy_username> input value
#! @output return_result: response of operation
#! @output status_code: normal status code is '200'
#! @output return_code: if return_code == -1 then there was an error
#! @output error_message: return_result if return_code ==: 1 or status_code != '200'
#! @result SUCCESS: operation succeeded (return_code != '-1' and status_code == '200')
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.cloud.openstack

operation:
  name: get_authentication
  inputs:
    - host
    - identity_port: '5000'
    - username
    - password:
        sensitive: true
    - tenant_name
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - proxyHost:
        default: ${get("proxy_host", ""}
        private: true
        required: false
    - proxyPort:
        default: ${get("proxy_port", "8080"}
        private: true
    - proxyUsername:
        default: ${get("proxy_username", ""}
        private: true
        required: false
    - proxyPassword:
        default: ${get("proxy_password", ""}
        private: true
        sensitive: true
        required: false
    - url:
        default: ${'http://'+ host + ':' + identity_port + '/v2.0/tokens'}
        private: true
    - body:
        default: >
          ${'{"auth": {"tenantName": "' + tenant_name +
          '","passwordCredentials": {"username": "' + username +
          '", "password": "' + password + '"}}}'}
        private: true
        sensitive: true
    - method:
        default: 'post'
        private: true
    - contentType:
        default: 'application/json'
        private: true
  java_action:
    gav: 'io.cloudslang.content:score-http-client:0.1.65'
    class_name: io.cloudslang.content.httpclient.HttpClientAction
    method_name: execute
  outputs:
    - return_result: ${returnResult}
    - status_code: ${'' if 'statusCode' not in locals() else statusCode}
    - return_code: ${returnCode}
    - error_message: ${returnResult if returnCode == '-1' or statusCode != '200' else ''}
  results:
    - SUCCESS: ${'statusCode' in locals() and returnCode != '-1' and statusCode == '200'}
    - FAILURE
