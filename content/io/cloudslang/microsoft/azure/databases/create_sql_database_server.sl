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
#! @description: This operation can be used to create an sql database server.
#!
#! @input subscription_id: The subscription ID that identifies an Azure subscription.
#! @input auth_token: Azure authorization Bearer token.
#! @input location: Resource location.
#!                  Example: eastasia, westus, westeurope, japanwest.
#! @input db_server_name: Name of the SQL Server.
#! @input resource_group_name: The name of the Azure Resource Group that contains the resource.
#! @input db_server_password: Password value for the DB Server username.
#! @input db_server_username: Username for the newly created SQL DB Server.
#! @input api_version: The API version to use for the request.
#!                     Default: '2014-04-01'.
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
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - the password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input connect_timeout: Optional - time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
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
#! @result SUCCESS: Database created successfully.
#! @result FAILURE: There was an error while trying to create the database.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.databases

flow:
  name: create_sql_database_server
  inputs:
    - subscription_id
    - auth_token
    - location
    - db_server_name
    - resource_group_name
    - db_server_password:
        sensitive: true
    - db_server_username
    - api_version:
        default: '2014-04-01'
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
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - connect_timeout:
        default: '10'
        required: false
    - socket_timeout:
        default: '0'
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - create_sql_database_server:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_put:
            - url: "${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' + resource_group_name + '/providers/Microsoft.Sql/servers/' + db_server_name + '?api-version=' + api_version}"
            - auth_type: anonymous
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - headers: "${'Authorization: ' + auth_token}"
            - body: "${'{\"location\":\"' + location + '\",\"properties\":{\"version\":\"12.0\",\"administratorLogin\":\"' + db_server_username + '\",\"administratorLoginPassword\":\"' + db_server_password + '\"}}'}"
            - content_type: application/json
            - request_character_set: UTF-8
            - worker_group: '${worker_group}'
        publish:
          - output: '${return_result}'
          - status_code
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: retrieve_error
    - retrieve_error:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${output}'
            - json_path: 'error,message'
        publish:
          - error_message: '${return_result}'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: FAILURE
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
      create_sql_database_server:
        x: 120
        'y': 160
        navigate:
          9066cad3-745d-1dd3-fab7-13eeb4654c08:
            targetId: 3ca3aa9c-816d-d335-85a1-12965c534a16
            port: SUCCESS
      retrieve_error:
        x: 280
        'y': 280
        navigate:
          ff6a5a79-101a-4c29-2a07-a9bc99fc18e1:
            targetId: 9c2c3761-ccb0-0d73-e160-0cabb347d0d1
            port: FAILURE
          fdd6d20b-083d-b3f2-9506-f6e69dd01032:
            targetId: 9c2c3761-ccb0-0d73-e160-0cabb347d0d1
            port: SUCCESS
    results:
      FAILURE:
        9c2c3761-ccb0-0d73-e160-0cabb347d0d1:
          x: 560
          'y': 280
      SUCCESS:
        3ca3aa9c-816d-d335-85a1-12965c534a16:
          x: 360
          'y': 40
