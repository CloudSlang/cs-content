#   Copyright 2024 Open Text
#   This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: Creates a project based on a project type template.
#!
#! @input url: URL to which the call is made.
#! @input username: Username used for URL authentication; for NTLM authentication.Format: 'domain\user'
#! @input password: Password used for URL authentication.
#! @input key: Project keys must be unique and start with an uppercase letter followed by one or more uppercase alphanumeric characters. The maximum length is 10 characters.
#! @input name: The name of the project.
#! @input description: A brief description of the project.
#! @input lead_account_id: The account ID of the project lead. Either lead or leadAccountId must be set when creating a project. Cannot be provided with lead.
#!                          
#!                         Max length: 128
#! @input link: A link to information about this project, such as project documentation
#! @input assignee_type: The default assignee when creating issues for this project.Valid values: PROJECT_LEAD, UNASSIGNED. Default: UNASSIGNED
#! @input avatar_id: An integer value for the project's avatar.
#!                    
#!                   Format: int64
#! @input issue_security_scheme: The ID of the issue security scheme for the project, which enables you to control who can and cannot view issues. Use the Get issue security schemes resource to get all issue security scheme IDs.
#!                                
#!                               Format: int64
#! @input permission_scheme: The ID of the permission scheme for the project. Use the Get all permission schemes resource to see a list of all permission scheme IDs.
#!                            
#!                           Format: int64
#! @input notification_scheme: The ID of the notification scheme for the project. Use the Get notification schemes resource to get a list of notification scheme IDs.
#!                              
#!                             Format: int64
#! @input category_id: The ID of the project's category. A complete list of category IDs is found using the Get all project categories operation. Format: int64
#! @input project_template_key: A predefined configuration for a project. The type of the projectTemplateKey must match with the type of the projectTypeKey.
#!                               
#!                              Valid values: com.pyxis.greenhopper.jira:gh-simplified-agility-kanban, com.pyxis.greenhopper.jira:gh-simplified-agility-scrum, com.pyxis.greenhopper.jira:gh-simplified-basic, com.pyxis.greenhopper.jira:gh-simplified-kanban-classic, com.pyxis.greenhopper.jira:gh-simplified-scrum-classic, com.atlassian.servicedesk:simplified-it-service-desk, com.atlassian.servicedesk:simplified-internal-service-desk, com.atlassian.servicedesk:simplified-external-service-desk, com.atlassian.servicedesk:simplified-hr-service-desk, com.atlassian.servicedesk:simplified-facilities-service-desk, com.atlassian.jira-core-project-templates:jira-core-simplified-content-management, com.atlassian.jira-core-project-templates:jira-core-simplified-document-approval, com.atlassian.jira-core-project-templates:jira-core-simplified-lead-tracking, com.atlassian.jira-core-project-templates:jira-core-simplified-process-control, com.atlassian.jira-core-project-templates:jira-core-simplified-procurement, com.atlassian.jira-core-project-templates:jira-core-simplified-project-management, com.atlassian.jira-core-project-templates:jira-core-simplified-recruitment, com.atlassian.jira-core-project-templates:jira-core-simplified-task-
#! @input project_type_key: The project type, which defines the application-specific feature set. If you don't specify the project template you have to specify the project type.
#!                           
#!                          Valid values: software, service_desk, business
#! @input workflow_scheme: The ID of the workflow scheme for the project. Use the Get all workflow schemes operation to get a list of workflow scheme IDs. If you specify the workflow scheme you cannot specify the project template key.
#!                          
#!                         Format: int64
#! @input issue_type_screen_scheme: The ID of the issue type screen scheme for the project. Use the Get all issue type screen schemes operation to get a list of issue type screen scheme IDs. If you specify the issue type screen scheme you cannot specify the project template key.
#!                                   
#!                                  Format: int64
#! @input issue_type_scheme: The ID of the issue type scheme for the project. Use the Get all issue type schemes operation to get a list of issue type scheme IDs. If you specify the issue type scheme you cannot specify the project template key.
#!                            
#!                           Format: int64
#! @input field_configuration_scheme: The ID of the field configuration scheme for the project. Use the Get all field configuration schemes operation to get a list of field configuration scheme IDs. If you specify the field configuration scheme you cannot specify the project template key.
#!                                     
#!                                    Format: int64
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
#! @output id: The id of the created project.
#! @output return_result: The response of the operation in case of success or the error message otherwise.
#! @output error_message: Return_result if status_code different than '201'.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: Status code of the HTTP call.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#!
#! @result SUCCESS: Project created with success.
#! @result FAILURE: Failed to create project.
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.projects
flow:
  name: create_project
  inputs:
    - url
    - username:
        required: true
    - password:
        required: true
        sensitive: true
    - key
    - name
    - description:
        required: false
    - lead_account_id:
        required: true
    - link:
        required: false
    - assignee_type:
        default: UNASSIGNED
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
    - project_template_key:
        required: true
    - project_type_key:
        required: true
    - workflow_scheme:
        required: false
    - issue_type_screen_scheme:
        required: false
    - issue_type_scheme:
        required: false
    - field_configuration_scheme:
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
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: '${url+"/rest/api/3/project"}'
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
            - body: "${'{\"leadAccountId\":\"'+lead_account_id+'\",\"projectTemplateKey\":\"'+project_template_key+'\",\"name\":\"'+name+'\",\"key\":\"'+key+'\",\"description\":\"'+str(description or \"\")+'\",\"url\":\"'+str(link or \"\")+'\",\"assigneeType\":\"'+assignee_type+'\",\"avatarId\":'+('\"\"' if bool(avatar_id)==False else str(avatar_id))+',\"issueSecurityScheme\":'+('\"\"' if bool(issue_security_scheme)==False else str(issue_security_scheme))+',\"permissionScheme\":'+('\"\"' if bool(permission_scheme)==False else str(permission_scheme))+',\"notificationScheme\":'+('\"\"' if bool(notification_scheme)==False else str(notification_scheme))+',\"categoryId\":'+('\"\"' if bool(category_id)==False else str(category_id))+',\"projectTypeKey\":\"'+project_type_key+'\",\"workflowScheme\":'+('\"\"' if bool(workflow_scheme)==False else str(workflow_scheme))+',\"issueTypeScreenScheme\":'+('\"\"' if bool(issue_type_screen_scheme)==False else str(issue_type_screen_scheme))+',\"issueTypeScheme\":'+('\"\"' if bool(issue_type_scheme)==False else str(issue_type_scheme))+',\"fieldConfigurationScheme\":'+('\"\"' if bool(field_configuration_scheme)==False else str(field_configuration_scheme))+'}'}"
            - content_type: application/json
            - worker_group: '${worker_group}'
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
          - response_headers
        navigate:
          - SUCCESS: create_project_id
          - FAILURE: test_for_http_error
    - test_for_http_error:
        do:
          io.cloudslang.atlassian.jira.v1.utils.test_for_http_error:
            - return_result: '${return_result}'
        publish:
          - error_message
        navigate:
          - FAILURE: FAILURE
    - create_project_id:
        do:
          io.cloudslang.atlassian.jira.v1.utils.create_project_id:
            - return_result: '${return_result}'
        publish:
          - id
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - id: '${id}'
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
      http_client_post:
        x: 100
        'y': 250
      create_project_id:
        x: 400
        'y': 125
        navigate:
          f9b310be-6549-81c7-02c2-c2947b778afc:
            targetId: ba182fe6-19b1-ce73-203e-c92b8352d63f
            port: SUCCESS
      test_for_http_error:
        x: 400
        'y': 375
        navigate:
          2d57c3bf-4c5d-dc11-41ee-22c66d003eb3:
            targetId: 81721940-6a2c-7223-914a-918fafd91f99
            port: FAILURE
    results:
      SUCCESS:
        ba182fe6-19b1-ce73-203e-c92b8352d63f:
          x: 700
          'y': 125
      FAILURE:
        81721940-6a2c-7223-914a-918fafd91f99:
          x: 700
          'y': 375
