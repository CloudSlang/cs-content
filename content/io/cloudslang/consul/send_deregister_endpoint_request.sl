#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Send a request to delete end point.
#
# Inputs:
#   - host - Consul agent host
#   - consul_port - optional - Consul agent host port - Defualt: 8500
#   - json_request - the request JSON
# Outputs:
#   - returnResult - response of the operation
#   - statusCode - normal status code is 200
#   - returnCode - if returnCode is equal to -1 then there was an error
#   - errorMessage: returnResult if returnCode is equal to -1 or statusCode different than 200
# Results:
#   - SUCCESS - operation succeeded (returnCode != '-1' and statusCode == '200')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.consul

operation:
  name: send_deregister_endpoint_request
  inputs:
    - host
    - consul_port:
        default: "'8500'"
        required: false
    - json_request
    - body:
        default: "json_request"
        overridable: false
    - url:
        default: "'http://'+ host + ':' + consul_port +'/v1/catalog/deregister'"
        overridable: false
    - method:
        default: "'put'"
        overridable: false
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