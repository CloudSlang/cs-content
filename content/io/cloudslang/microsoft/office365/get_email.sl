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
#! @description: This operation retrieves a message based on a message id.
#!                If a messageId is not provided the operation retrieves the message list from the provided
#!                user's mailbox (including the Deleted Items and Clutter folders) in a descendent order
#!                based on the date and time.
#!
#! @input tenant: Your application tenant.
#! @input client_id: Service Client ID
#! @input client_secret: Service Client Secret
#!                       Optional
#! @input email_address: The email address on which to perform the action,
#!                       Optional
#! @input message_id: The ID of the sent mail.
#!                    Optional
#! @input folder_id: The ID of the folder which contains the message to retrieve.
#!                   Optional
#! @input count: Query parameter use to specify the number of results. Default value: 10
#!                   Optional
#! @input query: A list of query parameters in the form of a comma delimited list.
#!                      Example: id,internetMessageHeaders,body,sender,sentDateTime,subject
#!                      Optional
#! @input o_data_query: Query parameters which can be used to specify and control the amount of data returned in a
#!                      response specified in 'key1=val1&key2=val2' format. $top and $select options should be not
#!                      passed for this input because the values for these options can be passed in topQuery and
#!                      selectQuery inputs. In order to customize the Office 365 response, modify or remove the default value.
#!                      Example: &filter=Subject eq 'Test' AND IsRead eq true
#!                               &filter=HasAttachments eq true
#!                               &search="from:help@contoso.com"
#!                               &search="subject:Test"
#!                               $select=subject,bodyPreview,sender,from
#!                      Optional
#! @input file_path: The file path under which the attachment will be downloaded. The attachment will not be downloaded
#!                   if a path is not provided.
#!                   Optional
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
#!                                 the charset from the 'Content-Type' HTTP response header will be used. If responseCharacterSet
#!                                 is empty and the charset from the HTTP response Content-Type header is empty,
#!                                 the default value will be used. You should not use this for method=HEAD or OPTIONS.
#!                                 Default value: UTF-8
#!
#! @output return_result: A message is returned in case of success, an error message is returned in case of failure.
#! @output return_code: 0 if success, -1 otherwise.
#! @output exception: An error message in case there was an error while sending the email.
#! @output status_code: The HTTP status code for Office 365 API request.
#! @output message_id_list: A comma-separated list of message IDs from the retrieved document.
#!
#! @result SUCCESS: The email was retrieved with success.
#! @result FAILURE: There was an error while trying to retrieve the email.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.office365

operation:
  name: get_email

  inputs:
    - tenant
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
    - email_address:
        required: false
    - emailAddress:
        default: ${get('email_address', '')}
        required: false
        private: true
    - message_id:
        required: false
    - messageId:
        default: ${get('message_id', '')}
        required: false
        private: true
    - folder_id:
        required: false
    - folderId:
        default: ${get('folder_id', '')}
        required: false
        private: true
    - count:
        required: false
    - query:
        required: false
    - o_data_query:
        required: false
    - oDataQuery:
        default: ${get('o_data_query', '')}
        required: false
        private: true
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
    gav: 'io.cloudslang.content:cs-office-365:1.0.0-RC29'
    class_name: 'io.cloudslang.content.office365.actions.email.GetEmail'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}
    - status_code: ${get('statusCode', '')}
    - message_id_list: ${get('messageIdList', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE
