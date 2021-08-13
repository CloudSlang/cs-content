########################################################################################################################
#!!
#! @description: Returns a paginated list of projects visible to the user.
#!
#! @input url: Jira url
#! @input auth_username: Username for the API authenticator
#! @input auth_password: Password for the API authenticator
#! @input start_at: The index of the first item to return in a page of results (page offset).
#! @input max_results: The maximum number of items to return per page.
#! @input order_by: Order the results by a field.category Sorts by project category. A complete list of category IDs is found using Get all project categories.issueCount Sorts by the total number of issues in each project.key Sorts by project key.lastIssueUpdatedTime Sorts by the last issue update time.name Sorts by project name.owner Sorts by project lead.archivedDate EXPERIMENTAL. Sorts by project archived date.deletedDate EXPERIMENTAL. Sorts by project deleted date. For more valid values visit https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-projects/#api-rest-api-3-project-search-get
#! @input id: The project IDs to filter the results by. To include multiple IDs, provide an comma-separated list. For example, 10000,10001. Up to 50 project IDs can be provided.
#! @input query: Filter the results using a literal string. Projects with a matching key or name are returned (case insensitive).
#! @input type_key: Orders results by the project type. This parameter accepts a comma-separated list. Valid values are business, service_desk, and software
#! @input category_id: The ID of the project's category. A complete list of category IDs is found using the Get all project categories operation.  https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-project-categories/#api-rest-api-3-projectcategory-get
#! @input action: Filter results by projects for which the user can:
#!                 
#!                view the project, meaning that they have one of the following permissions:
#!                 
#!                Browse projects project permission for the project.
#!                Administer projects project permission for the project.
#!                Administer Jira global permission.
#!                browse the project, meaning that they have the Browse projects project permission for the project.
#!                 
#!                edit the project, meaning that they have one of the following permissions:
#!                 
#!                Administer projects project permission for the project.
#!                Administer Jira global permission.
#! @input expand: Use expand to include additional information in the response. This parameter accepts a comma-separated list. Expanded options include:
#!                 
#!                description Returns the project description.
#!                projectKeys Returns all project keys associated with a project.
#!                lead Returns information about the project lead.
#!                issueTypes Returns all issue types associated with the project.
#!                url Returns the URL associated with the project.
#!                insight EXPERIMENTAL. Returns the insight details of total issue count and last issue update time for the project.
#! @input status: EXPERIMENTAL. Filter results by project status:
#!                 
#!                live Search live projects.
#!                archived Search archived projects.
#!                deleted Search deleted projects, those in the recycle bin.
#!                Valid values: live, archived, deleted
#! @input properties: EXPERIMENTAL. A list of project properties to return for the project. This parameter accepts a comma-separated list.
#! @input property_query: EXPERIMENTAL. A query string used to search properties. The query string cannot be specified using a JSON object. For example, to search for the value of nested from {"something":{"nested":1,"other":2}} use [thepropertykey].something.nested=1. Note that the propertyQuery key is enclosed in square brackets to enable searching where the propertyQuery key includes dot (.) or equals (=) characters
#! @input proxy_host: The proxy server used to access the web site.
#! @input proxy_port: The proxy server port. Default value: 8080. Valid values: -1, and positive integer values. When the value is '-1' the default port of the scheme, specified in the 'proxy_host', will be used.
#! @input update_history: Whether the project in which the issue is created is added to the user's Recently viewed project list, as shown under Projects in Jira. This also populates the JQL issues search lastViewed field.
#! @input proxy_username: The user name used when connecting to the proxy. The 'auth_type' input will be used to choose authentication type. The 'Basic' and 'Digest' proxy authentication type are supported.
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
#! @input allowed_cyphers: Optional - A comma delimited list of cyphers to use. The value of this input will be ignored
#!                         if 'tlsVersion' does not contain 'TLSv1.2'.This capability is provided “as is”, please see product
#!                         documentation for further security considerations. In order to connect successfully to the target
#!                         host, it should accept at least one of the following cyphers. If this is not the case, it is the
#!                         user's responsibility to configure the host accordingly or to update the list of allowed cyphers.
#!                         Default: TLS_DHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
#!                         TLS_DHE_RSA_WITH_AES_256_CBC_SHA256,TLS_DHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,
#!                         TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
#!                         TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_256_CBC_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA256
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
#!
#! @output return_result: The entire HTTP result as JSON.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: Status code of the HTTP call. 200 - Returned if the request is successful.
#!                      400 - Returned if the request is not valid.
#!                      401 - Returned if the authentication credentials are incorrect or missing.
#!                      404 - Returned if no projects matching the search criteria are found.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#! @output error_message: The API call error or the retrieved entity error as JSON.
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.project
flow:
  name: get_projects_paginated
  inputs:
    - url
    - auth_username:
        required: false
    - auth_password:
        required: false
        sensitive: true
    - start_at:
        default: '0'
        required: false
    - max_results:
        default: '50'
        required: false
    - order_by:
        default: key
        required: false
    - id:
        required: false
    - query:
        required: false
    - type_key:
        required: false
    - category_id:
        required: false
    - action:
        default: view
        required: false
    - expand:
        required: false
    - status:
        required: false
    - properties:
        required: false
    - property_query:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - update_history:
        default: 'false'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - allowed_cyphers:
        required: false
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
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${url + '/rest/api/3/project/search'}"
            - auth_type: null
            - username: '${auth_username}'
            - password:
                value: '${auth_password}'
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
            - query_params: |-
                ${("startAt=" + start_at + "&" +
                "maxResults=" + max_results +
                ("" if bool(order_by) == False else "&orderBy=" + order_by) +
                ("" if bool(id) == False else "&id=" + id.replace(",",'&id=') ) +
                ("" if bool(query) == False else "&query=" + query ) +
                ("" if bool(type_key) == False else "&typeKey=" + type_key) +
                ("" if bool(category_id) == False else "&categoryId=" + category_id) +
                ("" if bool(action) == False else "&action=" + action) +
                ("" if bool(expand) == False else "&expand=" + expand) +
                ("" if bool(status) == False else "&status=" + status) +
                ("" if bool(properties) == False else "&properties=" + properties) +
                ("" if bool(property_query) == False else "&propertyQuery=" + property_query) )}
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
    - return_result: '${return_result}'
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
        x: 480
        'y': 160
        navigate:
          bec4ed71-1157-e49f-61ce-451deb912d54:
            targetId: 38c5fa27-1519-6cef-b53e-2bd67c8bf05d
            port: SUCCESS
      test_for_http_error:
        x: 480
        'y': 320
    results:
      SUCCESS:
        38c5fa27-1519-6cef-b53e-2bd67c8bf05d:
          x: 640
          'y': 160
