#   Copyright 2024 Open Text
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
#! @description: Send email using Office 365. This capability is provided "as is", please see product documentation for
#!               further information.
#!               Notes:
#!               1. The below permissions are required to use this operation. To learn more, including how to
#!               choose permissions, see: https://docs.microsoft.com/en-us/graph/permissions-reference
#!               Application: Mail.ReadWrite, Mail.Send
#!               Delegated (work or school account): Mail.ReadWrite, Mail.Send
#!               For information on how to provide the necessary rights for the Office365 API, please see the release notes.
#!               2. For a list of supported well-known folder names, see:
#!               https://docs.microsoft.com/en-us/graph/api/resources/mailfolder?view=graph-rest-1.0
#!
#! @input tenant: Your application tenant.
#! @input login_type: Login method according to Microsoft application type.
#!                    Optional
#!                    Default: Native
#!                    Valid values: API, Native
#! @input username: The username to be used to authenticate to the Office 365 Management Service.
#!                  Optional
#! @input password: The password to be used to authenticate to the Office 365 Management Service.
#!                  Optional
#! @input client_id: Service Client ID
#! @input client_secret: Service Client Secret
#!                       Optional
#! @input from_address: The mailbox owner and sender of the message. Updatable only if isDraft = true. Must correspond to the
#!              actual mailbox used.
#! @input to_recipients: The 'To recipients' for the message. Updatable only if 'isDraft' = true.
#! @input cc_recipients: The Cc recipients for the message. Updatable only if 'isDraft' = true.
#!                       Optional
#! @input subject: The subject of the message. Updatable only if 'isDraft' = true.
#!                 Optional
#! @input body: The body of the message. Updatable only if 'isDraft' = true.
#!              Optional
#! @input file_path: The absolute path to the file that will be attached.
#!              Optional
#! @input proxy_host: Proxy server used to access the Office 365 service.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Office 365 service.Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no
#!                         trusted certification authority issued it.
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to
#!                                 "allow_all" to skip any checking. For the value "browser_compatible" the hostname
#!                                 verifier works the same way as Curl and Firefox. The hostname must match either the
#!                                 first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of
#!                                 the subject-alts. The only difference between "browser_compatible" and "strict" is
#!                                 that a wildcard (such as "*.foo.com") with "browser_compatible" matches all
#!                                 subdomains, including "a.b.foo.com".
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that
#!                        you expect to communicate with, or from Certificate Authorities that you trust to identify
#!                        other parties.  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is
#!                        'true' this input is ignored. Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystore
#!                        is empty, trustPassword default will be supplied.
#!                        Optional
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.
#!                         Optional
#! @input socket_timeout: The timeout for waiting for data (a maximum period inactivity between two consecutive data
#!                        packets), in seconds. A socketTimeout value of '0' represents an infinite timeout.
#!                        Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls. If
#!                    keepAlive is false, the already open connection will be used and after execution it will close it.
#!                    Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.
#!                                   Optional
#! @input connections_max_total: The maximum limit of connections in total.
#!                               Optional
#! @input response_character_set: The character encoding to be used for the HTTP response. If responseCharacterSet is empty,
#!                                the charset from the 'Content-Type' HTTP response header will be used. If responseCharacterSet
#!                                is empty and the charset from the HTTP response Content-Type header is empty,
#!                                the default value will be used. You should not use this for method=HEAD or OPTIONS.
#!                                Default value: UTF-8
#!
#! @output return_result: A message is returned in case of success, an error message is returned in case of failure.
#! @output return_code: 0 if success, -1 otherwise.
#! @output exception: An error message in case there was an error while sending the email.
#! @output status_code: The HTTP status code for Office 365 API request.
#! @output message_id: The ID of the sent mail.
#! @output attachment_id: The ID of the added attachment, if an attachment was added.
#!
#! @result SUCCESS: The email was sent successfully.
#! @result FAILURE: There was an error while sending the email.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.office365

operation:
  name: send_email

  inputs:
    - tenant
    - login_type:
        required: false
    - loginType:
        default: ${get('login_type','')}
        required: false
        private: true
    - username:
        required: false
    - password:
        sensitive: true
        required: false
    - client_id
    - clientId:
        default: ${get('client_id', '')}
        required: false
        private: true
    - client_secret:
        sensitive: true
        required: false
    - clientSecret:
        default: ${get('client_secret', '')}
        required: false
        private: true
        sensitive: true
    - from_address
    - fromAddress:
        default: ${get('from_address', '')}
        required: false
        private: true
    - to_recipients
    - toRecipients:
        default: ${get('to_recipients', '')}
        required: false
        private: true
    - cc_recipients:
        required: false
    - ccRecipients:
        default: ${get('cc_recipients', '')}
        required: false
        private: true
    - subject:
        required: false
    - body:
        required: false
    - file_path:
        required: false
    - filePath:
        default: ${get('file_path', '')}
        required: false
        private: true
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get('proxy_host', '')}
        required: false
        private: true
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get('proxy_port', '')}
        required: false
        private: true
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get('proxy_username', '')}
        required: false
        private: true
    - proxy_password:
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get('proxy_password', '')}
        required: false
        private: true
        sensitive: true
    - trust_all_roots:
        required: false
    - trustAllRoots:
        default: ${get('trust_all_roots', '')}
        required: false
        private: true
    - x_509_hostname_verifier:
        required: false
    - x509HostnameVerifier:
        default: ${get('x_509_hostname_verifier', '')}
        required: false
        private: true
    - trust_keystore:
        required: false
    - trustKeystore:
        default: ${get('trust_keystore', '')}
        required: false
        private: true
    - trust_password:
        required: false
        sensitive: true
    - trustPassword:
        default: ${get('trust_password', '')}
        required: false
        private: true
        sensitive: true
    - connect_timeout:
        required: false
    - connectTimeout:
        default: ${get('connect_timeout', '')}
        required: false
        private: true
    - socket_timeout:
        required: false
    - socketTimeout:
        default: ${get('socket_timeout', '')}
        required: false
        private: true
    - keep_alive:
        required: false
    - keepAlive:
        default: ${get('keep_alive', '')}
        required: false
        private: true
    - connections_max_per_route:
        required: false
    - connectionsMaxPerRoute:
        default: ${get('connections_max_per_route', '')}
        required: false
        private: true
    - connections_max_total:
        required: false
    - connectionsMaxTotal:
        default: ${get('connections_max_total', '')}
        required: false
        private: true
    - response_character_set:
        required: false
    - responseCharacterSet:
        default: ${get('response_character_set', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-office-365:1.1.16'
    class_name: 'io.cloudslang.content.office365.actions.email.SendEmail'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}
    - status_code: ${get('statusCode', '')}
    - message_id: ${get('messageId', '')}
    - attachment_id: ${get('attachmentId', '')}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
