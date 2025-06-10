########################################################################################################################
#!!
#! @description: Executes a PATCH REST call.
#!
#! @input url: URL to which the call is made.
#! @input auth_type: Optional - Type of authentication used to execute the request on the target server. Valid: 'basic', 'digest', 'ntlm', 'anonymous' (no authentication) Default: 'basic'
#! @input username: Optional - Username used for URL authentication; for NTLM authentication.Format: 'domain\user
#! @input password: Optional - Password used for URL authentication.
#! @input preemptive_auth: Optional - If 'true' authentication info will be sent in the first request, otherwise a request with no authentication info will be made and if server responds with 401 and a header. like WWW-Authenticate: Basic realm="myRealm" only then will the authentication info will be sent. Default: 'true'
#! @input body: Optional - String to include in body for HTTP POST operation. If both <source_file> and body will be provided, the body input has priority over <source_file>; should not be provided for method=GET, HEAD, TRACE.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL. Default: 'false'
#! @input form_data: Optional - List containing body which should be sent as form data. Examples: 'formKey1=formValue1&formkey2=formValue2'
#! @input query_params: Optional - List containing query parameters to append to the URL. Examples: 'parameterName1=parameterValue1&parameterName2=parameterValue2;'
#! @input proxy_scheme: Optional - Proxy scheme for https proxy url.
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port. Default: '8080'
#! @input proxy_username: Optional - User used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input headers: Optional - List containing the headers to use for the request separated by new line (CRLF); header name - value pair will be separated by ":". Format: According to HTTP standard for headers (RFC 2616) Example: 'Accept:text/plain'
#! @input tls_version: Optional - This input allows a list of comma separated values of the specific protocols to be used. Valid: TLSv1.2, TLSv1.3. Default: 'TLSv1.3'
#! @input allowed_ciphers: Optional - A comma delimited list of ciphers to use. The value of this input will be ignored if 'tlsVersion' does not contain 'TLSv1.2' or 'TLSv1.3'.This capability is provided “as is”, please see product documentation for further security considerations. In order to connect successfully to the target host, it should accept at least one of the following ciphers. If this is not the case, it is the user's responsibility to configure the host accordingly or to update the list of allowed ciphers. Default: TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256,TLS_AES_128_GCM_SHA256 , Valid values for TLSv1.2: TLS_DHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_DHE_RSA_WITH_AES_256_CBC_SHA256,TLS_DHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_256_CBC_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA256, Valid Values for TLSv1.3 : TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256,TLS_AES_128_GCM_SHA256
#! @input keep_alive: Optional - Specifies whether to create a shared connection that will be used in subsequent calls. Default: 'true'
#! @input keystore: Optional - Location of the KeyStore file. Format: a URL or the local path to it. This input is empty if no HTTPS client authentication is used
#! @input keystore_password: Optional - Password associated with the KeyStore file.
#! @input trust_keystore: Optional - Location of the TrustStore file. Format: a URL or the local path to it
#! @input trust_password: Optional - Password associated with the trust_keystore file.
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Valid: 'strict', 'browser_compatible', 'allow_all' Default: 'allow_all'
#! @input connections_max_per_route: Optional - Maximum limit of connections on a per route basis. Default: '2'
#! @input connections_max_total: Optional - Maximum limit of connections in total. Default: '20'
#! @input use_cookies: Optional - Specifies whether to enable cookie tracking or not. Default: 'true'
#! @input follow_redirects: Optional - Specifies whether the 'Get' command automatically follows redirects.
#! @input destination_file: Optional - Absolute path of a file on disk where the entity returned by the response will be saved to.
#! @input request_character_set: Optional - Character encoding to be used for the HTTP response. Default: 'UTF-8'
#! @input content_type: Optional - Content type that should be set in the request header, representing the MIME-type of the data in the message body. Default: 'text/plain'
#! @input connect_timeout: Optional - Time in seconds to wait for a connection to be established. When 0 value is used, there is no limit on the amount of time allowed for the connection to be established. Default: '300'
#! @input execution_timeout: Optional - Time in seconds to wait for the operation to finish executing. When 0 value is used, there is no limit on the amount of time allowed for the operation to finish executing. Default: '300'
#! @input socket_timeout: Optional - Time in seconds to wait for data to be retrieved (maximum period inactivity. between two consecutive data packets) When 0 value is used, there is no limit on the amount of time allowed for the data to be retrieved. Default: '300'
#! @input valid_http_status_codes: Optional - List/array of HTTP status codes considered to be successful. Example: [202, 204] Default: 'range(200, 300)'
#! @input form_params_are_url_encoded: Optional - If true <form_params> will be encoded (according to the url encoding standard). Default: 'false'
#! @input query_params_are_url_encoded: Optional - Whether to encode (according to the url encoding standard) the <query_params>. Default: 'false'
#! @input query_params_are_form_encoded: Optional - Whether to encode the <query_params> in the form request format. Default: 'true'
#! @input source_file: Optional - Absolute path of a file on disk from where to read the entity for the http request; should not be provided for method=GET, HEAD, TRACE. source_file input takes precedence over multipart_files input
#! @input http_client_cookie_session: Optional - Session object that holds the cookies if the <use_cookies> input is true.
#! @input http_client_pooling_connection_manage: Optional - GlobalSessionObject that holds the http client pooling connection manager.
#!
#! @output return_result: The response of the operation in case of success or the error message otherwise.
#! @output status_code: Status code of the HTTP call.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#! @output final_location: The final location after redirects. Format: URL
#! @output reason_phrase: The reason phrase from the origin HTTP response. This depends on the status code and are according to RFC 1945 and RFC 2048Examples: Values (HTTP 1.1): Continue, Temporary Redirect, Method Not Allowed, Conflict, Precondition Failed, Request Too Long, Request-URI Too Long, Unsupported Media Type, Multiple Choices, See Other, Use Proxy, Payment Required, Not Acceptable, Proxy Authentication Required, Request Timeout, Switching Protocols, Non Authoritative Information, Reset Content, Partial Content, Gateway Timeout, Http Version Not Supported, Gone, Length Required, Requested Range Not Satisfiable, Expectation Failed
#! @output protocol_version: The HTTP protocol version. Examples: HTTP/1.1
#! @output exception: Stacktrace in case of failure.
#!
#! @result SUCCESS: Operation succeeded (statusCode is contained in valid_http_status_codes list).
#! @result FAILURE: Operation failed (statusCode is not contained in valid_http_status_codes list).
#!!#
########################################################################################################################
namespace: io.cloudslang.base.http.v2_0
flow:
  name: http_client_patch_v2
  inputs:
    - url:
        required: false
    - auth_type:
        default: BASIC
        required: false
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - preemptive_auth:
        default: 'true'
        required: false
    - body:
        required: false
    - trust_all_roots:
        default: 'false'
        required: false
    - form_data:
        required: false
    - query_params:
        required: false
    - proxy_scheme:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - headers:
        required: false
    - tls_version:
        default: TLSv1.3
        required: false
    - allowed_ciphers:
        default: 'TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256,TLS_AES_128_GCM_SHA256'
        required: false
    - keep_alive:
        default: 'true'
        required: false
    - keystore:
        required: false
    - keystore_password:
        required: false
        sensitive: true
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - x_509_hostname_verifier:
        default: strict
        required: false
    - connections_max_per_route:
        default: '2'
        required: false
    - connections_max_total:
        default: '20'
        required: false
    - use_cookies:
        default: 'true'
        required: false
    - follow_redirects:
        required: false
    - destination_file:
        required: false
    - request_character_set:
        default: UTF-8
        required: false
    - content_type:
        default: text/plain
        required: false
    - connect_timeout:
        default: '300'
        required: false
    - execution_timeout:
        default: '300'
        required: false
    - socket_timeout:
        default: '300'
        required: false
    - valid_http_status_codes:
        default: 'str(list(range(200, 300)))'
        required: false
    - form_params_are_url_encoded:
        default: 'false'
        required: false
    - query_params_are_url_encoded:
        default: 'false'
        required: false
    - query_params_are_form_encoded:
        default: 'true'
        required: false
    - source_file:
        required: false
    - http_client_cookie_session:
        required: false
    - http_client_pooling_connection_manage:
        required: false
  workflow:
    - http_client_action_patch_v2:
        do:
          io.cloudslang.base.http.v2_0.http_client_action_v2:
            - url: '${url}'
            - method: PATCH
            - auth_type: '${auth_type}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - preemptive_auth: '${preemptive_auth}'
            - body: '${body}'
            - trust_all_roots: '${trust_all_roots}'
            - form_data: '${form_data}'
            - form_params_are_url_encoded: '${form_params_are_url_encoded}'
            - query_params: '${query_params}'
            - query_params_are_url_encoded: '${query_params_are_url_encoded}'
            - query_params_are_form_encoded: '${query_params_are_form_encoded}'
            - proxy_scheme: '${proxy_scheme}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - headers: '${headers}'
            - tls_version: '${tls_version}'
            - allowed_ciphers: '${allowed_ciphers}'
            - keep_alive: '${keep_alive}'
            - keystore: '${keystore}'
            - keystore_password:
                value: '${keystore_password}'
                sensitive: true
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - use_cookies: '${use_cookies}'
            - follow_redirects: '${follow_redirects}'
            - destination_file: '${destination_file}'
            - request_character_set: '${request_character_set}'
            - content_type: '${content_type}'
            - connect_timeout: '${connect_timeout}'
            - execution_timeout: '${execution_timeout}'
            - socket_timeout: '${socket_timeout}'
            - valid_http_status_codes: '${valid_http_status_codes}'
            - source_file: '${source_file}'
            - http_client_cookie_session: '${http_client_cookie_session}'
            - http_client_pooling_connection_manage: '${http_client_pooling_connection_manage}'
        publish:
          - return_result
          - status_code
          - return_code
          - response_headers
          - final_location
          - reason_phrase
          - protocol_version
          - exception
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result: '${return_result}'
    - status_code: '${status_code}'
    - return_code: '${return_code}'
    - response_headers: '${response_headers}'
    - final_location: '${final_location}'
    - reason_phrase: '${reason_phrase}'
    - protocol_version: '${protocol_version}'
    - exception: '${exception}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      http_client_action_patch_v2:
        x: 320
        'y': 160
        navigate:
          e67d83f5-3366-3128-1416-6ae150d8e800:
            targetId: 911587a9-79ba-1874-9a81-8252e8937c3d
            port: SUCCESS
    results:
      SUCCESS:
        911587a9-79ba-1874-9a81-8252e8937c3d:
          x: 680
          'y': 160