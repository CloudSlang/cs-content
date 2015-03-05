#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   get marathon tasks list
#
#   Inputs:
#       - marathon_host - marathon agent host
#       - marathon_port - optional - marathon agent port (defualt 8080)
#       - status - optional - Return only those tasks whose status matches this parameter. If not specified, all tasks are returned. Possible values: running, staging. Default: none.
#       - proxyUsername - optional - user name used when connecting to the proxy
#       - proxyPassword - optional - proxy server password associated with the <proxyUsername> input value
#   Outputs:
#       - return_result - response of the operation
#       - status_code - normal status code is 200
#       - return_code - if returnCode is equal to -1 then there was an error
#       - error_message: returnResult if returnCode is equal to -1 or statusCode different than 200
#   Results:
#       - SUCCESS - operation succeeded (returnCode != '-1' and statusCode == '200')
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.marathon

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
          className: org.openscore.content.httpclient.HttpClientAction
          methodName: execute
      outputs:
        - returnResult
        - statusCode
        - returnCode
        - errorMessage: returnResult if returnCode == '-1' or statusCode != '200' else ''
      results:
        - SUCCESS: returnCode != '-1' and statusCode == '200'
        - FAILURE