#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Deletes an app.
#
# Inputs:
#   - marathon_host - Marathon agent host
#   - marathon_port - optional - Marathon agent port - Defualt: 8080
#   - appId - app ID to delete
#   - proxyHost - optional - proxy host - Default: none
#   - proxyPort - optional - proxy port - Default: 8080
# Outputs:
#   - returnResult - response of the operation
#   - statusCode - normal status code is 200
#   - returnCode - if returnCode is equal to -1 then there was an error
#   - errorMessage: returnResult if returnCode is equal to -1 or statusCode different than 200
# Results:
#   - SUCCESS - operation succeeded (returnCode != '-1' and statusCode == '200')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.marathon

operation:
  name: delete_app
  inputs:
    - marathon_host
    - marathon_port:
        default: "'8080'"
        required: false
    - app_id
    - url:
        default: "'http://'+ marathon_host + ':' + marathon_port +'/v2/apps/'+app_id"
        overridable: false
    - method:
        default: "'delete'"
        overridable: false
    - contentType:
        default: "'application/json'"
        overridable: false
    - proxyHost:
        default: "''"
        required: false
    - proxyPort:
        default: "'8080'"
        required: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - returnResult
    - statusCode
    - returnCode
    - errorMessage: returnResult if returnCode == '-1' or statusCode != '200' else ''
  results:
    - SUCCESS: returnCode != '-1' and statusCode == '200'
    - FAILURE