#   Copyright 2023 Open Text
#   This program and the accompanying materials
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
#! @description: This operation downloads an email attachment to a specific directory or as a temporary file.
#!               If the attachment is in plain text format, it also reads the text content of the attachment in a result.
#!               Inline attachments are not supported by this operation.
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
#! @input password: Optional - The password for the mail host.
#!                  Default: ''
#! @input auth_token: Optional - The OAuth 2.0 token used for connecting to the email host. If given, the password input will be ignored.
#!                    Default: ''
#! @input folder: Optional - The folder to read the message from (NOTE: POP3 only supports "INBOX").
#!                           Default: 'INBOX'
#! @input message_number: The number (starting at 1) of the message to retrieve.  Email ordering is a server
#!                        setting that is independent of the client.
#! @input destination: Optional - The folder where the attachment will be saved. If this input is empty the attachment will be
#!                                saved as a temporary file. Examples: C:\Folder Name, \\<computerName>\<Shared Folder>.
#! @input attachment_name: The name of the attachment in the email that should be read/downloaded.
#! @input overwrite: Optional - If true the attachment will overwrite any existing file with the same name in destination.
#!                              Valid values: true, false.
#! @input delete_upon_retrieval: Optional - If true the email from which the attachment is retrieved will be deleted.
#!                                          For any other values the email will not be deleted.
#!                                          Valid values: true, false.
#!                                          Default: 'false'
#! @input proxy_host: Optional - The proxy server used.
#!                                Default: ''
#! @input proxy_port: Optional - The proxy server port.
#!                                Default: ''
#! @input proxy_username: Optional - The user name used when connecting to the proxy.
#!                                Default: ''
#! @input proxy_password: Optional - The proxy server password associated with the proxy_username input value.
#!                                    Default: ''
#! @input enable_SSL: Optional - Specify if the connection should be SSL enabled or not.
#!                               Valid values: 'true', 'false'.
#!                               Default: 'false'.
#! @input enable_TLS: Optional - Specify if the connection should be TLS enabled or not.
#!                               Default: 'false'
#! @input tls_version: Optional - The version of TLS to use. The value of this input will be ignored if 'enableTLS/'enableSSL'
#!                               is set to 'false'.
#!                               Valid values: 'SSLv3', 'TLSv1', 'TLSv1.1', 'TLSv1.2'.
#!                               Default: 'TLSv1.2'.
#! @input encryption_algorithm: Optional - A comma delimited list of cyphers to use. The value of this input will be ignored
#!                              if "tlsVersion" does not contain "TLSv1.2". This capability is provided “as is”, please see
#!                              product documentation for further security considerations. In order to connect successfully
#!                              to the target host, it should accept at least one of the following cyphers. If this is not
#!                              the case, it is the user's responsibility to configure the host accordingly or to update
#!                              the list of allowed cyphers.
#!                              Default: 'TLS_DHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
#!                              TLS_DHE_RSA_WITH_AES_256_CBC_SHA256, TLS_DHE_RSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,
#!                              TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
#!                              TLS_RSA_WITH_AES_256_GCM_SHA384, TLS_RSA_WITH_AES_256_CBC_SHA256, TLS_RSA_WITH_AES_128_CBC_SHA256'.
#! @input trust_all_roots: Optional - Specifies whether to trust all SSL certificate authorities. This input is ignored
#!                                    if the enable_SSL input is set to false. If false, make sure to have the
#!                                    certificate installed. The steps are explained at the end of inputs description.
#!                                    Valid values: 'true', 'false'.
#!                                    Default: 'false'.
#! @input keystore: Optional - The path to the keystore to use for SSL Client Certificates.
#!                             Default: ''
#! @input keystore_password: Optional - The password for the keystore.
#!                                      Default: ''
#! @input character_set: Optional - The character set used to read the email. By default the operation uses the character
#!                                  set with which the email is marked, in order to read its content. Because sometimes
#!                                  this character set isn't accurate you can provide you own value for this property.
#!                                  Valid values: 'UTF-8', 'UTF-16', 'UTF-32', 'EUC-JP',
#!                                                'ISO-2022-JP', 'Shift_JIS', 'Windows-31J'.
#!                                  Default: 'UTF-8'.
#! @input decryption_keystore: Optional - The path to the pks12 format keystore to use to decrypt the mail.
#!                                        Default: ''
#! @input decryption_key_alias: Optional - The alias of the key from the decryption_keystore to use to decrypt the mail.
#!                                         Default: ''
#! @input decryption_keystore_password: Optional - The password for the decryption_keystore.
#!                                                 Default: ''
#! @input timeout: Optional - The timeout (seconds) for retrieving the mail attachment.
#!
#! @output return_result: The list of messages that was retrieved from the mail server.
#! @output return_code: The return code of the operation. 0 if the operation goes to success,
#!                      -1 if the operation goes to failure.
#! @output temporary_file: The path to the temporary file where the attachment was saved.
#! @output exception: The exception message if the operation goes to failure.
#!
#! @result SUCCESS: Mail message retrieved successfully and return_code = '0'.
#! @result FAILURE: There was an error while trying to retrieve the mail message and return_code = '-1'.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.mail

operation:
  name: get_mail_attachment

  inputs:
    - host
    - port:
        required: false
    - protocol:
        required: false
    - username
    - password:
        sensitive: true
        required: false
    - auth_token:
        required: false
    - authToken:
        default: ${get("auth_token", "")}
        private: true
        required: false
    - folder:
        default: 'INBOX'
    - message_number
    - messageNumber:
        default: ${get("message_number", "")}
        required: false
        private: true
    - destination:
        required: false
    - attachment_name
    - attachmentName:
        default: ${get("attachment_name", "")}
        required: false
        private: true
    - overwrite:
        default: 'false'
        required: false
    - delete_upon_retrieval:
        required: false
    - deleteUponRetrieval:
        default: ${get("delete_upon_retrieval", "false")}
        required: false
        private: true
    - trust_all_roots:
        required: false
    - trustAllRoots:
        default: ${get("trust_all_roots", "true")}
        required: false
        private: true
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        required: false
        private: true
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get("proxy_port", "8080")}
        required: false
        private: true
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get("proxy_username", "")}
        required: false
        private: true
    - proxy_password:
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get("proxy_password", "")}
        required: false
        private: true
        sensitive: true
    - enable_SSL:
        required: false
    - enableSSL:
        default: ${get("enable_SSL", "false")}
        required: false
        private: true
    - enable_TLS:
        required: false
    - enableTLS:
        default: ${get("enable_TLS", "false")}
        required: false
        private: true
    - tls_version:
        required: false
    - tlsVersion:
        default: ${get("tls_version", "")}
        required: false
        private: true
    - encryption_algorithm:
        required: false
    - encryptionAlgorithm:
        default: ${get("encryption_algorithm", "")}
        required: false
        private: true
    - keystore:
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
        sensitive: true
    - decryptionKeystorePassword:
        default: ${get("decryption_keystore_password", "")}
        required: false
        private: true
        sensitive: true
    - timeout:
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-mail:0.0.62-SNAPSHOT'
    class_name: io.cloudslang.content.mail.actions.GetMailAttachmentAction
    method_name: execute

  outputs:
    - return_result: ${get('returnResult', '')}
    - temporary_file: ${get('temporaryFile', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE