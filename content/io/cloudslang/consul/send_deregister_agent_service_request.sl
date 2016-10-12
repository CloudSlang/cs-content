#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Sends a request to delete an agent service.
#! @input host: Consul agent host
#! @input consul_port: optional - Consul agent host port - Default: '8500'
#! @input service_id: ID of the service to be deregistered
#! @output return_result: response of the operation
#! @output error_message: return_result if return_code is equal to ': 1' or status_code different than '200'
#! @output return_code: if return_code is equal to '-1' then there was an error
#! @output status_code: normal status code is '200'
#! @result SUCCESS: operation succeeded (return_code != '-1' and status_code == '200')
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.consul

operation:
  name: send_deregister_agent_service_request
  inputs:
    - host
    - consul_port:
        default: '8500'
        required: false
    - service_id
    - url:
        default: ${'http://' + host + ':' + consul_port + '/v1/agent/service/deregister/' + service_id}
        private: true
    - method:
        default: 'delete'
        private: true
  java_action:
    gav: 'io.cloudslang.content:score-http-client:0.1.65'
    class_name: io.cloudslang.content.httpclient.HttpClientAction
    method_name: execute
  outputs:
    - return_result: ${returnResult}
    - error_message: ${returnResult if returnCode == '-1' or statusCode != '200' else ''}
    - return_code: ${returnCode}
    - status_code: ${statusCode}
  results:
    - SUCCESS: ${returnCode != '-1' and statusCode == '200'}
    - FAILURE
