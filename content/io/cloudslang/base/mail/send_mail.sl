#   (c) Copyright 2014-2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Sends an email.
#!
#! @input hostname: Email host.
#! @input port: Email port.
#! @input from: Email sender.
#! @input to: Email recipient.
#! @input cc: Optional - Comma-delimited list of cc recipients.
#!            Default: ''
#! @input bcc: Optional - Comma-delimited list of bcc recipients.
#!             Default: ''
#! @input subject: Email subject.
#! @input body: Email text.
#! @input html_email: Optional
#!                    Default: 'true'
#! @input read_receipt: Optional
#!                      Default: 'false'
#! @input attachments: Optional
#!                     Default: ''
#! @input username: Optional
#!                  Default: ''
#! @input password: Optional
#!                  Default: ''
#! @input character_set: Optional
#!                       Default: 'UTF-8'
#! @input content_transfer_encoding: Optional
#!                                   Default: 'base64'
#! @input delimiter: Optional
#!                   Default: ''
#! @input enable_TLS: Optional - Enable startTLS
#!                    Default: 'false'
#!
#! @output return_code: '0' if success, '-1' otherwise.
#! @output return_result: Success or exception message.
#! @output exception: Possible exception details.
#!
#! @result SUCCESS: Succeeds if mail was sent successfully (returnCode is equal to 0).
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.mail

operation:
  name: send_mail

  inputs:
    - hostname
    - port
    - from
    - to
    - cc:
        required: false
    - bcc:
        required: false
    - subject
    - body
    - html_email:
        required: false
    - htmlEmail:
        default: ${get("html_email", "true")}
        private: true
    - read_receipt:
        required: false
    - readReceipt:
        default: ${get("read_receipt", "false")}
        private: true
    - attachments:
        required: false
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - character_set:
        required: false
    - characterSet:
        default: ${get("character_set", "UTF-8")}
        private: true
    - content_transfer_encoding:
        required: false
    - contentTransferEncoding:
        default: ${get("content_transfer_encoding", "base64")}
        private: true
    - delimiter:
        required: false
    - enable_TLS:
        required: false
    - enableTLS:
        default: ${get("enable_TLS", "")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-mail:0.0.32'
    class_name: io.cloudslang.content.mail.actions.SendMailAction
    method_name: execute

  outputs:
    - return_code: ${returnCode}
    - return_result: ${returnResult}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
