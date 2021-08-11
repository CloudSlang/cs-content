########################################################################################################################
#!!
#! @description: Edits an issue. A transition may be applied and issue properties updated as part of the edit. The edits to the issue's fields are defined using update and fields.
#!
#! @input url: URL to which the call is made.
#! @input username: Username used for URL authentication; for NTLM authentication.Format: 'domain\user'
#! @input password: Password used for URL authentication.
#! @input issue_id_or_key: The ID or key of the issue.
#! @input notify_users: Whether a notification email about the issue update is sent to all watchers. To disable the notification, administer Jira or administer project permissions are required. If the user doesn't have the necessary permission the request is ignored.
#!                       
#!                      Default: true
#! @input override_screen_security: Whether screen security should be overridden to enable hidden fields to be edited. Available to Connect app users with admin permissions.
#!                                   
#!                                  Default: false
#! @input override_editable_flag: Whether screen security should be overridden to enable uneditable fields to be edited. Available to Connect app users with admin permissions.
#!                                 
#!                                Default: false
#! @input body: String to include in body for HTTP PUT operation. This input should contain the JSON body as accepted by Jira.
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
#! @output return_result: The response of the operation in case of success or the error message otherwise.
#! @output error_message: Return_result if status_code different than '204'.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: Status code of the HTTP call.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.issues
flow:
  name: edit_issue
  inputs:
    - url
    - username:
        required: true
    - password:
        required: true
        sensitive: true
    - issue_id_or_key:
        sensitive: false
    - notify_users:
        default: 'true'
        required: false
    - override_screen_security:
        default: 'false'
        required: false
    - override_editable_flag:
        default: 'false'
        required: false
    - body:
        default: '{"fields":{}}'
        required: true
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
    - http_client_put:
        do:
          io.cloudslang.base.http.http_client_put:
            - url: '${url+"/rest/api/3/issue/"+issue_id_or_key+"?notifyUsers="+notify_users+"&overrideScreenSecurity="+override_screen_security+"&overrideEditableFlag="+override_editable_flag}'
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
            - body: '${body}'
            - content_type: application/json
            - worker_group: '${worker_group}'
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
          - response_headers
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
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
      http_client_put:
        x: 100
        'y': 250
        navigate:
          12d05da7-0736-8a06-dff9-2e299ea6dcac:
            targetId: 68273c40-2eec-b45b-a3cf-3ad23fa32a42
            port: SUCCESS
          506a555a-5962-7ae7-6396-334c991d68a4:
            targetId: c7ccbc74-c26f-82ce-0c28-49ba78e8cb8a
            port: FAILURE
    results:
      FAILURE:
        c7ccbc74-c26f-82ce-0c28-49ba78e8cb8a:
          x: 400
          'y': 375
      SUCCESS:
        68273c40-2eec-b45b-a3cf-3ad23fa32a42:
          x: 400
          'y': 125
