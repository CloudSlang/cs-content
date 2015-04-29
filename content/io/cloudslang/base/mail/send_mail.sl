#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Sends an email.
#
# Inputs:
#   - hostname - email host
#   - port - email port
#   - from - email sender
#   - to - email recipient
#   - cc - optional - Default: none
#   - bcc - optional - Default: none
#   - subject - email subject
#   - body - email text
#   - htmlEmail - optional - Default: true
#   - readReceipt - optional - Default: false
#   - attachments - optional - Default: none
#   - username - optional - Default: none
#   - password - optional - Default: none
#   - characterSet - optional - Default: UTF-8
#   - contentTransferEncoding - optional - Default: base64
#   - delimiter - optional - Default: none
# Results:
#   - SUCCESS - succeeds if mail was sent successfully (returnCode is equal to 0)
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.base.mail

operation:
  name: send_mail
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
      className: io.cloudslang.content.mail.actions.SendMailAction
      methodName: execute
  results:
    - SUCCESS: returnCode == '0'
    - FAILURE