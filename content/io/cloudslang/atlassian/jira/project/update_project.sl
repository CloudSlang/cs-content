########################################################################################################################
#!!
#! @description: Updates the project details of a project.
#!
#! @input url: URL to which the call is made.
#! @input project_id_or_key: The project ID or project key (case sensitive).
#! @input expand: Use expand to include additional information in the response. This parameter accepts a comma-separated list. Note that the project description, issue types, and project lead are included in all responses by default. Expand options include:
#!                 
#!                description The project description.
#!                issueTypes The issue types associated with the project.
#!                lead The project lead.
#!                projectKeys All project keys associated with the project.
#! @input key: Project keys must be unique and start with an uppercase letter followed by one or more uppercase alphanumeric characters. The maximum length is 10 characters.
#! @input name: The name of the project.
#! @input description: A brief description of the project.
#! @input lead_account_id: The account ID of the project lead. Cannot be provided with lead.
#! @input project_url: A link to information about this project, such as project documentation
#! @input assignee_type: The default assignee when creating issues for this project.
#! @input avatar_id: An integer value for the project's avatar.
#! @input issue_security_scheme: The ID of the issue security scheme for the project, which enables you to control who can and cannot view issues. Use the Get issue security schemes resource to get all issue security scheme IDs.
#! @input permission_scheme: The ID of the permission scheme for the project. Use the Get all permission schemes resource to see a list of all permission scheme IDs.
#! @input notification_scheme: The ID of the notification scheme for the project. Use the Get notification schemes resource to get a list of notification scheme IDs.
#! @input category_id: The ID of the project's category. A complete list of category IDs is found using the Get all project categories operation.
#! @input username: Username used for URL authentication
#! @input password: Password used for URL authentication
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
#! @output response_headers: Jira update project response headers
#! @output status_code: 200 - Returned if the project is updated.
#!                      400 - Returned if the request is not valid.
#!                      401 - Returned if the authentication credentials are incorrect or missing.
#!                      403 - Returned if:
#!                      	the user does not have the necessary permission to update project details.
#!                      	the permission scheme is being changed and the Jira instance is Jira Core Free or Jira Software Free. Permission schemes cannot be changed on free plans.
#!                      404 - Returned if the project is not found.found.
#! @output return_result: Return result
#! @output return_code: 0 - success, -1 - failure
#! @output error_message: Error message
#!
#! @result SUCCESS: status_code == 200
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.projects
flow:
  name: update_project
  inputs:
    - url
    - project_id_or_key
    - expand:
        required: false
    - key:
        required: false
    - name:
        required: false
    - description:
        required: false
    - lead_account_id:
        required: false
    - project_url:
        required: false
    - assignee_type:
        required: false
    - avatar_id:
        required: false
    - issue_security_scheme:
        required: false
    - permission_scheme:
        required: false
    - notification_scheme:
        required: false
    - category_id:
        required: false
    - username:
        required: true
    - password:
        required: true
        sensitive: true
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
    - http_client_put:
        do:
          io.cloudslang.base.http.http_client_put:
            - url: "${url + '/rest/api/3/project/' + project_id_or_key}"
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
            - headers: 'Accept: application/json'
            - query_params: "${'expand=' + expand if expand is not None else ''}"
            - body: |-
                ${('{' +
                    ((('"key": "' + key + '",' if key is not None else '') +
                    ('"name": "' + name + '",' if name is not None else '') +
                    ('"description": "' + description + '",' if description is not None else '') +
                    ('"leadAccountId": "' + lead_account_id + '",' if lead_account_id is not None else '') +
                    ('"url": "' + project_url + '",' if project_url is not None else '') +
                    ('"assigneeType": "' + assignee_type + '",' if assignee_type is not None else '') +
                    ('"avatarId": "' + avatar_id + '",' if avatar_id is not None else '') +
                    ('"issueSecurityScheme": "' + issue_security_scheme + '",' if issue_security_scheme is not None else '') +
                    ('"permissionScheme": "' + permission_scheme + '",' if permission_scheme is not None else '') +
                    ('"notificationScheme": "' + notification_scheme + '",' if notification_scheme is not None else '') +
                    ('"categoryId": "' + category_id + '",' if category_id is not None else ''))[:-1] if
                    (('"key": "' + key + '",' if key is not None else '') +
                    ('"name": "' + name + '",' if name is not None else '') +
                    ('"description": "' + description + '",' if description is not None else '') +
                    ('"leadAccountId": "' + lead_account_id + '",' if lead_account_id is not None else '') +
                    ('"url": "' + project_url + '",' if project_url is not None else '') +
                    ('"assigneeType": "' + assignee_type + '",' if assignee_type is not None else '') +
                    ('"avatarId": "' + avatar_id + '",' if avatar_id is not None else '') +
                    ('"issueSecurityScheme": "' + issue_security_scheme + '",' if issue_security_scheme is not None else '') +
                    ('"permissionScheme": "' + permission_scheme + '",' if permission_scheme is not None else '') +
                    ('"notificationScheme": "' + notification_scheme + '",' if notification_scheme is not None else '') +
                    ('"categoryId": "' + category_id + '",' if category_id is not None else '')) != "" else "") +
                '}')}
            - content_type: application/json
            - request_character_set: utf-8
            - worker_group: '${worker_group}'
        publish:
          - return_result: '${return_result}'
          - return_code: '${return_code}'
          - status_code: '${status_code}'
          - response_headers: '${response_headers}'
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - response_headers: '${response_headers}'
    - status_code: '${status_code}'
    - return_result: '${return_result}'
    - return_code: '${return_code}'
    - error_message: '${error_message}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      http_client_put:
        x: 240
        'y': 200
        navigate:
          b0dab7e5-4d48-a68c-e76e-eabba9af7125:
            targetId: 70f668aa-93d0-2a16-254a-384531eef6e7
            port: SUCCESS
    results:
      SUCCESS:
        70f668aa-93d0-2a16-254a-384531eef6e7:
          x: 400
          'y': 200
