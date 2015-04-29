#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Sends an HTTP request to create an app.
#
# Inputs:
#   - marathon_host - Marathon agent host
#   - marathon_port - optional - Marathon agent port (defualt 8080)
#   - body - application resource JSON
#   - proxyHost - optional - proxy host - Default: none
#   - proxyPort - optional - proxy port - Default: 8080
# Outputs:
#   - returnResult - response of the operation
#   - statusCode - normal status code is 200
#   - returnCode - if returnCode == -1 then there was an error
#   - errorMessage: returnResult if returnCode == -1 or statusCode != 200
# Results:
#   - SUCCESS - operation succeeded (returnCode != '-1' and statusCode == '200')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.marathon

operation:
  name: send_create_app_req
  inputs:
    - marathon_host
    - marathon_port:
        default: "'8080'"
        required: false
    - body
    - url:
        default: "'http://'+ marathon_host + ':' + marathon_port +'/v2/apps'"
        overridable: false
    - method:
        default: "'post'"
        overridable: false
    - contentType:
        default: "'application/json'"
        overridable: false
    - proxyHost:
        default: "''"
        required: false
    - proxyPort:
        default: "''"
        required: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - returnResult
    - statusCode
    - returnCode
    - errorMessage: returnResult if returnCode == '-1' or statusCode != '201' else ''
  results:
    - SUCCESS: returnCode != '-1' and statusCode == '201'
    - FAILURE