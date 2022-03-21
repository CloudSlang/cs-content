#   (c) Copyright 2022 Micro Focus, L.P.
#   All rights reserved. This program and the accompanying materials
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
#! @description: This workflow can be used to deletes an sql database.
#!
#! @input provider_sap: The providerSAP(Service Access Point) to which requests will be sent.
#!                      Default: 'https://management.azure.com'
#! @input subscription_id: The subscription ID that identifies an Azure subscription.
#! @input tenant_id: The tenantId value used to control who can sign into the application.
#! @input client_secret: The application secret that you created in the app registration portal for your app. It cannot
#!                       be used in a native app (public client), because client_secrets cannot be reliably stored on
#!                       devices. It is required for web apps and web APIs (all confidential clients),
#!                       which have the ability to store the client_secret securely on the server side.
#! @input client_id: The Application ID assigned to your app when you registered it with Azure AD.
#! @input database_name: Azure database name to be created.
#! @input db_server_name: Name of the SQL Server.
#! @input resource_group_name: The name of the Azure Resource Group that contains the resource.
#! @input location: Resource location.
#!                  Example: eastasia, westus, westeurope, japanwest.
#! @input db_server_password: Optional - Password value for the DB Server username.
#! @input db_server_username: Optional - Username for the newly created SQL DB Server.
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'.
#! @input proxy_username: Optional - Username used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'.
#! @input x_509_hostname_verifier: Optional - specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#!                                 Default: 'strict'
#! @input trust_keystore: Optional - the pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - the password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input connect_timeout: Optional - time in seconds to wait for a connection to be established
#!                         Default: '100' (infinite)
#! @input socket_timeout: Optional - time in seconds to wait for data to be retrieved.
#!                        Default: '0' (infinite)
#! @input worker_group: Optional - A worker group is a logical collection of workers. A worker may belong to more one group simultaneously.
#!                      Default: 'RAS_Operator_Path'.
#!
#! @output output: response with information about the created sql database.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output error_message: If a database is not found the error message will be populated with a response,
#!                        empty otherwise.
#!
#! @result FAILURE: There was an error while trying to create the database.
#! @result SUCCESS: Database created successfully.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure

flow:
  name: azure_delete_database
  inputs:
    - provider_sap: 'https://management.azure.com'
    - subscription_id
    - tenant_id
    - client_secret:
        sensitive: true
    - client_id
    - database_name
    - db_server_name
    - resource_group_name
    - location
    - db_server_password:
        required: false
        sensitive: true
    - db_server_username:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
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
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - connect_timeout:
        default: '100'
        required: false
    - socket_timeout:
        default: '0'
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - get_auth_token_using_web_api:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.microsoft.azure.authorization.get_auth_token_using_web_api:
            - tenant_id: '${tenant_id}'
            - client_id: '${client_id}'
            - client_secret:
                value: '${client_secret}'
                sensitive: true
            - resource: 'https://management.azure.com'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - auth_token:
              value: '${auth_token}'
              sensitive: true
        navigate:
          - SUCCESS: delete_sql_database
          - FAILURE: on_failure
    - delete_sql_database:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.databases.delete_sql_database:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - auth_token: '${auth_token}'
            - db_server_name: '${db_server_name}'
            - database_name: '${database_name}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - worker_group: '${worker_group}'
        publish:
          - status_code
          - output: "${'database ' + database_name + ' is deleted successfully'}"
          - error_message
        navigate:
          - SUCCESS: get_sql_database_info
          - FAILURE: on_failure
    - get_sql_database_info:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.databases.get_sql_database_info:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - auth_token: '${auth_token}'
            - db_server_name: '${db_server_name}'
            - database_name: '${database_name}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - proxy_port: '${proxy_port}'
            - proxy_host: '${proxy_host}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - worker_group: '${worker_group}'
        publish: []
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: delete_sql_database_server
    - delete_sql_database_server:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.databases.delete_sql_database_server:
            - subscription_id: '${subscription_id}'
            - auth_token: '${auth_token}'
            - location: '${location}'
            - db_server_name: '${db_server_name}'
            - resource_group_name: '${resource_group_name}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - worker_group: '${worker_group}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - output
    - status_code
    - error_message
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_auth_token_using_web_api:
        x: 120
        'y': 120
      delete_sql_database:
        x: 320
        'y': 120
      get_sql_database_info:
        x: 520
        'y': 120
        navigate:
          e5fab2e5-22fd-8e64-cc1b-c9d82115cdd1:
            targetId: 9c2c3761-ccb0-0d73-e160-0cabb347d0d1
            port: SUCCESS
      delete_sql_database_server:
        x: 680
        'y': 120
        navigate:
          bed7a08e-e768-a131-59b5-96d7bceb4274:
            targetId: 6141cc22-04a3-73e5-c9f4-f61071b4b8ea
            port: SUCCESS
    results:
      FAILURE:
        9c2c3761-ccb0-0d73-e160-0cabb347d0d1:
          x: 520
          'y': 360
      SUCCESS:
        6141cc22-04a3-73e5-c9f4-f61071b4b8ea:
          x: 880
          'y': 120

