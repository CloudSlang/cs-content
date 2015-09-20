#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Start a cartridge in OpenShift
#
# Inputs:
#   - ApplicationId - OpenShift Application Identifier. Example : 55f771c589f5cffd48000015
#   - cartridgeName - OpenShift cartridge Name. 
#   - host - OpenShift host
#   - username - OpenShift username
#   - password - OpenShift username
#   - domain - OpenShift domain
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
#   - timeout - optional - Timeout - Default: 0
# Outputs:
#   - return_result - response of the operation
#   - status_code - normal status code is 200
#   - error_message: returnResult if statusCode != '200'
# Results:
#   - SUCCESS - operation succeeded (statusCode == '200')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.openshift

operation:
  name: start_cartridge
  inputs:
    - applicationId:
        required: true
    - cartridgeName:
        required: true
    - host:
        required: true
    - username:
        required: true
    - password:
        required: true
    - statusApp:
        default: "'start'"
    - url:
        default: "'https://' + host + '/broker/rest/application/' + applicationId + '/cartridge/' + cartridgeName + '/events'"
        overridable: false
    - headers:
        default: "'Accept: application/json'"
        overridable: false
    - body:
        default: >
          '{"event": "' + statusApp + '"}'
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
    - timeout:
        default: "0"
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - return_result: returnResult
    - status_code: "'' if 'statusCode' not in locals() else statusCode"
    - error_message: returnResult if 'statusCode' not in locals() or statusCode != '200' else ''

  results:
    - SUCCESS: "'statusCode' in locals() and statusCode == '200'"
    - FAILURE