#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   sent http request to create app
#
#   Inputs:
#       - marathon_host - marathon agent host
#       - marathon_port - optional - marathon agent port (defualt 8080)
#       - body - JSON format of an application resource
#       - proxyHost - optional - proxy server used to access the web site
#       - proxyPort - optional - proxy server port - Default: 8080
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
        - errorMessage: returnResult if returnCode == '-1' or statusCode != '201' else ''
      results:
        - SUCCESS: returnCode != '-1' and statusCode == '201'
        - FAILURE