########################################################################################################################
#!!
#! @description: Returns a list of groups whose names contain a query string. A list of group names can be provided to exclude groups from the results.
#!
#! @input url: URL to which the call is made.
#! @input username: Username used for URL authentication; for NTLM authentication.Format: 'domain\user'
#! @input password: Password used for URL authentication.
#! @input query: The string to find in group names.
#! @input exclude: A group to exclude from the result. To exclude multiple groups, provide an ampersand-separated list. For example, exclude=group1&exclude=group2.
#! @input max_results: The maximum number of groups to return. The maximum number of groups that can be returned is limited by the system property jira.ajax.autocomplete.limit. Format: int32
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - User name used when connecting to the proxy.
#! @input proxy_password: Optional - Password used for URL authentication.
#! @input tls_version: Optional - This input allows a list of comma separated values of the specific protocols to be used.
#!                     Valid: SSLv3, TLSv1, TLSv1.1, TLSv1.2.
#!                     Default: 'TLSv1.2'
#! @input allowed_cyphers: Optional - A comma delimited list of cyphers to use. The value of this input will be ignored
#!                         if 'tlsVersion' does not contain 'TLSv1.2'.This capability is provided “as is”, please see product
#!                         documentation for further security considerations. In order to connect successfully to the target
#!                         host, it should accept at least one of the following cyphers. If this is not the case, it is the
#!                         user's responsibility to configure the host accordingly or to update the list of allowed cyphers.
#!                         Default: TLS_DHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
#!                         TLS_DHE_RSA_WITH_AES_256_CBC_SHA256,TLS_DHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,
#!                         TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
#!                         TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_256_CBC_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA256
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#! @input trust_keystore: Optional - The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Default value: ''
#! @input trust_password: Optional - The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input connect_timeout: Optional - Time in seconds to wait for a connection to be established.
#!                         Default: '0' (infinite)
#! @input socket_timeout: Optional - Time in seconds to wait for data to be retrieved.
#!                        Default: '0' (infinite)
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output group_names: A list of group names matching the string separated by comma.
#! @output return_result: The response of the operation in case of success or the error message otherwise.
#! @output error_message: Return_result if status_code different than '200'.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: Status code of the HTTP call.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#!
#! @result SUCCESS: Groups found successfully.
#! @result FAILURE: Failed to find the groups.
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.groups
flow:
  name: find_groups
  inputs:
    - url
    - username:
        required: true
    - password:
        required: true
        sensitive: true
    - query:
        required: false
    - exclude:
        required: false
    - max_results:
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
    - tls_version:
        required: false
    - allowed_cyphers:
        required: false
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - connect_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
        required: false
    - worker_group:
        required: false
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: '${url+"/rest/api/3/groups/picker?query="+("" if bool(query)==False else query)+"&exclude="+("" if bool(exclude)==False else exclude)+"&maxResults="+("" if bool(max_results)==False else max_results)}'
            - auth_type: basic
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - tls_version: '${tls_version}'
            - allowed_cyphers: '${allowed_cyphers}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - content_type: application/json
            - worker_group: '${worker_group}'
        publish:
          - error_message
          - return_code
          - status_code
          - response_headers
          - return_result
        navigate:
          - SUCCESS: find_groups_group_names
          - FAILURE: test_for_http_error
    - find_groups_group_names:
        do:
          io.cloudslang.atlassian.jira.v1.utils.find_groups_group_names:
            - return_result: '${return_result}'
        publish:
          - group_names
        navigate:
          - SUCCESS: SUCCESS
    - test_for_http_error:
        do:
          io.cloudslang.atlassian.jira.v1.utils.test_for_http_error:
            - return_result: '${return_result}'
        publish:
          - error_message
        navigate:
          - FAILURE: FAILURE
  outputs:
    - group_names: '${group_names}'
    - return_result: '${return_result}'
    - error_message: '${error_message}'
    - return_code: '${return_code}'
    - status_code: '${status_code}'
    - response_headers: '${response_headers}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_get:
        x: 100
        'y': 250
      find_groups_group_names:
        x: 400
        'y': 125
        navigate:
          4f2d260d-6a3b-c92e-483a-d1e52a6ff5c6:
            targetId: e2b5055b-3c93-e8f8-50ec-2e0898003188
            port: SUCCESS
      test_for_http_error:
        x: 400
        'y': 375
        navigate:
          1270a5f2-64db-7389-9977-804d0b89f340:
            targetId: 6fdef2ca-8747-5018-53fc-d5a76259fd68
            port: FAILURE
    results:
      SUCCESS:
        e2b5055b-3c93-e8f8-50ec-2e0898003188:
          x: 700
          'y': 125
      FAILURE:
        6fdef2ca-8747-5018-53fc-d5a76259fd68:
          x: 700
          'y': 375