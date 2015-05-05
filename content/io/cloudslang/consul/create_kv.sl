#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Creates a Consul key name; if the key exists update the key.
#
# Inputs:
#   - host - Consul agent host
#   - consul_port - optional - Consul agent port - Defualt: 8500
#   - key_name - name for new key
#   - key_value - optional - value for new key - Default: null
#   - flags - optional - flags for new key - Default: 0
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
  name: create_kv
  inputs:
    - host
    - consul_port:
        default: "'8500'"
        required: false
    - key_name
    - key_value:
        default: "''"
        required: false
    - flags:
        default: "'0'"
        required: false
    - body:
        default: "key_value"
        overridable: false
    - url:
        default: "'http://'+ host + ':' + consul_port +'/v1/kv/'+key_name+'?flags='+flags"
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