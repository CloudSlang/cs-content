#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Creates an application in Helion Development Platform / Stackato
# NOTE: This is experimental and while the app is created it cannot run yet
# WIP
#
# Inputs:
#   - host - Helion Development Platform / Stackato host
#   - token - HDP / Stackato authorisation token
#   - name - Name of the application to create
#   - space_guid - GUID of the HDP / Stackato space to deploy to
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - response of the operation
#   - status_code - normal status code is 202
#   - error_message: returnResult if statusCode != '202'
# Results:
#   - SUCCESS - operation succeeded (statusCode == '202')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.stackato

operation:
  name: create_new_app
  inputs:
    - name
    - space_guid
    - host
    - token
    - headers:
        default: "'Authorization: bearer ' + token"
        overridable: false
    - url:
        default: "'https://' + host + '/v2/apps'"
        overridable: false
    - body:
        default: >
          '{ "name": "' + name + '" , "space_guid": "' + space_guid +
          '",  "memory":1024, "instances":1}'
        overridable: false
    - contentType:
        default: "'application/json'"
        overridable: false
    - trustAllRoots:
        default: "'true'"
    - method:
        default: "'post'"
        overridable: false
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