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