#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will do a REST call to cAdvisor runs in a docker container its response
#   (result needs to be parsed).
#
#   Inputs:
#       - host - docker machine host
#       - identityPort - optional - port used for cAdvisor - Default: 8080
#       - container - name or ID of the Docker container that runs cAdvisor
#   Outputs:
#       - returnResult - response of the operation
#       - statusCode - normal status code is 200
#       - returnCode - if returnCode is equal to -1 then there was an error
#       - errorMessage: returnResult if returnCode is equal to -1 or statusCode different than 200
#   Results:
#       - SUCCESS - operation succeeded (returnCode != '-1' and statusCode == '200')
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.docker.maintenance

operations:
  - get_container_metrics_cAdvisor:
      inputs:
        - host
        - identityPort:
            default: "'8080'"
            required: false
        - container
        - url:
            default: "'http://'+ host + ':' + identityPort +'/api/v1.2/docker/'+container"
            override: true
        - method:
            default: "'get'"
            override: true
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