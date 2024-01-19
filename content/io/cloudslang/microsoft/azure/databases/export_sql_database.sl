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
#! @description: This operation can be used to export an sql database
#!
#! @input subscription_id: The ID of the Azure Subscription on which the VM should be created.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to create the VM.
#! @input auth_token: Azure authorization Bearer token
#! @input api_version: The API version used to create calls to Azure
#!                     Default: '2014-04-01-preview'
#! @input location: Specifies the supported Azure location where the database should be exported.
#!                  This can be different from the location of the resource group.
#! @input database_name: Azure database name to be exported
#! @input sql_server_name: Sql Database server name
#! @input storage_key_type: Specifies the type of access key for the storage account. The acceptable value are:
#!                          - StorageAccessKey (using storage account key)
#!                          - SharedAccessKey (using SAS key)
#! @input storage_key: Specifies the access key for the storage account.
#! @input uri_of_the_bacpac_file: pecifies the blob URI of the .bacpac file.
#! @input sql_admin_name: Specifies the name of the SQL administrator.
#! @input sql_admin_password: Specifies the password of the SQL administrator.
#! @input sql_auth_type: Optional - (This parameter is only available on SQL Database V12 servers).
#!                      Specifies the type of authentication used to access the server. Defaults to SQL if no
#!                      authenticationType is set. Acceptable values are:
#!                      SQL (SQL authentication) - set the 'administratorLogin' and 'administratorLoginPassword'
#!                                               to the SQL admin username and password.
#!                      ADPassword (Azure Active Directory authentication) – set the 'administratorLogin' and
#!                      'administratorLoginPassword' to the Azure AD admin username and password.
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - Username used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input x_509_hostname_verifier: Optional - specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#!                                 Default: 'strict'
#! @input trust_keystore: Optional - the pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - the password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!
#! @output output: response with information about the exported sql database
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output error_message: If a database is not found the error message will be populated with a response,
#!                        empty otherwise
#!
#! @result SUCCESS: Database exported successfully.
#! @result FAILURE: There was an error while trying to export the database.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.databases

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: export_sql_database

  inputs:
    - subscription_id
    - resource_group_name
    - auth_token
    - api_version:
        required: false
        default: '2014-04-01-preview'
    - location
    - database_name
    - sql_server_name
    - storage_key_type
    - storage_key
    - uri_of_the_bacpac_file
    - sql_admin_name
    - sql_admin_password
    - sql_auth_type:
        required: false
        default: 'SQL'
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - proxy_port:
        default: "8080"
        required: false
    - proxy_host:
        required: false
    - trust_all_roots:
        default: "false"
        required: false
    - x_509_hostname_verifier:
        default: "strict"
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        default: ''
        required: false
        sensitive: true

  workflow:
    - export_sql_database:
        do:
          http.http_client_post:
            - url: >
                ${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' +
                resource_group_name + '/providers/Microsoft.Sql/servers/' + sql_server_name + '/databases/' +
                database_name + '/export?api-version=' + api_version}
            - body: >
                ${'{"storageKeyType":"' + storage_key_type + '","storageKey":"' + storage_key + '","storageUri":"' +
                uri_of_the_bacpac_file + '","administratorLogin":"' sql_admin_name + '","administratorLoginPassword":"' +
                sql_admin_password + '","authenticationType":"' + sql_auth_type + '"}'}
            - headers: "${'Authorization: ' + auth_token}"
            - auth_type
            - preemptive_auth
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - use_cookies
            - keep_alive
            - connections_max_per_route
            - connections_max_total
            - content_type
            - request_character_set
            - response_character_set
            - multipart_bodies_content_type
            - chunked_request_entity
        publish:
          - output: ${return_result}
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: retrieve_error

    - retrieve_error:
        do:
          json.get_value:
            - json_input: ${output}
            - json_path: 'error,message'
        publish:
          - error_message: ${return_result}
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: FAILURE

  outputs:
    - output
    - status_code
    - error_message

  results:
    - SUCCESS
    - FAILURE

