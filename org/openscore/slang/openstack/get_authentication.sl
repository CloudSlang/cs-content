#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will do a REST call which contains an OpenStack authentication token and tenantID in its response
#   (result needs to be parsed).
#
#   Inputs:
#       - host - OpenStack machine host
#       - identityPort - optional - port used for OpenStack authentication - Default: 5000
#       - username - OpenStack username
#       - password - OpenStack password
#   Outputs:
#       - return_result - response of the operation
#       - status_code - normal status code is 200
#       - return_code - if returnCode is equal to -1 then there was an error
#       - error_message: returnResult if returnCode is equal to -1 or statusCode different than 200
#   Results:
#       - SUCCESS - operation succeeded (returnCode != '-1' and statusCode == '200')
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.openstack

operations:
  - get_authentication:
      inputs:
        - host
        - identityPort:
            default: "'5000'"
        - username
        - password
        - url:
            default: "'http://'+ host + ':' + identityPort + '/v2.0/tokens'"
            override: true
        - body:
            default: "'{\"auth\": {\"tenantName\": \"demo\",\"passwordCredentials\": {\"username\": \"' + username + '\", \"password\": \"' + password + '\"}}}'"
            override: true
        - method:
            default: "'post'"
            override: true
        - contentType:
            default: "'application/json'"
            override: true
      action:
        java_action:
          className: org.openscore.content.httpclient.HttpClientAction
          methodName: execute
      outputs:
        - return_result: returnResult
        - status_code: statusCode
        - return_code: returnCode
        - error_message: returnResult if returnCode == '-1' or statusCode != 200 else ''
      results:
        - SUCCESS: returnCode != '-1' and statusCode == '200'
        - FAILURE