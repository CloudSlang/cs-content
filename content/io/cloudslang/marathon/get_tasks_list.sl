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
#   - marathon_port - optional - Marathon agent port - Default: '8080'
#   - status - optional - return only those tasks whose status matches this parameter; if not specified, all tasks are
#                         returned - Valid: running, staging - Default: none
#   - proxy_host - optional - proxy host
#   - proxy_port - optional - proxy port
# Outputs:
#   - return_result - response of the operation
#   - status_code - normal status code is 200
#   - return_code - if returnCode == -1 then there was an error
#   - error_message - returnResult if returnCode == -1 or statusCode != 200
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
        default: "8080"
        required: false
    - status:
        default: "none"
        required: false
    - url:
        default: ${'http://' + marathon_host + ':' + marathon_port + '/v2/tasks?status=' +status}
        overridable: false
    - method:
        default: "get"
        overridable: false
    - contentType:
        default: "application/json"
        overridable: false
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get('proxy_host', None)}
        required: false
    - proxy_port:
            required: false
    - proxyPort:
        default: ${get('proxy_port', None)}
        required: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - return_result: ${returnResult}
    - status_code: ${statusCode}
    - return_code: ${returnCode}
    - error_message: ${returnResult if returnCode == '-1' or statusCode != '200' else ''}
  results:
    - SUCCESS: ${returnCode != '-1' and statusCode == '200'}
    - FAILURE