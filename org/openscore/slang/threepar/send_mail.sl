# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This operation sends an email to a recipient using the SendMailAction from score
#
# Inputs:
# - hostname - The email server host
# - port - The email server port
# - htmlEmail - The value should be true if the email is in rich text/html format. The value should be false if the email is in plain text format.
# - from - The email sender
# - to - The email recipient
# - subject - The email subject
# - body - The email body

# Outputs:
# - returnResult - result of the operation execution
# - statusCode - the statusCode of the operation execution
# - errorMessage: returnResult if statusCode different than '202'
# Results:
# - SUCCESS - operation succeeded
# - FAILURE - otherwise
####################################################
namespace: org.openscore.slang.threepar
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