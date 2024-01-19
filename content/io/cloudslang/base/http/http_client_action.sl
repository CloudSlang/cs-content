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
#! @description: Executes a REST call based on the method provided.
#!
#! @input url: URL to which the call is made.
#! @input auth_type: Optional - Type of authentication used to execute the request on the target server.
#!                   Valid: 'basic', 'form', 'springForm', 'digest', 'ntlm', 'kerberos', 'anonymous' (no authentication)
#!                   Default: 'basic'
#! @input username: Optional - Username used for URL authentication; for NTLM authentication.
#!                  Format: 'domain\user'
#! @input password: Optional - Password used for URL authentication.
#! @input preemptive_auth: Optional - If 'true' authentication info will be sent in the first request, otherwise a request
#!                         with no authentication info will be made and if server responds with 401 and a header.
#!                         like WWW-Authenticate: Basic realm="myRealm" only then will the authentication info
#!                         will be sent
#!                         Default: 'true'
#! @input kerberos_conf_file: Optional - Path to the Kerberos configuration file.
#!                            Default: '0'
#! @input kerberos_login_conf_file: Optional - login.conf file needed by the JAAS framework with the content similar to
#!                                  the one in examples.
#!                                  Format: 'http://docs.oracle.com/javase/7/docs/jre/api/security/jaas/spec/com/sun/security/auth/module/Krb5LoginModule.html'
#! @input kerberos_skip_port_for_lookup: Optional - Do not include port in the key distribution center database lookup
#!                                       Default: 'true'
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - Username used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input tls_version: Optional - This input allows a list of comma separated values of the specific protocols to be used.
#!                     Valid: SSLv3, TLSv1, TLSv1.1, TLSv1.2, TLSv1.3.
#!                     Default: 'TLSv1.2'
#! @input allowed_cyphers: Optional - A comma delimited list of cyphers to use. The value of this input will be ignored
#!                         if 'tlsVersion' does not contain 'TLSv1.2' or 'TLSv1.3'.This capability is provided “as is”, please see product
#!                         documentation for further security considerations. In order to connect successfully to the target
#!                         host, it should accept at least one of the following cyphers. If this is not the case, it is the
#!                         user's responsibility to configure the host accordingly or to update the list of allowed cyphers.
#!                         Default: TLS_DHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
#!                         TLS_DHE_RSA_WITH_AES_256_CBC_SHA256,TLS_DHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,
#!                         TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
#!                         TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_256_CBC_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA256
#!                         Valid values for TLSv1.3 : TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256,TLS_AES_128_GCM_SHA256
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'true'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'allow_all'
#! @input trust_keystore: Optional - Location of the TrustStore file.
#!                        Format: a URL or the local path to it
#! @input trust_password: Optional -  Password associated with the trust_keystore file.
#! @input keystore: Optional - Location of the KeyStore file.
#!                  Format: a URL or the local path to it.
#!                  This input is empty if no HTTPS client authentication is used
#! @input keystore_password: Optional - Password associated with the KeyStore file.
#! @input execution_timeout: Optional - Time in seconds to wait for the operation to finish executing.
#!                         Default: '0' (infinite timeout)
#! @input connect_timeout: Optional - Time in seconds to wait for a connection to be established.
#!                         Default: '0' (infinite timeout)
#! @input socket_timeout: Optional - Time in seconds to wait for data to be retrieved (maximum period inactivity.
#!                        between two consecutive data packets)
#!                        Default: '0' (infinite timeout)
#! @input use_cookies: Optional - Specifies whether to enable cookie tracking or not.
#!                     Default: 'true'
#! @input keep_alive: Optional - Specifies whether to create a shared connection that will be used in subsequent calls.
#!                    Default: 'false'
#! @input connections_max_per_route: Optional - Maximum limit of connections on a per route basis.
#!                                  Default: '2'
#! @input connections_max_total: Optional - Maximum limit of connections in total.
#!                               Default: '20'
#! @input headers: Optional - List containing the headers to use for the request separated by new line (CRLF);
#!                 header name - value pair will be separated by ":".
#!                 Format: According to HTTP standard for headers (RFC 2616)
#!                 Example: 'Accept:text/plain'
#! @input response_character_set: Optional - Character encoding to be used for the HTTP response.
#!                                Default: 'ISO-8859-1'
#! @input destination_file: Optional - Absolute path of a file on disk where the entity returned by the response will be
#!                          saved to.
#! @input follow_redirects: Optional - Specifies whether the 'Get' command automatically follows redirects.
#!                          Default: 'true'
#! @input query_params: Optional - List containing query parameters to append to the URL.
#!                      Examples: 'parameterName1=parameterValue1&parameterName2=parameterValue2;'
#! @input query_params_are_URL_encoded: Optional - Whether to encode (according to the url encoding standard) the <query_params>.
#!                                      Default: 'false'
#! @input query_params_are_form_encoded: Optional - Whether to encode the <query_params> in the form request format.
#!                                       Default: 'true'
#! @input form_params: Optional - Input needs to be given in form encoded format and will set the entity to be sent in the
#!                     request.
#!                     Examples: 'input1=value1&input2=value2'. (The client will send: 'input1=value1&in+put+2=val+u%0A+e2')
#! @input form_params_are_URL_encoded: Optional - If true <form_params> will be encoded (according to the url encoding standard).
#!                                     Default: 'false'
#! @input source_file: Optional - Absolute path of a file on disk from where to read the entity for the http request;
#!                     should not be provided for method=GET, HEAD, TRACE.
#!                     source_file input takes precedence over multipart_files input
#! @input body: Optional - String to include in body for HTTP POST operation. If both <source_file> and body will be provided,
#!              the body input has priority over <source_file>; should not be provided for method=GET, HEAD, TRACE.
#! @input content_type: Optional - Content type that should be set in the request header, representing the MIME-type of the
#!                      data in the message body.
#!                      Default: 'text/plain'
#! @input request_character_set: Optional - Character encoding to be used for the HTTP request body; should not be provided
#!                               for method=GET, HEAD, TRACE.
#!                               Default: 'ISO-8859-1'
#! @input multipart_bodies: Optional - List of name=textValue pairs separated by "&"; will also take into account the
#!                          <content_type> and 'charset' inputs.
#! @input multipart_bodies_content_type: Optional - Each entity from the multipart entity has a content-type header; only
#!                                       specify once for all the parts. It is the only way to change the characterSet of
#!                                       the encoding.
#!                                       Default: 'text/plain; charset=ISO-8859-1'
#! @input multipart_files: Optional - List of name=filePath pairs.
#! @input multipart_files_content_type: Optional - Each entity from the multipart entity has a content-type header; only
#!                                      specify once for all parts.
#!                                      Examples: 'image/png', 'text/plain'
#!                                      Default: 'application/octet-stream'
#! @input multipart_values_are_URL_encoded: Optional - Set 'true' if the bodies may contain '&' and '='.
#!                                          Default: 'false'
#! @input chunked_request_entity: Optional - Data is sent in a series of 'chunks'.
#!                                Valid: 'true'/'false'
#! @input method: HTTP method used.
#! @input http_client_cookie_session: Optional - Session object that holds the cookies if the <use_cookies> input is true.
#! @input http_client_pooling_connection_manager: Optional - GlobalSessionObject that holds the http client pooling
#!                                                connection manager.
#! @input valid_http_status_codes: Optional - List/array of HTTP status codes considered to be successful.
#!                                 Example: [202, 204]
#!                                 Default: 'range(200, 300)'
#!
#! @output return_result: Response of the operation.
#! @output error_message: Return_result when the return_code is non-zero (e.g. network or other failure).
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: Status code of the HTTP call.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#!
#! @result SUCCESS: Operation succeeded (statusCode is contained in valid_http_status_codes list).
#! @result FAILURE: Operation failed (statusCode is  not contained in valid_http_status_codes list).
#!!#
########################################################################################################################

