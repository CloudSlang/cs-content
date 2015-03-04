namespace: org.openscore.slang.twitter
imports:
 twitter_content: org.openscore.slang.twitter
flow:
  name: search_tweets_by_hashtag_flow
  inputs:
    - startDate:
        required: false
        default: "''"
    - hashTag
    - consumerSecretStr
    - consumerKeyStr
    - accessTokenStr    
    - accessTokenSecretStr
    - proxyHost
    - proxyPort
    - proxyUser:
        required: false
        default: "''"
    - proxyPassword:
        required: false
        default: "''"
    - emailServerHostname
    - emailServerPort
    - emailTo
  workflow:
    search_tweets_by_hashtag:
      do:
        twitter_content.get_tweets_by_hashtag:
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
      publish:
        - returnResult
      navigate:
        FAILURE: FAILURE
        SUCCESS: send_mail
    send_mail:
      do:
        twitter_content.send_mail:
          - hostname: 'emailServerHostname'
          - port: 'emailServerPort'
          - htmlEmail: "'false'"
          - from: "'ooc@hp.com'"
          - to: 'emailTo'
          - subject: "'Twitter search results'"
          - body: 'returnResult' 
      navigate:
        SUCCESS: printEmail
        FAILURE: printEmail
    printEmail:
      do:
        twitter_content.print:
          - text: 'returnResult'
      navigate:
        SUCCESS: SUCCESS
        FAILURE: FAILURE
  outputs:
    - returnResult
    - errorMessage