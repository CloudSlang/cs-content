#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will do a REST call which contains an OpenStack authentication token and tenantID in its response
#   (result needs to be parsed)
#
#   Inputs:
#       - host - OpenStack machine IP
#       - identityPort - optional - Port used for OpenStack authentication - Default: 5000
#       - username - OpenStack username
#       - password - OpenStack password
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
        - returnResult
        - statusCode
        - returnCode
        - errorMessage: returnResult if returnCode == '-1' or statusCode != 200 else ''
      results:
        - SUCCESS: returnCode != '-1' and statusCode == '200'
        - FAILURE