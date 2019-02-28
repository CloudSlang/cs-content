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
#! @description: This operation is used to get the contents of a mail message. Inline attachments are not supported by
#!               this operation.
#!
#! @input host: The email host.
#! @input port: The port to connect to on host (normally 110 for POP3, 143 for IMAP4).
#!              This input can be left empty if the "protocol" value is "pop3" or "imap4": for "pop3"
#!              this input will be completed by default with 110, for "imap4", this input will be
#!              completed by default with 143.
#!              Default: '993'
#! @input protocol: Optional - The protocol to connect with. This input can be left empty if the port value is provided:
#!                             if the provided port value is 110, the pop3 protocol will be used by default,
#!                             if the provided port value is 143, the imap4 protocol will be used by default.
#!                             For other values for the "port" input, the protocol should be also specified.
#!                             Valid values: 'pop3', 'imap4', 'imap'.
#!                             Default: 'imap'
#! @input username: The username for the mail host. Use the full email address as username.
#! @input password: The password for the mail host.
#! @input folder: Optional - The folder to read the message from (NOTE: POP3 only supports "INBOX").
#!                           Default: 'INBOX'
#! @input trust_all_roots: Optional - Specifies whether to trust all SSL certificate authorities. This input is ignored
#!                                    if the enable_SSL input is set to false. If false, make sure to have the
#!                                    certificate installed. The steps are explained at the end of inputs description.
#!                                    Valid values: 'true', 'false'.
#!                                    Default: 'false'.
#! @input message_number: The number (starting at 1) of the message to retrieve.  Email ordering is a server
#!                        setting that is independent of the client.
#! @input subject_only:  A boolean value. If true, only subjects are retrieved instead of the entire message.
#!                       Valid values: 'true', 'false'.
#!                       Default: 'false'.
#! @input enable_TLS: Optional - Specify if the connection should be TLS enabled or not.
#!                               Default: 'false'
#! @input enable_SSL: Optional - Specify if the connection should be SSL enabled or not.
#!                               Valid values: 'true', 'false'.
#!                               Default: 'false'.
#! @input keystore: Optional - The path to the keystore to use for SSL Client Certificates.
#!                             Default: ''
#! @input keystore_password: Optional - The password for the keystore.
#!                                      Default: ''
#! @input trust_keystore: Optional - The path to the trust_keystore to use for SSL Server Certificates.
#!                                   Default: ''
#! @input trust_password: Optional - The password for the trust_keystore.
#!                                   Default: ''
#! @input character_set: Optional - The character set used to read the email. By default the operation uses the character
#!                                  set with which the email is marked, in order to read its content. Because sometimes
#!                                  this character set isn't accurate you can provide you own value for this property.
#!                                  Valid values: 'UTF-8', 'UTF-16', 'UTF-32', 'EUC-JP',
#!                                                'ISO-2022-JP', 'Shift_JIS', 'Windows-31J'.
#!                                  Default: 'UTF-8'.
#! @input delete_upon_retrieval: Optional - If true the email which is retrieved will be deleted. For any other values
#!                                          it will be just retrieved.
#!                                          Valid values: 'true', 'false'.
#!                                          Default: 'false'.
#! @input decryption_keystore: Optional - The path to the pks12 format keystore to use to decrypt the mail.
#!                                        Default: ''
#! @input decryption_key_alias: Optional - The alias of the key from the decryption_keystore to use to decrypt the mail.
#!                                         Default: ''
#! @input decryption_keystore_password: Optional - The password for the decryption_keystore.
#!                                                 Default: ''
#! @input timeout: Optional - The timeout (seconds) for sending the mail messages.
#! @input verify_certificate: Optional - Verify the SSL certificate on your web server to make sure it is correctly
#!                                       installed, valid, trusted and doesn't give any errors to any of your users.
#!                                       Default: 'false'
#!
#! @output return_result: The list of messages that was retrieved from the mail server.
#! @output return_code: The return code of the operation. 0 if the operation goes to success,
#!                      -1 if the operation goes to failure.
#! @output subject: Subject of the email.
#! @output body: Only the body contents of the email. This will not contain the attachment including inline
#!               attachments. This is in HTML format, not plain text.
#! @output plain_text_body: Attached file names to the email.
#! @output attached_file_names: Attached file names to the email.
#! @output exception: The exception message if the operation goes to failure.
#!
#! @result SUCCESS: Mail message retrieved successfully and return_code = '0'.
#! @result FAILURE: There was an error while trying to retrieve the mail message and return_code = '-1'.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.mail

operation:
  name: get_mail_message

  inputs:
    - host
    - port:
        default: '993'
    - protocol:
        default: 'imap'
        required: false
    - username
    - password:
        sensitive: true
    - folder:
        default: 'INBOX'
    - trust_all_roots:
        required: false
    - trustAllRoots:
        default: ${get("trust_all_roots", "false")}
        private: true
    - message_number:
        required: false
    - messageNumber:
        default: ${get("message_number", "1")}
        private: true
    - subject_only:
        required: false
    - subjectOnly:
        default: ${get("subject_only", "false")}
        private: true
    - enable_TLS:
        required: false
    - enableTLS:
        default: ${get("enable_TLS", "true")}
        private: true
    - enable_SSL:
        required: false
    - enableSSL:
        default: ${get("enable_SSL", "false")}
        private: true
    - trust_keystore:
        required: false
    - trustKeystore:
        default: ${get("trust_keystore", "")}
        required: false
        private: true
    - trust_password:
        required: false
        sensitive: true
    - trustPassword:
        default: ${get("trust_password", "")}
        required: false
        private: true
        sensitive: true
    - keystore:
        default: ''
        required: false
    - keystore_password:
        required: false
        sensitive: true
    - keystorePassword:
        default: ${get("keystore_password", "")}
        required: false
        private: true
        sensitive: true
    - character_set:
        required: false
    - characterSet:
        default: ${get("character_set", "UTF-8")}
        private: true
    - delete_upon_retrieval:
        required: false
    - deleteUponRetrieval:
        default: ${get("delete_upon_retrieval", "false")}
        private: true
    - decryption_keystore:
        required: false
    - decryptionKeystore:
        default: ${get("decryption_keystore", "")}
        required: false
        private: true
    - decryption_key_alias:
        required: false
    - decryptionKeyAlias:
        default: ${get("decryption_key_alias", "")}
        required: false
        private: true
    - decryption_keystore_password:
        required: false
    - decryptionKeystorePassword:
        default: ${get("decryption_keystore_password", "")}
        required: false
        private: true
    - timeout:
        required: false
    - verify_certificate:
        required: false
    - verifyCertificate:
        default: ${get("verifyCertificate", "false")}
        private: true


  java_action:
    gav: 'io.cloudslang.content:cs-mail:0.0.38'
    class_name: io.cloudslang.content.mail.actions.GetMailMessageAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - subject
    - body
    - plain_text_body: ${plainTextBody}
    - attached_file_names: ${attachedFileNames}
    - exception

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
