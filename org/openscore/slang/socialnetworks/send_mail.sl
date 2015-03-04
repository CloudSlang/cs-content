namespace: org.openscore.slang.twitter
operations:
    - send_mail:
          inputs:
            - hostname
            - port
            - htmlEmail
            - from
            - to
            - subject
            - body            
          action:
            java_action:
              className: org.openscore.content.mail.actions.SendMailAction
              methodName: execute
          outputs:            
            - returnResult: returnResult
            - statusCode: statusCode
            - errorMessage: returnResult if statusCode != '202' else ''
          results:
            - SUCCESS : returnResult != '202'
            - FAILURE : 