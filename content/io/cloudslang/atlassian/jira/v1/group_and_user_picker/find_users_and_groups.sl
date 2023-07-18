#   Copyright 2023 Open Text
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
#! @description: Returns a list of users and groups matching a string.
#!
#! @input url: URL to which the call is made.
#! @input username: Username used for URL authentication; for NTLM authentication.Format: 'domain\user'
#! @input password: Password used for URL authentication.
#! @input query: The search string.
#! @input max_results: The maximum number of items to return in each list.
#!                      
#!                     Default: 50, Format: int32
#! @input show_avatar: Whether the user avatar should be returned. If an invalid value is provided, the default value is used.
#!                      
#!                     Default: false
#! @input field_id: The custom field ID of the field this request is for.
#! @input project_id: The ID of a project that returned users and groups must have permission to view. To include multiple projects, provide an ampersand-separated list. For example, projectId=10000&projectId=10001. This parameter is only used when fieldId is present.
#! @input issue_type_id: The ID of an issue type that returned users and groups must have permission to view. To include multiple issue types, provide an ampersand-separated list. For example, issueTypeId=10000&issueTypeId=10001. Special values, such as -1 (all standard issue types) and -2 (all subtask issue types), are supported. This parameter is only used when fieldId is present.
#! @input avatar_size: The size of the avatar to return. If an invalid value is provided, the default value is used. Default: xsmall. Valid values: xsmall, xsmall@2x, xsmall@3x, small, small@2x, small@3x, medium, medium@2x, medium@3x, large, large@2x, large@3x, xlarge, xlarge@2x, xlarge@3x, xxlarge, xxlarge@2x, xxlarge@3x, xxxlarge, xxxlarge@2x, xxxlarge@3x
#! @input case_insensitive: Whether the search for groups should be case insensitive.
#!                           
#!                          Default: false
#! @input exclude_connect_addons: Whether Connect app users and groups should be excluded from the search results. If an invalid value is provided, the default value is used.
#!                                 
#!                                Default: false
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
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output account_ids: A list of account Ids matching the string separated by comma.
#! @output group_names: A list of group names matching the string separated by comma.
#! @output return_result: The response of the operation in case of success or the error message otherwise.
#! @output error_message: Return_result if status_code different than '200'.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: Status code of the HTTP call.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#!
#! @result SUCCESS: Users and groups found.
#! @result FAILURE: Failed to find users and groups.
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.group_and_user_picker
flow:
  name: find_users_and_groups
  inputs:
    - url
    - username:
        required: true
    - password:
        required: true
        sensitive: true
    - query:
        required: false
    - max_results:
        default: '50'
        required: false
    - show_avatar:
        default: 'false'
        required: false
    - field_id:
        required: false
    - project_id:
        required: false
    - issue_type_id:
        required: false
    - avatar_size:
        default: xsmall
        required: false
    - case_insensitive:
        default: 'false'
        required: false
    - exclude_connect_addons:
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
    - worker_group:
        required: false
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: '${url+"/rest/api/3/groupuserpicker?query="+("" if bool(query)==False else query)+"&maxResults="+max_results+"&showAvatar="+show_avatar+"&fieldId="+("" if bool(field_id)==False else field_id)+"&projectId="+("" if bool(project_id)==False else field_id)+"&issueTypeId="+("" if bool(issue_type_id)==False else isue_type_id)+"&avatarSize="+avatar_size+"&caseInsensitive="+case_insensitive+"&excludeConnectAddons="+exclude_connect_addons}'
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
            - keystore: '${trust_password}'
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
          - SUCCESS: find_users_and_groups_account_ids_group_names
          - FAILURE: test_for_http_error
    - find_users_and_groups_account_ids_group_names:
        do:
          io.cloudslang.atlassian.jira.v1.utils.find_users_and_groups_account_ids_group_names:
            - return_result: '${return_result}'
        publish:
          - group_names
          - account_ids
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
    - account_ids: '${account_ids}'
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
      find_users_and_groups_account_ids_group_names:
        x: 400
        'y': 125
        navigate:
          46018ad6-ebcf-11f7-f96b-7b6d1236ced0:
            targetId: 26fbb017-f510-22d9-ba27-5690aa6c0f84
            port: SUCCESS
      test_for_http_error:
        x: 400
        'y': 375
        navigate:
          dc1eeb83-e7e9-0787-6f9b-8e18f179ef4f:
            targetId: d0b0ae74-35df-a442-fa5d-dae8a9f22321
            port: FAILURE
    results:
      SUCCESS:
        26fbb017-f510-22d9-ba27-5690aa6c0f84:
          x: 700
          'y': 125
      FAILURE:
        d0b0ae74-35df-a442-fa5d-dae8a9f22321:
          x: 700
          'y': 375
