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
#!                      Valid values: 'true', 'false'.
#!                      Default: 'false'
#! @input attachments: Optional - A delimited separated list of files to attach (must be full path).
#!                     Default: ''
#! @input headers: Optional - This input contains extra headers you want to be added in the mail. The input has a 'Map' format.
#!                            Header names are separated from header values through a column delimiter and headers will be
#!                            separated between them by a row delimiter.
#!                 Example: Sensitivity:Company-Confidential
#!                          message-type:Multiple Part
#!                          Sensitivity:Personal
#! @input rowDelimiter: Optional - The delimiter that separates headers in the 'headers' input.
#!                      Default value: ":"
#!                      Examples: '|', '='
#! @input columnDelimiter: Optional - The delimiter that separates the header name from header value on the same row.
#!                         Default value: "\n"
#!                         Examples: ';', '#'
#! @input username: Optional - If SMTP authentication is needed, the username to use.
#!                  Default: ''
#! @input password: Optional - If SMTP authentication is needed, the password to use.
#!                  Default: ''
#! @input character_set: Optional - The character set encoding for the entire email which includes subject, body,
#!                                  attached file name and the attached file.
#!                       Valid values: 'UTF-8', 'UTF-16', 'UTF-32', 'EUC-JP', 'ISO-2022-JP', 'Shift_JIS', 'Windows-31J'.
#!                       Default: 'UTF-8'
#! @input content_transfer_encoding: Optional - The content transfer encoding scheme (such as 7bit, 8bit, base64,
#!                                              quoted-printable, etc) for the entire email which includes subject,
#!                                              body, attached file name and the attached file.
#!                                   Valid values: 'quoted-printable', 'base64', '7bit', '8bit', 'binary', 'x-token'.
#!                                   Default: 'quoted-printable'
#! @input delimiter: Optional -  A delimiter to separate the email recipients and the attachments.
#!                   Default: ''
#! @input encryption_keystore: Optional - The path to the pks12 formatted keystore used to encrypt the mail.
#!                             Default: ''
#! @input encryption_key_alias: Optional - The alias of a RSA key pair from the encryptionKeystore. The public key from the
#!                                         pair will be used to encrypt the mail. The key pair must not have password.
#!                                         The recommended key size is 2048 bit or higher.
#!                              Default: ''
#! @input encryption_keystore_password: Optional - The password for the encryptionKeystore.
#!                                      Default: ''
#! @input encryption_algorithm: Optional - The encryption algorithm applied on the key from the keystore in order to encypt email parts.
#!                              Valid values: 'DES_EDE3_CBC', 'RC2_CBC', 'IDEA_CBC', 'CAST5_CBC', 'AES128_CBC', 'AES192_CBC', 'AES256_CBC',
#!                                            'CAMELLIA192_CBC', 'CAMELLIA256_CBC', 'SEED_CBC', 'DES_EDE3_WRAP', 'AES128_WRAP', 'AES256_WRAP',
#!                                            'CAMELLIA192_WRAP', 'CAMELLIA256_WRAP', 'SEED_WRAP', 'CAMELLIA128_CBC', 'CAMELLIA128_WRAP'.
#!                              Default value: 'AES256_CBC'.
#! @input enable_TLS: Optional - Specify if the connection should be TLS enabled or not.
#!                    Default: 'false'
#! @input tls_version: Optional - The version of TLS to use. The value of this input will be ignored if 'enableTLS/'enableSSL'
#!                                is set to 'false'.
#!                     Valid values: 'SSLv3', 'TLSv1', 'TLSv1.1', 'TLSv1.2'.
#!                     Default: 'TLSv1.2'.
#! @input timeout: Optional - The timeout (seconds) for sending the mail messages.
#!                 Default: ''
#! @input proxy_host: Optional - The proxy server used.
#!                    Default: ''
#! @input proxy_port: Optional - The proxy server port.
#!                    Default: ''
#! @input proxy_username: Optional - The user name used when connecting to the proxy.
#!                        Default: ''
#! @input proxy_password: Optional - The proxy server password associated with the proxy_username input value.
#!                        Default: ''
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
        default: 'true'
        private: true
    - read_receipt:
        required: false
    - readReceipt:
        default: 'false'
        private: true
    - attachments:
        required: false
    - headers:
        required: false
        private: true
    - row_delimiter:
        required: false
    - rowDelimiter:
        default: ':'
        private: true
    - column_delimiter:
        required: false
    - columnDelimiter:
        default: '\n'
        private: true
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - character_set:
        required: false
    - characterSet:
        default: 'UTF-8'
        private: true
    - content_transfer_encoding:
        required: false
    - contentTransferEncoding:
        default: 'quoted-printable'
        private: true
    - delimiter:
        default: ','
        required: false
    - encryption_keystore:
        required: false
    - encryptionKeystore:
        default: ${get("encryption_keystore", "")}
        required: false
        private: true
    - encryption_key_alias:
        required: false
    - encryptionKeyAlias:
        default: ${get("encryption_key_alias", "")}
        required: false
        private: true
    - encryption_keystore_password:
        required: false
    - encryptionKeystorePassword:
        default: ${get("encryption_keystore_password", "")}
        required: false
        private: true
    - enable_TLS:
        required: false
    - enableTLS:
        default: 'false'
        required: false
        private: true
    - tls_version:
        required: false
    - tlsVersion:
        default: 'TLSv1.2'
        private: true
    - encryption_algorithm:
        required: false
    - encryptionAlgorithm:
        default: 'AES256_CBC'
        required: false
        private: true
    - timeout:
        required: false
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        required: false
        private: true
    - proxy_port:
        required: false
    - proxyPort:
        default: '8080'
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

  java_action:
    gav: 'io.cloudslang.content:cs-mail:0.0.146-SNAPSHOT'
    class_name: io.cloudslang.content.mail.actions.SendMailAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
