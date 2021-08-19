########################################################################################################################
#!!
#! @description: Searches for issues using JQL. If the JQL query expression is too large to be encoded as a query parameter, use the POST version of this resource.
#!
#! @input url: Jira url
#! @input username: Username for the API authenticator
#! @input password: Password for the API authenticator
#! @input jql: The JQL that defines the search. Note:
#!              
#!             If no JQL expression is provided, all issues are returned.
#!             username and userkey cannot be used as search terms due to privacy reasons. Use accountId instead.
#!             If a user has hidden their email address in their user profile, partial matches of the email address will not find the user. An exact match is required.
#! @input start_at: The index of the first item to return in a page of results (page offset).
#!                   
#!                  Default: 0
#! @input max_results: The maximum number of items to return per page. To manage page size, Jira may return fewer items per page where a large number of fields are requested. The greatest number of items returned per page is achieved when requesting id or key only. Default: 50.
#! @input validate_query: Determines how to validate the JQL query and treat the validation results. Supported values are:
#!                         
#!                        strict Returns a 400 response code if any errors are found, along with a list of all errors (and warnings).
#!                        warn Returns all errors as warnings.
#!                        none No validation is performed.
#!                        true Deprecated A legacy synonym for strict.
#!                        false Deprecated A legacy synonym for warn.
#!                        Note: If the JQL is not correctly formed a 400 response code is returned, regardless of the validateQuery value.
#!                         
#!                        Default: strict
#!                        Valid values: strict, warn, none, true, false
#! @input fields: A list of fields to return for each issue, use it to retrieve a subset of fields. This parameter accepts a comma-separated list. Expand options include:
#!                 
#!                *all Returns all fields.
#!                *navigable Returns navigable fields.
#!                Any issue field, prefixed with a minus to exclude.
#!                Examples:
#!                 
#!                summary,comment Returns only the summary and comments fields.
#!                -description Returns all navigable (default) fields except description.
#!                *all,-comment Returns all fields except comments.
#!                This parameter may be specified multiple times. For example, fields=field1,field2&fields=field3.
#!                 
#!                Note: All navigable fields are returned by default. This differs from GET issue where the default is all fields.
#! @input expand: Use expand to include additional information about issues in the response. This parameter accepts a comma-separated list. Expand options include:
#!                 
#!                renderedFields Returns field values rendered in HTML format.
#!                names Returns the display name of each field.
#!                schema Returns the schema describing a field type.
#!                transitions Returns all possible transitions for the issue.
#!                operations Returns all possible operations for the issue.
#!                editmeta Returns information about how each field can be edited.
#!                changelog Returns a list of recent updates to an issue, sorted by date, starting from the most recent.
#!                versionedRepresentations Instead of fields, returns versionedRepresentations a JSON array containing each version of a field's value, with the highest numbered item representing the most recent version.
#! @input properties: A list of issue property keys for issue properties to include in the results. This parameter accepts a comma-separated list. A maximum of 5 issue property keys can be specified.
#! @input fields_by_keys: Reference fields by their key (rather than ID).
#!                         
#!                        Default: false
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
#! @output retrun_result: The entire HTTP result as JSON.
#! @output issues_list: A comma separated list of issues identified by their ids..
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: Status code of the HTTP call. 200 - Returned if the request is successful.
#!                      400 - Returned if the JQL query is invalid.
#!                      401 - Returned if the authentication credentials are incorrect or missing.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#! @output error_message: The API call error or the retrieved entity error as JSON.
#!
#! @result FAILURE: Operation failed
#! @result SUCCESS: Search successful
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.issue_search
flow:
  name: search_for_issue_using_jql_get
  inputs:
    - url
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - jql:
        required: false
    - start_at:
        default: '0'
        required: false
    - max_results:
        default: '50'
        required: false
    - validate_query:
        default: strict
        required: false
    - fields:
        required: false
    - expand:
        required: false
    - properties:
        required: false
    - fields_by_keys:
        default: 'false'
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
    - trust_keystore:
        default: "${get_sp('io.cloudslang.base.http.trust_keystore')}"
        required: false
    - trust_password:
        default: "${get_sp('io.cloudslang.base.http.trust_password')}"
        required: false
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
            - url: "${url + '/rest/api/3/search'}"
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
            - query_params: '${("" if bool(jql) == False else "jql=" + jql) + ("" if bool(start_at) == False else "&startAt=" + start_at) + ("" if bool(max_results) == False else "&maxResults=" + max_results) + ("" if bool(validate_query) == False else "&validateQuery=" + validate_query) + ("" if bool(fields) == False else "&fields=" + fields) + ("" if bool(expand) == False else "&expand=" + expand) + ("" if bool(properties) == False else "&properties=" + properties) + ("" if bool(fields_by_keys) == False else "&fieldsByKeys=" + fields_by_keys)}'
            - content_type: application/json
        publish:
          - error_message
          - return_result
          - return_code: '${return_code}'
          - status_code: '${status_code}'
          - response_headers: '${response_headers}'
        navigate:
          - SUCCESS: get_issue_id_from_search
          - FAILURE: test_for_http_error
    - get_issue_id_from_search:
        do:
          io.cloudslang.atlassian.jira.v1.utils.get_issue_id_from_search:
            - return_result: '${return_result}'
        publish:
          - issues_list
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - test_for_http_error:
        do:
          io.cloudslang.atlassian.jira.v1.utils.test_for_http_error:
            - status_code: '${status_code}'
            - return_result: '${return_result}'
        publish:
          - error_message
        navigate:
          - FAILURE: on_failure
  outputs:
    - retrun_result: '${return_result}'
    - issues_list: '${issues_list}'
    - return_code: '${return_code}'
    - status_code: '${status_code}'
    - response_headers: '${response_headers}'
    - error_message: '${error_message}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_get:
        x: 200
        'y': 240
      get_issue_id_from_search:
        x: 360
        'y': 240
        navigate:
          cc2823d8-0add-76dc-2145-1c9ebc8ed054:
            targetId: 38c5fa27-1519-6cef-b53e-2bd67c8bf05d
            port: SUCCESS
      test_for_http_error:
        x: 200
        'y': 400
    results:
      SUCCESS:
        38c5fa27-1519-6cef-b53e-2bd67c8bf05d:
          x: 560
          'y': 240
