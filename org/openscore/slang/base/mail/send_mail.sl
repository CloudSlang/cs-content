#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation sends a simple email.
#   Inputs:
#       - hostname - Email host
#       - port - Email port
#       - from - Email sender
#       - to - Email recipient
#       - cc - optional - Default: none
#       - bcc - optional - Default: none
#       - subject - Email subject
#       - body - Email text
#       - htmlEmail - optional - Default: true
#       - readReceipt - optional - Default false
#       - attachments - optional - Default none
#       - username - optional - Default: none
#       - password - optional - Default none
#       - characterSet - optional - Default UTF-8
#       - contentTransferEncoding - optional - Default base64
#       - delimiter - optional - default none
#   Results:
#       - SUCCESS - succeeds if mail was sent successfully (returnCode is equal to 0)
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.base.mail

operations:
  - send_mail:
      inputs:
        - hostname
        - port
        - from
        - to
        - cc:
            default: "''"
            required: false
        - bcc:
            default: "''"
            required: false
        - subject
        - body
        - htmlEmail:
            default: "'true'"
            required: false
        - readReceipt:
            default: "'false'"
            required: false
        - attachments:
            default: "''"
            required: false
        - username:
            default: "''"
            required: false
        - password:
            default: "''"
            required: false
        - characterSet:
            default: "'UTF-8'"
            required: false
        - contentTransferEncoding:
            default: "'base64'"
            required: false
        - delimiter:
            default: "''"
            required: false
      action:
        java_action:
          className: org.openscore.content.mail.actions.SendMailAction
          methodName: execute
      results:
        - SUCCESS: returnCode == '0'
        - FAILURE