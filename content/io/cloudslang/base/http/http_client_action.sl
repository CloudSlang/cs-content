#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Executes a REST call based on the method provided.
#! @input url: URL to which the call is made
#! @input auth_type: optional - type of authentication used to execute the request on the target server
#!                   Valid: 'basic', 'form', 'springForm', 'digest', 'ntlm', 'kerberos', 'anonymous' (no authentication)
#!                   Default: 'basic'
#! @input preemptive_auth: optional - if 'true' authentication info will be sent in the first request, otherwise a request
#!                         with no authentication info will be made and if server responds with 401 and a header
#!                         like WWW-Authenticate: Basic realm="myRealm" only then will the authentication info
#!                         will be sent - Default: true
#! @input username: optional - username used for URL authentication; for NTLM authentication - Format: 'domain\user'
#! @input password: optional - password used for URL authentication
#! @input kerberos_conf_file: optional - path to the Kerberos configuration file - Default: '0'
#! @input kerberos_login_conf_file: optional - login.conf file needed by the JAAS framework with the content similar to the one in examples
#!                                  Format: 'http://docs.oracle.com/javase/7/docs/jre/api/security/jaas/spec/com/sun/security/auth/module/Krb5LoginModule.html'
#! @input kerberos_skip_port_for_lookup: optional - do not include port in the key distribution center database lookup
#!                                       Default: true
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @input proxy_username: optional - username used when connecting to the proxy
#! @input proxy_password: optional - proxy server password associated with the <proxy_username> input value
#! @input trust_all_roots: optional - specifies whether to enable weak security over SSL - Default: true
#! @input x_509_hostname_verifier: optional - specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#! @input trust_keystore: optional - location of the TrustStore file - Format: a URL or the local path to it
#! @input trust_password: optional -  password associated with the TrustStore file
#! @input keystore: optional - location of the KeyStore file - Format: a URL or the local path to it.
#!                  This input is empty if no HTTPS client authentication is used
#! @input keystore_password: optional - password associated with the KeyStore file
#! @input connect_timeout: optional - time in seconds to wait for a connection to be established - Default: '0' (infinite timeout)
#! @input socket_timeout: optional - time in seconds to wait for data to be retrieved (maximum period inactivity between two consecutive
#!                        data packets) - Default: '0' (infinite timeout)
#! @input use_cookies: optional - specifies whether to enable cookie tracking or not - Default: true
#! @input keep_alive: optional - specifies whether to create a shared connection that will be used in subsequent calls
#!                    Default: true
#! @input connections_max_per_root: optional - maximum limit of connections on a per route basis - Default: '2'
#! @input connections_max_total: optional - maximum limit of connections in total - Default: '2'
#! @input headers: optional - list containing the headers to use for the request separated by new line (CRLF);
#!                 header name - value pair will be separated by ":" - Format: According to HTTP standard for
#!                 headers (RFC 2616) - Examples: 'Accept:text/plain'
#! @input response_character_set: optional - character encoding to be used for the HTTP response - Default: 'ISO-8859-1'
#! @input destination_file: optional - absolute path of a file on disk where the entity returned by the response will be
#!                          saved to
#! @input follow_redirects: specifies whether the 'Get' command automatically follows redirects - Default: true
#! @input query_params: optional - list containing query parameters to append to the URL
#!                      Examples: 'parameterName1=parameterValue1&parameterName2=parameterValue2;'
#! @input query_params_are_URL_encoded: optional - whether to encode (according to the url encoding standard) the <query_params>
#!                                      Default: false
#! @input query_params_are_form_encoded: optional - whether to encode the <query_params> in the form request format
#!                                       Default: true
#! @input form_params: optional - input needs to be given in form encoded format and will set the entity to be sent in the
#!                     request - Examples: 'input1=value1&input2=value2'. (The client will send:
#!                     'input1=value1&in+put+2=val+u%0A+e2')
#! @input form_params_are_URL_encoded: optional - if true <form_params> will be encoded (according to the url encoding standard)
#!                                     Default: false
#! @input source_file: optional - absolute path of a file on disk from where to read the entity for the http request;
#!                     should not be provided for method=GET, HEAD, TRACE.
#! @input body: optional - string to include in body for HTTP POST operation. If both <source_file> and body will be provided,
#!              the body input has priority over <source_file>; should not be provided for method=GET, HEAD, TRACE
#! @input content_type: optional - content type that should be set in the request header, representing the MIME-type of the
#!                      data in the message body - Default: 'text/plain'
#! @input request_character_set: optional - character encoding to be used for the HTTP request body; should not be provided
#!                               for method=GET, HEAD, TRACE - Default: 'ISO-8859-1'
#! @input multipart_bodies: optional - list of name=textValue pairs separated by "&"; will also take into account the
#!                          <content_type> and 'charset' inputs
#! @input multipart_bodies_content_type: optional - each entity from the multipart entity has a content-type header; only
#!                                       specify once for all the parts. It is the only way to change the characterSet of
#!                                       the encoding - Default: 'text/plain; charset=ISO-8859-1'
#! @input multipart_files: optional - list of name=filePath pairs
#! @input multipart_files_content_type: optional - each entity from the multipart entity has a content-type header; only
#!                                      specify once for all parts - Default: 'application/octet-stream'
#!                                      Examples: 'image/png', 'text/plain'
#! @input multipart_values_are_URL_encoded: optional - set 'true' if the bodies may contain '&' and '=' - Default: false
#! @input chunked_request_entity: optional - data is sent in a series of 'chunks' - Valid: true/false
#! @input method: HTTP method used
#! @input http_client_cookie_session: optional - session object that holds the cookies if the <use_cookies> input is true
#! @input http_client_pooling_connection_manager: optional - GlobalSessionObject that holds the http client pooling
#!                                                connection manager
#! @input valid_http_status_codes: optional - list/array of HTTP status codes considered to be successful - Example: [202, 204]
#!                                 Default: 'range(200, 300)'
#! @output return_result: response of the operation
#! @output error_message: return_result when the return_code is non-zero (e.g. network or other failure)
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: status code of the HTTP call
#! @output response_headers: response headers string from the HTTP Client REST call
#! @result SUCCESS: operation succeeded (statusCode is contained in valid_http_status_codes list)
#! @result FAILURE: otherwise
#!!#
################################################

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
    - preemptive_auth:
        required: false
    - preemptiveAuth:
        default: ${get("preemptive_auth", "true")}
        private: true
    - username:
        required: false
    - password:
        required: false
        sensitive: true
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
    - connect_timeout:
        required: false
    - connectTimeout:
        default: ${get("connect_timeout", "0")}
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
        default: ${get("keep_alive", "true")}
        private: true
    - connections_max_per_root:
        required: false
    - connectionsMaxPerRoot:
        default: ${get("connections_max_per_root", "2")}
        private: true
    - connections_max_total:
        required: false
    - connectionsMaxTotal:
        default: ${get("connections_max_total", "2")}
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
        default: ${range(200, 300)}

  java_action:
    gav: 'io.cloudslang.content:cs-http-client:0.1.67'
    class_name: io.cloudslang.content.httpclient.HttpClientAction
    method_name: execute
  outputs:
    - return_result: ${get('returnResult', '')}
    - error_message: ${returnResult if returnCode != '0' else ''}
    - return_code: ${returnCode}
    - status_code: ${get('statusCode', '')}
    - response_headers: ${get('responseHeaders', '')}
  results:
    - SUCCESS : ${returnCode == '0' and int(statusCode) in valid_http_status_codes}
    - FAILURE
