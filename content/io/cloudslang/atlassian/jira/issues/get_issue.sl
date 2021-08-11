########################################################################################################################
#!!
#! @description: Returns the details for an issue.
#!
#! @input url: Jira url.
#! @input username: Username for the API authenticator
#! @input password: Password for the API authenticator
#! @input issue_id_or_key: The ID or key of the issue.
#! @input fields: A list of fields to return for the issue. This parameter accepts a comma-separated list. Use it to retrieve a subset of fields. Allowed values:*all Returns all fields.*navigable Returns navigable fields.Any issue field, prefixed with a minus to exclude.Examples:summary,comment Returns only the summary and comments fields.-description Returns all (default) fields except description.*navigable,-comment Returns all navigable fields except comment. For example, fields=field1,field2
#! @input fields_by_keys: Whether fields in fields are referenced by keys rather than IDs. This parameter is useful where fields have been added by a connect app and a field's key may differ from its ID. Values: true/false
#! @input expand: Use expand to include additional information about the issues in the response. This parameter accepts a comma-separated list. Expand options include:
#!                 
#!                renderedFields Returns field values rendered in HTML format.
#!                names Returns the display name of each field.
#!                schema Returns the schema describing a field type.
#!                transitions Returns all possible transitions for the issue.
#!                editmeta Returns information about how each field can be edited.
#!                changelog Returns a list of recent updates to an issue, sorted by date, starting from the most recent.
#!                versionedRepresentations Returns a JSON array for each version of a field's value, with the highest number representing the most recent version. Note: When included in the request, the fields parameter is ignored.
#! @input properties: A list of issue properties to return for the issue. This parameter accepts a comma-separated list. Allowed values:*all Returns all issue properties.Any issue property key, prefixed with a minus to exclude.Examples:*all Returns all properties.*all,-prop1 Returns all properties except prop1.prop1,prop2 Returns prop1 and prop2 properties.This parameter may be specified multiple times. For example, properties=prop1,prop2& properties=prop3.
#! @input update_history: Whether the project in which the issue is created is added to the user's Recently viewed project list, as shown under Projects in Jira. This also populates the JQL issues search lastViewed field.
#! @input proxy_host: The proxy server used to access the web site.
#! @input proxy_port: The proxy server port. Default value: 8080. Valid values: -1, and positive integer values. When the value is '-1' the default port of the scheme, specified in the 'proxy_host', will be used.
#! @input proxy_username: The user name used when connecting to the proxy. The 'auth_type' input will be used to choose authentication type. The 'Basic' and 'Digest' proxy authentication type are supported.
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
#! @input tls_version: Optional - This input allows a list of comma separated values of the specific protocols to be used.
#!                     Valid: SSLv3, TLSv1, TLSv1.1, TLSv1.2.
#!                     Default: 'TLSv1.2'
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
#! @input allowed_cyphers: Optional - A comma delimited list of cyphers to use. The value of this input will be ignored
#!                         if 'tlsVersion' does not contain 'TLSv1.2'.This capability is provided “as is”, please see product
#!                         documentation for further security considerations. In order to connect successfully to the target
#!                         host, it should accept at least one of the following cyphers. If this is not the case, it is the
#!                         user's responsibility to configure the host accordingly or to update the list of allowed cyphers.
#!                         Default: TLS_DHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
#!                         TLS_DHE_RSA_WITH_AES_256_CBC_SHA256,TLS_DHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,
#!                         TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
#!                         TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_256_CBC_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA256
#!
#! @output error_message: The API call error or the retrieved entity error as JSON.
#! @output return_result: The entire HTTP result as JSON.
#! @output status_code: '0' if success, '-1' otherwise.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.issues
flow:
  name: get_issue
  inputs:
    - url
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - issue_id_or_key
    - fields:
        default: '*all'
        required: false
    - fields_by_keys:
        default: 'false'
        required: false
    - expand:
        required: false
    - properties:
        required: false
    - update_history:
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
    - allowed_cyphers
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${url + '/rest/api/3/issue/' + issue_id_or_key}"
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
            - query_params: "${'fields=' +  fields + '&' + 'fieldsByKeys=' + fields_by_keys + '&' +'updateHistory=' + update_history  + (\"\" if bool(expand) == False else '&expand=' + expand) + (\"\" if bool(properties) == False else '&properties=' + properties)}"
            - content_type: application/json
        publish:
          - error_message
          - return_result
          - status_code: '${status_code}'
          - response_headers: '${response_headers}'
          - return_result_1: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - error_message: '${error_message}'
    - return_result: '${return_result}'
    - status_code: '${status_code}'
    - response_headers: '${response_headers}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_get:
        x: 480
        'y': 160
        navigate:
          bec4ed71-1157-e49f-61ce-451deb912d54:
            targetId: 38c5fa27-1519-6cef-b53e-2bd67c8bf05d
            port: SUCCESS
    results:
      SUCCESS:
        38c5fa27-1519-6cef-b53e-2bd67c8bf05d:
          x: 640
          'y': 160
