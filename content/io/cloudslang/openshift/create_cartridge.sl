#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Creates an embedded cartridge in OpenShift
# NOTE: This is experimental and while the app is created it cannot run yet
# WIP
#
# Inputs:
#   - cartridgeName - cartridge name
#   - applicationName - OpenShift application name
#   - scale - optional - Mark application as scalable. Value : true, false
#   - gear_profile - optional - Size of the gear. Value : small, medium
#   - host - OpenShift host
#   - username - OpenShift username
#   - password - OpenShift username
#   - domain - OpenShift domain
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
#   - timeout - optional - Timeout - Default: 0
# Outputs:
#   - return_result - response of the operation
#   - status_code - normal status code is 202
#   - error_message: returnResult if statusCode != '202'
# Results:
#   - SUCCESS - operation succeeded (statusCode == '202')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.openshift

operation:
  name: create_new_app
  inputs:
    - cartridgeName:
        required: true
    - scales_from:
        required: false
    - scales_to:
        required: false
    - gear_size:
        required: true
    - additional_storage:
        required: false
    - host:
        required: true
    - username:
        required: true
    - password:
        required: true
    - domain:
        required: true
    - url:
        default: "'https://' + host + '/broker/rest/domain/' + domain + '/applications'"
        overridable: false
    - headers:
        default: "'Accept: application/json'"
        overridable: false
    - body:
        default: >
          '{ "name": "' + cartridgeName + '" , "gear_size": "' + gear_size + '"}'
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
    - error_message: returnResult if 'statusCode' not in locals() or statusCode != '201' else ''

  results:
    - SUCCESS: "'statusCode' in locals() and statusCode == '201'"
    - FAILURE