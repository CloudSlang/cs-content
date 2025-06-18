########################################################################################################################
#!!
#! @description: Executes a DELETE REST call.
#!
#! @input url: URL to which the call is made.
#! @input auth_type: Optional - Type of authentication used to execute the request on the target server. Valid: 'basic', 'digest', 'anonymous' (no authentication) Default: 'basic'
#! @input username: Optional - Username used for URL authentication;
#! @input password: Optional - Password used for URL authentication.
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port. Default: '8080'
#! @input proxy_scheme: Optional - Proxy scheme for https proxy url.
#! @input proxy_username: Optional - User used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input tls_version: Optional - This input allows a list of comma separated values of the specific protocols to be used. Valid: TLSv1.2, TLSv1.3. Default: 'TLSv1.3'
#! @input allowed_ciphers: Optional - A comma delimited list of ciphers to use. While using TLSv1.3, the operation handles cipher selection dynamically based on the negotiated protocol.By default, when you're using TLSv 1.3, the following ciphers will automatically be selected: TLS_AES_128_GCM_SHA256, TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256.This capability is provided “as is”, please see product documentation for further security considerations. In order to connect successfully to the target host, it should accept at least one of the following ciphers. If this is not the case, it is the user's responsibility to configure the host accordingly or to update the list of allowed ciphers.Default value: TLS_AES_128_GCM_SHA256, TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256 Valid values for TLSv1.2: TLS_DHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_DHE_RSA_WITH_AES_256_CBC_SHA256,TLS_DHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_256_CBC_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA256.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL. Default: 'false'
#! @input certificate: Optional - Certificate for SSL Validation used when verify parameter is True.
#! @input follow_redirects: Optional - Specifies whether the HTTP request should automatically follow redirects. Default: true
#! @input execution_timeout: Optional - Time in seconds to wait for the operation to finish executing. When 0 value is used, there is no limit on the amount of time allowed for the operation to finish executing. Default: '300'
#! @input connect_timeout: Optional - Time in seconds to wait for a connection to be established. When 0 value is used, there is no limit on the amount of time allowed for the connection to be established. Default: '300'
#! @input socket_timeout: Optional - Time in seconds to wait for data to be retrieved (maximum period inactivity. between two consecutive data packets) When 0 value is used, there is no limit on the amount of time allowed for the data to be retrieved. Default: '300'
#! @input connections_max_per_route: Optional - Maximum limit of connections on a per route basis. Default: '2'
#! @input connections_max_total: Optional - Maximum limit of connections in total. Default: '20'
#! @input response_character_set: Optional - Character encoding to be used for the HTTP response. Default: 'UTF-8'
#! @input headers: Optional - List containing the headers to use for the request separated by new line (CRLF); header name - value pair will be separated by ":". Format: According to HTTP standard for headers (RFC 2616) Example: 'Accept:text/plain'
#! @input query_params: Optional - List containing query parameters to append to the URL. Examples: 'parameterName1=parameterValue1&parameterName2=parameterValue2;'
#! @input content_type: Optional - Content type that should be set in the request header, representing the MIME-type of the data in the message body. Default: 'text/plain'
#! @input destination_file: Optional - Absolute path of a file on disk where the entity returned by the response will be saved to.
#! @input source_file: Optional - Absolute path of a file on disk from where to read the entity for the http request; should not be provided for method=GET, HEAD, TRACE. source_file input takes precedence over multipart_files input
#! @input hostname_verifier: Optional - Specifies whether the server's hostname must match a domain name in the certificate's subject Common Name (CN) or Subject Alternative Name (SAN) fields. Default : True  Valid values: True, False
#!
#! @result SUCCESS: Operation succeeded (statusCode is contained in valid_http_status_codes list).
#! @result FAILURE: Operation failed (statusCode is not contained in valid_http_status_codes list).
#!!#
########################################################################################################################
namespace: io.cloudslang.base.http.v2_0
flow:
  name: http_client_delete
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
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_scheme:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - tls_version:
        default: TLSv1.3
        required: false
    - allowed_ciphers:
        default: 'TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256,TLS_AES_128_GCM_SHA256'
        required: false
    - trust_all_roots:
        default: 'false'
        required: false
    - certificate:
        sensitive: true
        required: false
    - follow_redirects:
        required: false
        default: 'true'
    - execution_timeout:
        default: '300'
        required: false
    - connect_timeout:
        default: '300'
        required: false
    - socket_timeout:
        default: '300'
        required: false
    - connections_max_per_route:
        default: '2'
        required: false
    - connections_max_total:
        default: '20'
        required: false
    - response_character_set:
        default: UTF-8
        required: false
    - headers:
        required: false
    - query_params:
        required: false
    - content_type:
        default: text/plain
        required: false
    - destination_file:
        required: false
    - source_file:
        required: false
    - hostname_verifier:
        required: false
        default: 'false'
  workflow:
    - http_client_action_delete:
        do:
          io.cloudslang.base.http.v2_0.http_client_action:
            - url: '${url}'
            - method: DELETE
            - auth_type: '${auth_type}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - certificate:
                value: '${certificate}'
                sensitive: true
            - proxy_scheme: '${proxy_scheme}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - headers: '${headers}'
            - tls_version: '${tls_version}'
            - allowed_ciphers: '${allowed_ciphers}'
            - follow_redirects: '${follow_redirects}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - response_character_set: '${response_character_set}'
            - content_type: '${content_type}'
            - destination_file: '${destination_file}'
            - source_file: '${source_file}'
            - connect_timeout: '${connect_timeout}'
            - execution_timeout: '${execution_timeout}'
            - socket_timeout: '${socket_timeout}'
            - hostname_verifier: '${hostname_verifier}'
        publish:
          - return_result
          - status_code
          - response_headers
          - return_code
          - exception
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
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      http_client_action_delete:
        x: 360
        'y': 200
        navigate:
          6ac8ed93-fcb4-e0d8-a95f-424aa6691eaf:
            targetId: 38f52a00-97c2-b9d9-0ea5-45c3211b131d
            port: SUCCESS
    results:
      SUCCESS:
        38f52a00-97c2-b9d9-0ea5-45c3211b131d:
          x: 600
          'y': 200

