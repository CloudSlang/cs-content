########################################################################################################################
#!!
#! @description: Returns the key and value of an issue's property.
#!
#! @input url: Jira domain
#! @input username: Username for the API authenticator
#! @input password: Password for the API authenticator
#! @input start_at: The index of the first item to return in a page of results (page offset).
#! @input max_results: The maximum number of items to return per page.
#! @input group_id: The ID of a group. To specify multiple IDs, pass multiple groupId parameters. For example, groupId=5b10a2844c20165700ede21g&groupId=5b10ac8d82e05b22cc7d4ef5.
#! @input group_name: The name of a group. To specify multiple names, pass multiple groupName parameters. For example, groupName=administrators&groupName=jira-software-users.
#! @input proxy_host: The proxy server used to access the web site.
#! @input proxy_port: The proxy server port. Default value: 8080. Valid values: -1, and positive integer values. When the value is '-1' the default port of the scheme, specified in the 'proxy_host', will be used.
#! @input proxy_username: The user name used when connecting to the proxy. The 'auth_type' input will be used to choose authentication type. The 'Basic' and 'Digest' proxy authentication type are supported.
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
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
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default value: false Valid values: true, false
#! @input trust_keystore: Optional - The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Default value: ''
#! @input trust_password: Optional - The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input x509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. The hostname verification system prevents communication with other hosts other than the ones you intended. This is done by checking that the hostname is in the subject alternative name extension of the certificate. This system is designed to ensure that, if an attacker(Man In The Middle) redirects traffic to his machine, the client will not accept the connection. If you set this input to "allow_all", this verification is ignored and you become vulnerable to security attacks. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". From the security perspective, to provide protection against possible Man-In-The-Middle attacks, we strongly recommend to use "strict" option. Default value: strict Valid values: strict, browser_compatible, allow_all
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0' represents an infinite timeout. Default value: 0 Format: an integer representing seconds Examples: 10, 20
#! @input socket_timeout: Optional - Time in seconds to wait for data to be retrieved.
#!                        Default: '0' (infinite)
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output retrun_result: The result as JSON.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: Status code of the HTTP call. 200 - Returned if the request is successful.400 - Returned if the request is not valid.401 - Returned if the authentication credentials are incorrect or missing.403 - Returned if the user does not have the necessary permission.
#! @output response_headers: Response headers string from the HTTP Client REST call
#! @output error_message: The API call error or the retrieved entity error as JSON.
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.groups
flow:
  name: bulk_get_groups
  inputs:
    - url
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - start_at:
        default: '0'
        required: false
    - max_results:
        default: '50'
        required: false
    - group_id:
        required: false
    - group_name:
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
    - tls_version
    - allowed_cyphers
    - trust_all_roots:
        default: 'false'
        required: false
    - trust_keystore: "${get_sp('io.cloudslang.base.http.trust_keystore')}"
    - trust_password:
        default: "${get_sp('io.cloudslang.base.http.trust_password')}"
        sensitive: true
    - x509_hostname_verifier:
        default: strict
        required: false
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
            - url: "${url + '/rest/api/3/group/bulk'}"
            - auth_type: null
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - tls_version: '${tls_version}'
            - allowed_cyphers: '${allowed_cyphers}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - headers: 'Accept: application/json'
            - query_params: '${"startAt=" + start_at + "&" + "maxResults=" + max_results + ("" if bool(group_id) == False else "groupId=" + group_id.replace(",","&groupId=")) +  ("" if bool(group_name) == False else "groupName=" + group_name.replace(",", "&groupName="))}'
            - content_type: application/json
        publish:
          - error_message
          - return_result
          - return_code: '${return_code}'
          - status_code: '${status_code}'
          - response_headers: '${response_headers}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: test_for_http_error
    - test_for_http_error:
        do:
          io.cloudslang.atlassian.jira.v1.utils.test_for_http_error:
            - status_code: '${status_code}'
            - return_result: '${return_result}'
        publish:
          - return_result: '${return_result}'
        navigate:
          - FAILURE: on_failure
  outputs:
    - retrun_result: '${return_result}'
    - return_code: '${return_code}'
    - status_code: '${status_code}'
    - response_headers: '${response_headers}'
    - error_message: '${error_message}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      http_client_get:
        x: 200
        'y': 120
        navigate:
          60e4dc2a-2e6f-11fb-aa85-46e15dea3b0d:
            targetId: 5b7be3b7-4029-10da-277d-f13d1099b684
            port: SUCCESS
      test_for_http_error:
        x: 200
        'y': 320
    results:
      SUCCESS:
        5b7be3b7-4029-10da-277d-f13d1099b684:
          x: 600
          'y': 120
