#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   get marathon apps list
#
#   Inputs:
#       - marathon_host - marathon agent host
#       - marathon_port - optional - marathon agent port (defualt 8080)
#       - embed - optional - Embeds nested resources that match the supplied path. Default: none. Possible values:
#                           "apps.tasks". Apps' tasks are not embedded in the response by default.
#                            "apps.failures". Apps' last failures are not embedded in the response by default.
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
      name: get_apps_list
      inputs:
        - marathon_host
        - marathon_port:
            default: "'8080'"
            required: false
        - cmd:
            default: "''"
            required: false
        - embed:
            default: "'none'"
            required: false
        - url:
            default: "'http://'+ marathon_host + ':' + marathon_port +'/v2/apps?embed='+embed"
            overridable: false
        - proxyHost:
            default: "''"
            required: false
        - proxyPort:
            default: "'8080'"
            required: false
        - method:
            default: "'get'"
            overridable: false
        - contentType:
            default: "'application/json'"
            overridable: false
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