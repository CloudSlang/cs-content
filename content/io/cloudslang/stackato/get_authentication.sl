#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Retrieves an unparsed Helion Development Platform / Stackato authentication token.
#
# Inputs:
#   - host - Helion Development Platform / Stackato host
#   - username - HDP/Stackato username
#   - password - HDP/Stackato password
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - response of the operation
#   - status_code - normal status code is 200
#   - return_code - if returnCode == -1 then there was an error
#   - error_message: returnResult if returnCode == -1 or statusCode != 200
# Results:
#   - SUCCESS - operation succeeded (returnCode != '-1' and statusCode == '200')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.stackato

operation:
  name: get_authentication
  inputs:
    - host
    - username
    - password
    - url:
        default: "'https://' + host + '/uaa/oauth/token'"
        overridable: false
    - trustAllRoots:
        default: "'true'"
    - queryParams:
        default: "'username=' + username + '&password=' + password + '&grant_type=password'"
    - method:
        default: "'post'"
        overridable: false
    - contentType:
        default: "'application/json'"
        overridable: false
    - headers:
        default: "'Authorization: Basic Y2Y6'"
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
    - return_code: returnCode
    - error_message: returnResult if returnCode == '-1' or statusCode != 200 else ''
  results:
    - SUCCESS: "'statusCode' in locals() and returnCode != '-1' and statusCode == '200'"
    - FAILURE