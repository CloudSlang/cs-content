# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This operation retrieves details for all virtual volumes from a 3PAR server. It is based on HttpClientAction from score
#
# Inputs:
# - host- The 3PAR server host
# - port3Par - The port used for connecting to the 3PAR host
# - sessionKey - The sessionKey used for authentication
# - volumeName - The 3PAR volume to get details from
# - proxyHost - The proxy host used for connecting to the 3PAR host
# - proxyPort - The proxy port associated with the proxy host
# - headers - This input represents the headers for the HTTP request and should not be exposed at flow level. It takes its value as a constant
# - url - This input represents the url for the HTTP request and should not be exposed at flow level. It takes its value as a constant
# - contentType - This input represents the contentType for the HTTP request and should not be exposed at flow level. It takes its value as a constant
# - method - This input represents the HTTP method for the HTTP request and should not be exposed at flow level. It takes its value as a constant

# Outputs:
# - returnResult - response of the operation
# - statusCode - the statusCode of the request
# - errorMessage: returnResult if statusCode different than '202'
# Results:
# - SUCCESS - operation succeeded
# - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.threepar
operations:
    - get_threepar_volumes:
          inputs:
            - host
            - port3Par
            - sessionKey
            - proxyHost
            - proxyPort
            - headers:
                default: "'X-HP3PAR-WSAPI-SessionKey:' + sessionKey"
                override: true
            - url:
                default: "'http://'+ host + ':' + port3Par + '/api/v1/' + 'volumes'"
                override: true
            - contentType:
                default: "'application/json'"
                override: true
            - method:
                default: "'get'"
                override: true
          action:
            java_action:
              className: org.openscore.content.httpclient.HttpClientAction
              methodName: execute
          outputs:            
            - returnResult: returnResult
            - statusCode: statusCode
            - errorMessage: returnResult if statusCode != '202' else ''
          results:
            - SUCCESS : returnResult != '202'
            - FAILURE : 