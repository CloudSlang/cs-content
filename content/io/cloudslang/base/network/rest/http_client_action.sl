#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Executes a REST call based on the method provided.
#
# Inputs:
#   - url - URL to which the call is made
#   - auth_type - optional - type of authentication used to execute the request on the target server
#                          - Valid: 'basic', 'form', 'springForm', 'digest', 'ntlm', 'kerberos', 'anonymous' (no authentication)
#                          - Default: 'basic'
#   - preemptive_auth - optional - if 'true' authentication info will be sent in the first request, otherwise a request
#                                  with no authentication info will be made and if server responds with 401 and a header
#                                  like WWW-Authenticate: Basic realm="myRealm" only then will the authentication info
#                                  will be sent - Default: true
#   - username - optional - username used for URL authentication; for NTLM authentication - Format: 'domain\user'
#   - password - optional - password used for URL authentication
#   - kerberos_conf_file - optional - path to the Kerberos configuration file - Default: '0'
#   - kerberos_login_conf_file - optional - login.conf file needed by the JAAS framework with the content similar to the one in examples
#                              - Format: 'http://docs.oracle.com/javase/7/docs/jre/api/security/jaas/spec/com/sun/security/auth/module/Krb5LoginModule.html'
#   - kerberos_skip_port_for_lookup - optional - do not include port in the key distribution center database lookup
#                                              - Default: true
#   - proxy_host - optional - proxy server used to access the web site
#   - proxy_port - optional - proxy server port - Default: '8080'
#   - proxy_username - optional - username used when connecting to the proxy
#   - proxy_password - optional - proxy server password associated with the <proxy_username> input value
#   - trust_all_roots - optional - specifies whether to enable weak security over SSL - Default: true
#   - x_509_hostname_verifier - optional - specifies the way the server hostname must match a domain name in the subject's
#                                          Common Name (CN) or subjectAltName field of the X.509 certificate
#                                        - Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#   - trust_keystore - optional - location of the TrustStore file - Format: a URL or the local path to it
#   - trust_password - optional -  password associated with the TrustStore file
#   - keystore - optional - location of the KeyStore file - Format: a URL or the local path to it.
#                           This input is empty if no HTTPS client authentication is used
#   - keystore_password - optional - password associated with the KeyStore file
#   - connect_timeout - optional - time in seconds to wait for a connection to be established - Default: '0' (infinite timeout)
#   - socket_timeout - optional - time in seconds to wait for data to be retrieved (maximum period inactivity between two consecutive
#                                data packets) - Default: '0' (infinite timeout)
#   - use_cookies - optional - specifies whether to enable cookie tracking or not - Default: true
#   - keep_alive - optional - specifies whether to create a shared connection that will be used in subsequent calls
#                           - Default: true
#   - connections_max_per_root - optional - maximum limit of connections on a per route basis - Default: '2'
#   - connections_max_total - optional - maximum limit of connections in total - Default: '2'
#   - headers - optional - list containing the headers to use for the request separated by new line (CRLF);
#                          header name - value pair will be separated by ":" - Format: According to HTTP standard for
#                          headers (RFC 2616) - Examples: 'Accept:text/plain'
#   - response_character_set - optional - character encoding to be used for the HTTP response - Default: 'ISO-8859-1'
#   - destination_file - optional - absolute path of a file on disk where the entity returned by the response will be
#                                   saved to
#   - follow_redirects - specifies whether the 'Get' command automatically follows redirects - Default: true
#   - query_params - optional - list containing query parameters to append to the URL
#                            - Examples: 'parameterName1=parameterValue1&parameterName2=parameterValue2;'
#   - query_params_are_URL_encoded - optional - whether to encode (according to the url encoding standard) the <query_params>
#                                             - Default: false
#   - query_params_are_form_encoded - optional - whether to encode the <query_params> in the form request format
#                                              - Default: true
#   - form_params - optional - input needs to be given in form encoded format and will set the entity to be sent in the
#                              request - Examples: 'input1=value1&input2=value2'. (The client will send:
#                              'input1=value1&in+put+2=val+u%0A+e2')
#   - form_params_are_URL_encoded - optional - if true <form_params> will be encoded (according to the url encoding standard)
#                                            - Default: false
#   - source_file - optional - absolute path of a file on disk from where to read the entity for the http request;
#                              should not be provided for method=GET, HEAD, TRACE.
#   - body - optional - string to include in body for HTTP POST operation. If both <source_file> and body will be provided,
#                       the body input has priority over <source_file>; should not be provided for method=GET, HEAD, TRACE
#   - content_type - optional - content type that should be set in the request header, representing the MIME-type of the
#                               data in the message body - Default: 'text/plain'
#   - request_character_set - optional - character encoding to be used for the HTTP request body; should not be provided
#                                      for method=GET, HEAD, TRACE - Default: 'ISO-8859-1'
#   - multipart_bodies - optional - list of name=textValue pairs separated by "&"; will also take into account the
#                                  <content_type> and 'charset' inputs
#   - multipart_bodies_content_type - optional - each entity from the multipart entity has a content-type header; only
#                                     specify once for all the parts. It is the only way to change the characterSet of
#                                     the encoding - Default: 'text/plain; charset=ISO-8859-1'
#   - multipart_files - optional - list of name=filePath pairs
#   - multipart_files_content_type - optional - each entity from the multipart entity has a content-type header; only
#                                               specify once for all parts - Default: 'application/octet-stream'
#                                             - Examples: 'image/png', 'text/plain'
#   - multipart_values_are_URL_encoded - optional - set 'true' if the bodies may contain '&' and '=' - Default: false
#   - chunked_request_entity - optional - data is sent in a series of 'chunks' - Valid: true/false
#   - method - HTTP method used
#   - http_client_cookie_session - optional - session object that holds the cookies if the <use_cookies> input is true
#   - http_client_pooling_connection_manager - optional - GlobalSessionObject that holds the http client pooling
#                                                         connection manager
#   - valid_http_status_codes - optional - list/array of HTTP status codes considered to be successful - Example: [202, 204]
#                                        - Default: 'range(200, 300)'
# Outputs:
#   - return_result - response of the operation
#   - error_message - return_result when the return_code is non-zero (e.g. network or other failure)
#   - return_code - '0' if success, '-1' otherwise
#   - status_code - status code of the HTTP call
# Results:
#   - SUCCESS - operation succeeded (statusCode is contained in valid_http_status_codes list)
#   - FAILURE - otherwise
################################################

