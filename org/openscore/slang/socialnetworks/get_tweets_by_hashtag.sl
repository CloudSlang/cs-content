namespace: org.openscore.slang.twitter
operations:
    - get_tweets_by_hashtag:
          inputs:
            - startDate    
            - hashTag
            - consumerSecretStr
            - consumerKeyStr
            - accessTokenStr    
            - accessTokenSecretStr
            - proxyHost
            - proxyPort
            - proxyUser
            - proxyPassword            
          action:
            java_action:
              className: org.openscore.content.socialnetworks.actions.TwitterHashTag
              methodName: execute
          outputs:            
            - returnResult: returnResult
            - statusCode: statusCode
            - errorMessage: returnResult if statusCode != '202' else ''
          results:
            - SUCCESS : returnResult != '202'
            - FAILURE : 