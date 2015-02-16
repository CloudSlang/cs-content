#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   create consul key name key_name if the key exist update the key.
#
#   Inputs:
#       - host - consul agent host
#       - consul_port - optional - consul agent host port defualt 8500
#       - key_name - name for the new key
#       - key_value - optional - value of new key default is null
#       - flags - optional -flags for new kew sefault is 0
#   Outputs:
#       - returnResult - response of the operation
#       - statusCode - normal status code is 200
#       - returnCode - if returnCode is equal to -1 then there was an error
#       - errorMessage: returnResult if returnCode is equal to -1 or statusCode different than 200
#   Results:
#       - SUCCESS - operation succeeded (returnCode != '-1' and statusCode == '200')
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.consul

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
          className: org.openscore.content.httpclient.HttpClientAction
          methodName: execute
      outputs:
        - returnResult
        - statusCode
        - returnCode
        - errorMessage: returnResult if returnCode == '-1' or statusCode != 200 else ''
      results:
        - SUCCESS: returnCode != '-1' and statusCode == '200'
        - FAILURE