namespace: io.cloudslang.base.network.rest

operation:
  name: http_client_action
  inputs:
    - url
    - auth_type:
        required: false
    - authType:
        default: ${get("auth_type", "basic")}
        overridable: false
    - preemptive_auth:
        required: false
    - preemptiveAuth:
        default: ${get("preemptive_auth", "true")}
        overridable: false
    - username:
        required: false
    - password:
        required: false
    - kerberos_conf_file:
        required: false
    - kerberosConfFile:
        default: ${get("kerberos_conf_file", "0")}
        overridable: false
    - kerberos_login_conf_file:
        required: false
    - kerberosLoginConfFile:
        default: ${get("kerberos_login_conf_file", "")}
        overridable: false
    - kerberos_skip_port_for_lookup:
        required: false
    - kerberosSkipPortForLookup:
        default: ${get("kerberos_skip_port_for_lookup", "true")}
        overridable: false
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        overridable: false
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get("proxy_port", "8080")}
        overridable: false
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get("proxy_username", "")}
        overridable: false
    - proxy_password:
        required: false
    - proxyPassword:
        default: ${get("proxy_password", "")}
        overridable: false
    - trust_all_roots:
        required: false
    - trustAllRoots:
        default: ${get("trust_all_roots", "true")}
        overridable: false
    - x_509_hostname_verifier:
        required: false
    - x509HostnameVerifier:
        default: ${get("x_509_hostname_verifier", "allow_all")}
        overridable: false
    - trust_keystore:
        required: false
    - trustKeystore:
        default: ${get("trust_keystore", "")}
        overridable: false
    - trust_password:
        required: false
    - trustPassword:
        default: ${get("trust_password", "")}
        overridable: false
    - keystore:
        required: false
    - keystore_password:
        required: false
    - keystorePassword:
        default: ${get("keystore_password", "")}
        overridable: false
    - connect_timeout:
        required: false
    - connectTimeout:
        default: ${get("connect_timeout", "0")}
        overridable: false
    - socket_timeout:
        required: false
    - socketTimeout:
        default: ${get("socket_timeout", "0")}
        overridable: false
    - use_cookies:
        required: false
    - useCookies:
        default: ${get("use_cookies", "true")}
        overridable: false
    - keep_alive:
        required: false
    - keepAlive:
        default: ${get("keep_alive", "true")}
        overridable: false
    - connections_max_per_root:
        required: false
    - connectionsMaxPerRoot:
        default: ${get("connections_max_per_root", "2")}
        overridable: false
    - connections_max_total:
        required: false
    - connectionsMaxTotal:
        default: ${get("connections_max_total", "2")}
        overridable: false
    - headers:
        required: false
    - response_character_set:
        required: false
    - responseCharacterSet:
        default: ${get("response_character_set", "ISO-8859-1")}
        overridable: false
    - destination_file:
        required: false
    - destinationFile:
        default: ${get("destination_file", "")}
        overridable: false
    - follow_redirects:
        required: false
    - followRedirects:
        default: ${get("follow_redirects", "true")}
        overridable: false
    - query_params:
        required: false
    - queryParams:
        default: ${get("query_params", "")}
        overridable: false
    - query_params_are_URL_encoded:
        required: false
    - queryParamsAreURLEncoded:
        default: ${get("query_params_are_URL_encoded", "false")}
        overridable: false
    - query_params_are_form_encoded:
        required: false
    - queryParamsAreFormEncoded:
        default: ${get("query_params_are_form_encoded", "true")}
        overridable: false
    - form_params:
        required: false
    - formParams:
        default: ${get("form_params", "")}
        overridable: false
    - form_params_are_URL_encoded:
        required: false
    - formParamsAreURLEncoded:
        default: ${get("form_params_are_URL_encoded", "false")}
        overridable: false
    - source_file:
        required: false
    - sourceFile:
        default: ${get("source_file", "")}
        overridable: false
    - body:
        required: false
    - content_type:
        required: false
    - contentType:
        default: ${get("content_type", "text/plain")}
        overridable: false
    - request_character_set:
        required: false
    - requestCharacterSet:
        default: ${get("request_character_set", "ISO-8859-1")}
        overridable: false
    - multipart_bodies:
        required: false
    - multipartBodies:
        default: ${get("multipart_bodies", "")}
        overridable: false
    - multipart_bodies_content_type:
        required: false
    - multipartBodiesContentType:
        default: ${get("multipart_bodies_content_type", "text/plain; charset=ISO-8859-1")}
        overridable: false
    - multipart_files:
        required: false
    - multipartFiles:
        default: ${get("multipart_files", "")}
        overridable: false
    - multipart_files_content_type:
        required: false
    - multipartFilesContentType:
        default: ${get("multipart_files_content_type", "application/octet-stream")}
        overridable: false
    - multipart_values_are_URL_encoded:
        required: false
    - multipartValuesAreURLEncoded:
        default: ${get("multipart_values_are_URL_encoded", "false")}
        overridable: false
    - chunked_request_entity:
        required: false
    - chunkedRequestEntity:
        default: ${get("chunked_request_entity", "")}
        overridable: false
    - method
    - http_client_cookie_session:
        required: false
    - httpClientCookieSession:
        default: ${get("http_client_cookie_session", "")}
        overridable: false
    - http_client_pooling_connection_manager:
        required: false
    - httpClientPoolingConnectionManager:
        default: ${get("http_client_pooling_connection_manager", "")}
        overridable: false
    - valid_http_status_codes:
        default: ${range(200, 300)}

  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - return_result: ${'' if 'returnResult' not in locals() else returnResult}
    - error_message: ${returnResult if returnCode != '0' else ''}
    - return_code: ${returnCode}
    - status_code: ${'' if 'statusCode' not in locals() else statusCode}
  results:
    - SUCCESS : ${returnCode == '0' and int(statusCode) in self['valid_http_status_codes']}
    - FAILURE
