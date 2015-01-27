namespace: org.openscore.slang.threepar
operations:
    - get_sessionKey:
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