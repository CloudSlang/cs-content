########################################################################################################################
#!!
#! @description: Returns:
#!                
#!               for a list of global permissions, the global permissions granted to a user.
#!               for a list of project permissions and lists of projects and issues, for each project permission a list of the projects and issues a user can access or manipulate.
#!               If no account ID is provided, the operation returns details for the logged in user.
#!                
#!               Note that:
#!                
#!               Invalid project and issue IDs are ignored.
#!               A maximum of 1000 projects and 1000 issues can be checked.
#!               Null values in globalPermissions, projectPermissions, projectPermissions.projects, and projectPermissions.issues are ignored.
#!               Empty strings in projectPermissions.permissions are ignored.
#!
#! @input url: URL to which the call is made.
#! @input username: Username used for URL authentication
#! @input password: Password used for URL authentication
#! @input project_permissions: Project permissions with associated projects and issues to look up.
#!                             Json array with a "," delimiter.
#!                             ex:
#!                             {
#!                             "projects": [
#!                             	10000
#!                             ],
#!                             "permissions": [
#!                             	"ADMINISTER"
#!                             ],
#!                             "issues": [
#!                             	10010,
#!                             	10016
#!                             ]
#!                             },
#!                             {
#!                             "projects": [
#!                             	10001
#!                             ],
#!                             "permissions": [
#!                             	"EDIT_ISSUES"
#!                             ],
#!                             "issues": [
#!                             	10010,
#!                             	10011,
#!                             	10012,
#!                             	10013,
#!                             	10014
#!                             ]
#!                             }
#! @input global_permissions: Global permissions to look up.
#!                            List of permissions with a "," delimiter.
#!                            ex: ADMINISTER,EDIT_ISSUES
#! @input account_id: The account ID of a user.
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy port used to access the web site.
#! @input proxy_username: Optional - Proxy usernameused to access the web site.
#! @input proxy_password: Optional - Proxy password used to access the web site.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#! @input connect_timeout: Optional - Time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#! @input socket_timeout: Optional - Time in seconds to wait for data to be retrieved
#!                        Default: '0' (infinite)
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
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
#! @input trust_keystore: Optional - The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ''
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!
#! @output response_headers: Jira get bulk permissions response headers
#! @output status_code: 200 - Returned if the request is successful.
#!                      400 - Returned if:
#!                      	projectPermissions is provided without at least one project permission being provided.
#!                      	an invalid global permission is provided in the global permissions list.
#!                      	an invalid project permission is provided in the project permissions list.
#!                      	more than 1000 valid project IDs or more than 1000 valid issue IDs are provided.
#!                      	an invalid account ID is provided.
#!                      403 - Returned if the user does not have the necessary permission.
#! @output error_message: Error message
#! @output return_result: Json containing data regarding the permissions
#! @output return_code: 0 - success, -1 - failure
#!
#! @result FAILURE: Execution failed
#! @result SUCCESS: status_code == 200
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.permissions
flow:
  name: get_bulk_permissions
  inputs:
    - url
    - username:
        required: true
    - password:
        required: true
        sensitive: true
    - project_permissions:
        required: false
    - global_permissions:
        required: false
    - account_id:
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
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
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
    - tls_version:
        required: false
    - allowed_cyphers:
        required: false
    - trust_keystore:
        default: "${get_sp('io.cloudslang.base.http.trust_keystore')}"
        required: false
    - trust_password:
        default: "${get_sp('io.cloudslang.base.http.trust_password')}"
        required: false
        sensitive: true
  workflow:
    - get_bulk_permissions_body:
        do:
          io.cloudslang.atlassian.jira.v1.utils.get_bulk_permissions_body:
            - project_permissions: '${project_permissions}'
            - global_permissions: '${global_permissions}'
            - account_id: '${account_id}'
        publish:
          - body: '${return_result}'
        navigate:
          - SUCCESS: http_client_post
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${url + '/rest/api/3/permissions/check'}"
            - auth_type: basic
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
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
            - request_character_set: utf-8
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - headers: 'Accept: application/json'
            - body: '${body}'
            - content_type: application/json
            - worker_group: '${worker_group}'
        publish:
          - return_result: '${return_result}'
          - return_code: '${return_code}'
          - status_code: '${status_code}'
          - response_headers: '${response_headers}'
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: test_for_http_error
    - test_for_http_error:
        do:
          io.cloudslang.atlassian.jira.v1.utils.test_for_http_error:
            - return_result: '${return_result}'
        publish:
          - error_message
        navigate:
          - FAILURE: on_failure
  outputs:
    - response_headers: '${response_headers}'
    - status_code: '${status_code}'
    - error_message: "${error_message if error_message != '' else (return_result if status_code != '200' else '')}"
    - return_result: "${return_result if status_code == '200' else ''}"
    - return_code: '${return_code}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_bulk_permissions_body:
        x: 80
        'y': 200
      http_client_post:
        x: 200
        'y': 200
        navigate:
          8a8e90da-6ad5-f468-0fd5-59b00970ddff:
            targetId: 70f668aa-93d0-2a16-254a-384531eef6e7
            port: SUCCESS
      test_for_http_error:
        x: 200
        'y': 360
    results:
      SUCCESS:
        70f668aa-93d0-2a16-254a-384531eef6e7:
          x: 360
          'y': 200