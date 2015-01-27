namespace: flow.actions
# imports:
operations:
  - findMyPublicIp:
      inputs:
        - url: "'http://bot.whatismyipaddress.com/'"
        - method: "'GET'"
        - proxyHost:
            required: false
        - proxyPort:
            required: false
      action:
        java_action:
          className: org.openscore.content.httpclient.HttpClientAction
          methodName: execute
      outputs:
        - returnResult: returnResult
        - returnCode: returnCode
      results:
        - SUCCESS