namespace: io.cloudslang.base.http

operation:
  name: http_client_action

  inputs:
    - url
    - auth_type:
        required: false
    - authType:
        default: ${get("auth_type", "basic")}
        private: true
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - preemptive_auth:
        required: false
    - preemptiveAuth:
        default: ${get("preemptive_auth", "true")}
        private: true
    - kerberos_conf_file:
        required: false
    - kerberosConfFile:
        default: ${get("kerberos_conf_file", "0")}
        private: true
    - kerberos_login_conf_file:
        required: false
    - kerberosLoginConfFile:
        default: ${get("kerberos_login_conf_file", "")}
        required: false
        private: true
    - kerberos_skip_port_for_lookup:
        required: false
    - kerberosSkipPortForLookup:
        default: ${get("kerberos_skip_port_for_lookup", "true")}
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
    - tls_version:
        required: false
    - tlsVersion:
        default: ${get("tls_version", "")}
        required: false
        private: true
    - allowed_cyphers:
        required: false
    - allowedCyphers:
        default: ${get("allowed_cyphers", "")}
        private: true
        required: false
    - trust_all_roots:
        required: false
    - trustAllRoots:
        default: ${get("trust_all_roots", "true")}
        private: true
    - x_509_hostname_verifier:
        required: false
    - x509HostnameVerifier:
        default: ${get("x_509_hostname_verifier", "allow_all")}
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
        required: false
    - keystore_password:
        required: false
        sensitive: true
    - keystorePassword:
        default: ${get("keystore_password", "")}
        required: false
        private: true
        sensitive: true
    - execution_timeout:
        required: false
    - executionTimeout:
        default: ${get("execution_timeout", "0")}
        required: false
        private: true
    - connect_timeout:
        required: false
    - connectTimeout:
        default: ${get("connect_timeout", "0")}
        required: false
        private: true
    - socket_timeout:
        required: false
    - socketTimeout:
        default: ${get("socket_timeout", "0")}
        private: true
    - use_cookies:
        required: false
    - useCookies:
        default: ${get("use_cookies", "true")}
        private: true
    - keep_alive:
        required: false
    - keepAlive:
        default: ${get("keep_alive", "false")}
        private: true
    - connections_max_per_route:
        required: false
    - connectionsMaxPerRoute:
        default: ${get("connections_max_per_route", "2")}
        private: true
    - connections_max_total:
        required: false
    - connectionsMaxTotal:
        default: ${get("connections_max_total", "20")}
        private: true
    - headers:
        required: false
    - response_character_set:
        required: false
    - responseCharacterSet:
        default: ${get("response_character_set", "ISO-8859-1")}
        private: true
    - destination_file:
        required: false
    - destinationFile:
        default: ${get("destination_file", "")}
        required: false
        private: true
    - follow_redirects:
        required: false
    - followRedirects:
        default: ${get("follow_redirects", "true")}
        private: true
    - query_params:
        required: false
    - queryParams:
        default: ${get("query_params", "")}
        required: false
        private: true
    - query_params_are_URL_encoded:
        required: false
    - queryParamsAreURLEncoded:
        default: ${get("query_params_are_URL_encoded", "false")}
        private: true
    - query_params_are_form_encoded:
        required: false
    - queryParamsAreFormEncoded:
        default: ${get("query_params_are_form_encoded", "true")}
        private: true
    - form_params:
        required: false
    - formParams:
        default: ${get("form_params", "")}
        required: false
        private: true
    - form_params_are_URL_encoded:
        required: false
    - formParamsAreURLEncoded:
        default: ${get("form_params_are_URL_encoded", "false")}
        private: true
    - source_file:
        required: false
    - sourceFile:
        default: ${get("source_file", "")}
        required: false
        private: true
    - body:
        required: false
    - content_type:
        required: false
    - contentType:
        default: ${get("content_type", "text/plain")}
        private: true
    - request_character_set:
        required: false
    - requestCharacterSet:
        default: ${get("request_character_set", "ISO-8859-1")}
        private: true
    - multipart_bodies:
        required: false
    - multipartBodies:
        default: ${get("multipart_bodies", "")}
        required: false
        private: true
    - multipart_bodies_content_type:
        required: false
    - multipartBodiesContentType:
        default: ${get("multipart_bodies_content_type", "text/plain; charset=ISO-8859-1")}
        private: true
    - multipart_files:
        required: false
    - multipartFiles:
        default: ${get("multipart_files", "")}
        required: false
        private: true
    - multipart_files_content_type:
        required: false
    - multipartFilesContentType:
        default: ${get("multipart_files_content_type", "application/octet-stream")}
        private: true
    - multipart_values_are_URL_encoded:
        required: false
    - multipartValuesAreURLEncoded:
        default: ${get("multipart_values_are_URL_encoded", "false")}
        private: true
    - chunked_request_entity:
        required: false
    - chunkedRequestEntity:
        default: ${get("chunked_request_entity", "")}
        required: false
        private: true
    - method
    - http_client_cookie_session:
        required: false
    - httpClientCookieSession:
        default: ${get("http_client_cookie_session", "")}
        required: false
        private: true
    - http_client_pooling_connection_manager:
        required: false
    - httpClientPoolingConnectionManager:
        default: ${get("http_client_pooling_connection_manager", "")}
        required: false
        private: true
    - valid_http_status_codes:
        default: ${ str(list(range(200, 300))) }

  java_action:
    gav: 'io.cloudslang.content:cs-http-client:0.1.94'
    class_name: io.cloudslang.content.httpclient.actions.HttpClientAction
    method_name: execute

  outputs:
    - return_result: ${get('returnResult', '')}
    - error_message: ${returnResult if returnCode != '0' else ''}
    - status_code: ${get('statusCode', '')}
    - return_code: ${returnCode if (str(status_code) in valid_http_status_codes) else '-1'}
    - response_headers: ${get('responseHeaders', '')}

  results:
    - SUCCESS: ${(returnCode == '0') and (str(statusCode) in valid_http_status_codes)}
    - FAILURE
