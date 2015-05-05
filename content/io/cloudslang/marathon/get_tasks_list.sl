#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Retrieves a list of Marathon tasks.
#
# Inputs:
#   - marathon_host - Marathon agent host
#   - marathon_port - optional - Marathon agent port - Defualt: 8080
#   - status - optional - return only those tasks whose status matches this parameter; if not specified, all tasks are returned - Valid: running, staging - Default: none
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
  name: get_tasks_list
  inputs:
    - marathon_host
    - marathon_port:
        default: "'8080'"
        required: false
    - status:
        default: "'none'"
        required: false
    - url:
        default: "'http://'+ marathon_host + ':' + marathon_port +'/v2/tasks?status='+status"
        overridable: false
    - method:
        default: "'get'"
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