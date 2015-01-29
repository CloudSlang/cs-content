# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This operation creates a new sessionKey for the 3PAR credentials supplied. It is based on HttpClientAction from score
#
# Inputs:
# - host- The 3PAR server host
# - port3Par - The port used for connecting to the 3PAR host
# - username - The 3PAR username to get a sessionKey for. 
# - password - The password associated with the username
# - proxyHost - The proxy host used for connecting to the 3PAR host
# - proxyPort - The proxy port associated with the proxy host
# - url - This input represents the url for the HTTP request and should not be exposed at flow level. It takes its value as a constant
# - body - This input represents the body of the HTTP POST request and should not be exposed at flow level. It takes its value as a constant
# - contentType - This input represents the contentType for the HTTP request and should not be exposed at flow level. It takes its value as a constant
# - method - This input represents the HTTP method for the HTTP request and should not be exposed at flow level. It takes its value as a constant

# Outputs:
# - sessionKey - The newly created 3PAR session key
# - returnResult - response of the operation
# - statusCode - the statusCode of the request
# - errorMessage: returnResult if statusCode different than '202'
# Results:
# - SUCCESS - operation succeeded
# - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.threepar
operations:
    - get_session_key:
          inputs:
            - host
            - port3Par
            - username
            - password
            - proxyHost
            - proxyPort
            - url:
                default: "'http://'+ host + ':' + port3Par + '/api/v1/credentials'"
                override: true
            - body:
                default: "'{ \"user\": \"' + username + '\" , \"password\": \"' + password + '\"}'"
                override: true
            - contentType:
                default: "'application/json'"
                override: true
            - method:
                default: "'post'"
                override: true
          action:
            java_action:
              className: org.openscore.content.httpclient.HttpClientAction
              methodName: execute
          outputs:            
            - sessionKey: "returnResult.replace('}', ' ').replace('\"','').split(':')[1]"
            - returnResult: returnResult
            - statusCode: statusCode
            - errorMessage: returnResult if statusCode != '202' else ''
          results:
            - SUCCESS : returnResult != '202'
            - FAILURE : 