#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: This operation sends smtp email.
#!
#! @input hostname: The hostname or ip address of the smtp server.
#! @input port: The port of the smtp service.
#! @input from: From email address.
#! @input to: A delimiter separated list of email address(es) or recipients where the email will be sent.
#! @input cc: Optional - A delimiter separated list of email address(es) or recipients, to be placed in the CC.
#!            Default: ''
#! @input bcc: Optional - A delimiter separated list of email address(es) or recipients, to be placed in the BCC.
#!             Default: ''
#! @input subject: The email subject. If a subject spans on multiple lines, it is formatted to a single one.
#! @input body: The body of the email.
#! @input html_email: The value should be true if the email is in rich text/html format.
#!                    The value should be false if the email is in plain text format.
#!                    Valid values: 'true', 'false'.
#!                    Default: 'true'.
#! @input read_receipt: Optional - The value should be true if read receipt is required, else false.
#!                                 Valid values: 'true', 'false'.
#!                                 Default: 'false'
#! @input attachments: Optional - A delimited separated list of files to attach (must be full path).
#!                     Default: ''
#! @input username: Optional - If SMTP authentication is needed, the username to use.
#!                  Default: ''
#! @input password: Optional - If SMTP authentication is needed, the password to use.
#!                  Default: ''
#! @input character_set: Optional - The character set encoding for the entire email which includes subject, body,
#!                                  attached file name and the attached file.
#!                                  Valid values: 'UTF-8', 'UTF-16', 'UTF-32', 'EUC-JP', 'ISO-2022-JP',
#!                                                'Shift_JIS', 'Windows-31J'.
#!                                  Default: 'UTF-8'
#! @input content_transfer_encoding: Optional - The content transfer encoding scheme (such as 7bit, 8bit, base64,
#!                                              quoted-printable, etc) for the entire email which includes subject,
#!                                              body, attached file name and the attached file.
#!                                              Valid values: 'quoted-printable', 'base64', '7bit',
#!                                                            '8bit', 'binary', 'x-token'.
#!                                              Default: 'base64'
#! @input delimiter: Optional -  A delimiter to separate the email recipients and the attachments.
#!                               Default: ''
#! @input enable_TLS: Optional - Specify if the connection should be TLS enabled or not.
#!                               Default: 'false'
#!
#! @output return_result: That will contain the 'Sent Mail Successfully' if the mail was sent successfully.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output exception: The exception message if the operation goes to failure.
#!
#! @result SUCCESS: Succeeds if mail was sent successfully and the return_code = '0'.
#! @result FAILURE: There was an error while trying to sent the mail and the return code = '-1'.
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
    gav: 'io.cloudslang.content:cs-mail:0.0.38'
    class_name: io.cloudslang.content.mail.actions.SendMailAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
