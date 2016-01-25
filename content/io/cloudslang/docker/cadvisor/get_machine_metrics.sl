#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Performs a REST call to cAdvisor running in a Docker container.
#
# Inputs:
#   - host - Docker machine host
#   - cadvisor_port - optional - port used for cAdvisor - Default: '8080'
# Outputs:
#   - return_result - response of the operation
#   - error_message: return_result if return_code == '-1' or status_code != '200'
#   - return_code - if return_code == '-1' then there was an error
#   - status_code - normal status code is '200'
# Results:
#   - SUCCESS - operation succeeded (return_code != '-1' and status_code == '200')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.docker.cadvisor

operation:
  name: get_machine_metrics
  inputs:
    - host
    - cadvisor_port:
        default: '8080'
        required: false
    - url:
        default: "${'http://' + host + ':' + cadvisor_port + '/api/v1.2/machine'}"
        overridable: false
    - method:
        default: 'get'
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
