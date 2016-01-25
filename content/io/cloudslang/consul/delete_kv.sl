#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Deletes a Consul key if the key exists.
#
# Inputs:
#   - host - Consul agent host
#   - consul_port - optional - Consul agent port - Default: '8500'
#   - key_name - name of key to delete
# Outputs:
#   - return_result - response of the operation
#   - error_message: return_result if return_code is equal to '-1' or status_code different than '200'
#   - return_code - if return_code is equal to '-1' then there was an error
#   - status_code - normal status code is '200'
# Results:
#   - SUCCESS - operation succeeded (return_code != '-1' and status_code == '200')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.consul

operation:
  name: delete_kv
  inputs:
    - host
    - consul_port:
        default: "8500"
        required: false
    - key_name
    - url:
        default: ${'http://' + host + ':' + consul_port + '/v1/kv/' + key_name}
        overridable: false
    - method:
        default: "delete"
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - return_result: ${returnResult}
    - error_message: ${returnResult if returnCode == '-1' or statusCode != '200' else ''}
    - return_code: ${returnCode}
    - status_code: ${statusCode}
  results:
    - SUCCESS: ${returnCode != '-1' and statusCode == '200'}
    - FAILURE
