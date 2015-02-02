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
#       - returnResult - response of the operation
#       - statusCode - normal status code is 200
#       - returnCode - if returnCode is equal to -1 then there was an error
#       - errorMessage: returnResult if returnCode is equal to -1 or statusCode different than 200
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
            required: false
        - username
        - password
        - url:
            default: "'http://'+ host + ':' + identityPort + '/v2.0/tokens'"
            overridable: false
        - body:
            default: "'{\"auth\": {\"tenantName\": \"demo\",\"passwordCredentials\": {\"username\": \"' + username + '\", \"password\": \"' + password + '\"}}}'"
            overridable: false
        - method:
            default: "'post'"
            overridable: false
        - contentType:
            default: "'application/json'"
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