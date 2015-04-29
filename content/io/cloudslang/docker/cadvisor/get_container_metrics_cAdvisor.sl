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
#   - cadvisor_port - optional - port used for cAdvisor - Default: 8080
#   - container - name or ID of the Docker container that runs cAdvisor
# Outputs:
#   - returnResult - unparsed response of the operation
#   - statusCode - normal status code is 200
#   - returnCode - if returnCode == -1 then there was an error
#   - errorMessage: returnResult if returnCode == -1 or statusCode != 200
# Results:
#   - SUCCESS - operation succeeded (returnCode != '-1' and statusCode == '200')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.docker.cadvisor

operation:
  name: get_container_metrics_cAdvisor
  inputs:
    - host
    - cadvisor_port:
        default: "'8080'"
        required: false
    - container
    - url:
        default: "'http://'+ host + ':' + cadvisor_port +'/api/v1.2/docker/'+container"
        overridable: false
    - method:
        default: "'get'"
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - returnResult
    - statusCode
    - returnCode
    - errorMessage: returnResult if returnCode == '-1' or statusCode != 200 else ''
  results:
    - SUCCESS: returnCode != '-1' and statusCode == '200'
    - FAILURE