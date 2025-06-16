########################################################################################################################
#!!
#! @description: Executes an HTTP POST call towards a specified endpoint.
#!               By default the flow allows you to specify anything in the request body of the HTTP POST call
#!               (also known as a POST RAW call). You can also specify the Content-Type header for POST RAW request
#!               using the 'content-type' input.
#!
#! @input url: URL to which the call is made.
#! @input auth_type: Optional - Type of authentication used to execute the request on the target server. Valid: 'basic', 'digest', 'ntlm', 'anonymous' (no authentication) Default: 'basic'
#! @input username: Optional - Username used for URL authentication; for NTLM authentication.Format: 'domain\user
#! @input password: Optional - Password used for URL authentication.
#! @input preemptive_auth: Optional - If 'true' authentication info will be sent in the first request, otherwise a request with no authentication info will be made and if server responds with 401 and a header. like WWW-Authenticate: Basic realm="myRealm" only then will the authentication info will be sent. Default: 'true'
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port. Default: '8080'
#! @input proxy_username: Optional - User used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input proxy_scheme: Optional - Proxy scheme for https proxy url.
#! @input tls_version: Optional - This input allows a list of comma separated values of the specific protocols to be used. Valid: TLSv1.2, TLSv1.3. Default: 'TLSv1.3'
#! @input allowed_ciphers: Optional - A comma delimited list of ciphers to use. While using TLSv1.3, the operation handles cipher selection dynamically based on the negotiated protocol.By default, when you're using TLSv 1.3, the following ciphers will automatically be selected: TLS_AES_128_GCM_SHA256, TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256.This capability is provided “as is”, please see product documentation for further security considerations. In order to connect successfully to the target host, it should accept at least one of the following ciphers. If this is not the case, it is the user's responsibility to configure the host accordingly or to update the list of allowed ciphers.Default value: TLS_AES_128_GCM_SHA256, TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256 Valid values for TLSv1.2: TLS_DHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_DHE_RSA_WITH_AES_256_CBC_SHA256,TLS_DHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_256_CBC_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA256.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL. Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Valid: 'strict', 'allow_all' Default: 'strict'
#! @input follow_redirects: Optional - Specifies whether the 'Get' command automatically follows redirects. Default: 'true'.
#! @input trust_keystore: Optional - Location of the TrustStore file. Format: a URL or the local path to it
#! @input trust_password: Optional - Password associated with the trust_keystore file.
#! @input keystore: Optional - Location of the KeyStore file. Format: a URL or the local path to it. This input is empty if no HTTPS client authentication is used
#! @input keystore_password: Optional - Password associated with the KeyStore file.
#! @input request_character_set: Optional - Character encoding to be used for the HTTP response. Default: 'UTF-8'
#! @input execution_timeout: Optional - Time in seconds to wait for the operation to finish executing. When 0 value is used, there is no limit on the amount of time allowed for the operation to finish executing. Default: '300'
#! @input connect_timeout: Optional - Time in seconds to wait for a connection to be established. When 0 value is used, there is no limit on the amount of time allowed for the connection to be established. Default: '300'
#! @input socket_timeout: Optional - Time in seconds to wait for data to be retrieved (maximum period inactivity. between two consecutive data packets) When 0 value is used, there is no limit on the amount of time allowed for the data to be retrieved. Default: '300'
#! @input keep_alive: Optional - Specifies whether to create a shared connection that will be used in subsequent calls. Default: 'true'
#! @input connections_max_per_route: Optional - Maximum limit of connections on a per route basis. Default: '2'
#! @input connections_max_total: Optional - Maximum limit of connections in total. Default: '20'
#! @input headers: Optional - List containing the headers to use for the request separated by new line (CRLF); header name - value pair will be separated by ":". Format: According to HTTP standard for headers (RFC 2616) Example: 'Accept:text/plain'
#! @input query_params: Optional - List containing query parameters to append to the URL. Examples: 'parameterName1=parameterValue1&parameterName2=parameterValue2;'
#! @input content_type: Optional - Content type that should be set in the request header, representing the MIME-type of the data in the message body. Default: 'text/plain'
#! @input body: Optional - String to include in body for HTTP POST operation. If both <source_file> and body will be provided, the body input has priority over <source_file>; should not be provided for method=GET, HEAD, TRACE.
#!
#! @output return_result: The response of the operation in case of success or the error message otherwise.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: Status code of the HTTP call.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#! @output exception: Return_result if status_code is not contained in interval between '200' and '299'
#!
#! @result FAILURE: Operation failed (statusCode is not contained in valid_http_status_codes list).
#! @result SUCCESS: Operation succeeded (statusCode is contained in valid_http_status_codes list).
#!!#
########################################################################################################################
namespace: io.cloudslang.base.http.v2_0
flow:
  name: http_client_post
  inputs:
    - url
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
    - proxy_scheme:
        required: false
    - tls_version:
        default: TLSv1.3
        required: false
    - allowed_ciphers:
        default: 'TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256,TLS_AES_128_GCM_SHA256'
        required: false
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
        required: false
    - follow_redirects:
        required: false
        default: 'true'
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - keystore:
        required: false
    - keystore_password:
        required: false
        sensitive: true
    - request_character_set:
        default: UTF-8
        required: false
    - execution_timeout:
        default: '300'
        required: false
    - connect_timeout:
        default: '300'
        required: false
    - socket_timeout:
        default: '300'
        required: false
    - keep_alive:
        default: 'true'
        required: false
    - connections_max_per_route:
        default: '2'
        required: false
    - connections_max_total:
        default: '20'
        required: false
    - headers:
        required: false
    - query_params:
        required: false
    - content_type:
        default: text/plain
        required: false
    - body:
        required: false
  workflow:
    - http_client_action_post:
        do:
          io.cloudslang.base.http.v2_0.http_client_action:
            - auth_type: '${auth_type}'
            - url: '${url}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - preemptive_auth: '${preemptive_auth}'
            - method: POST
            - body: '${body}'
            - trust_all_roots: '${trust_all_roots}'
            - query_params: '${query_params}'
            - proxy_scheme: '${proxy_scheme}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - headers: '${headers}'
            - proxy_password: '${proxy_password}'
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
            - follow_redirects: '${follow_redirects}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - request_character_set: '${request_character_set}'
            - content_type: '${content_type}'
            - connect_timeout: '${connect_timeout}'
            - execution_timeout: '${execution_timeout}'
            - socket_timeout: '${socket_timeout}'
        publish:
          - return_result
          - status_code
          - return_code
          - exception
          - response_headers
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result
    - return_code
    - status_code
    - response_headers
    - exception
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_action_post:
        x: 320
        'y': 160
        navigate:
          b31fda97-b68d-cc53-26ab-e26e0f70db2f:
            targetId: 6d69e7d3-31b2-176f-0f2c-7dab74121d08
            port: SUCCESS
    results:
      SUCCESS:
        6d69e7d3-31b2-176f-0f2c-7dab74121d08:
          x: 640
          'y': 160

