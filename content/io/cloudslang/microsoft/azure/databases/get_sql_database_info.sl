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
#! @description: This operation can be used to retrieve information about the specified sql database.
#!
#! @input subscription_id: Specifies the unique identifier of Azure subscription.
#! @input resource_group_name: The name of the Azure Resource Group.
#! @input auth_token: Azure authorization Bearer token.
#! @input db_server_name: Name of the SQL Server that will be used as a place holder for your SQL database.
#! @input database_name: Azure database name.
#! @input api_version: The API version used to create calls to Azure.
#!                     Default: '2014-04-01'
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
#! @input worker_group: Optional - A worker group is a logical collection of workers. A worker may belong to more one group simultaneously.
#!                      Default: 'RAS_Operator_Path'.
#!
#! @output output: information about the specified sql database server
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output error_message: If the availability is not found the error message will be populated with a response,
#!                        empty otherwise
#!
#! @result SUCCESS: Information about the sql database retrieved successfully.
#! @result FAILURE: There was an error while trying to retrieve retrieve information about the sql database
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.databases

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: get_sql_database_info
  inputs:
    - subscription_id
    - resource_group_name
    - auth_token
    - db_server_name
    - database_name
    - api_version:
        default: '2014-04-01'
        required: true
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - proxy_port:
        default: '8080'
        required: false
    - proxy_host:
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
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - get_sql_database_info:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          http.http_client_get:
            - url: "${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' + resource_group_name + '/providers/Microsoft.Sql/servers/' + db_server_name + '/databases/' + database_name + '?api-version=' + api_version}"
            - headers: "${'Authorization: ' + auth_token}"
            - auth_type: anonymous
            - preemptive_auth: 'true'
            - content_type: application/json
            - request_character_set: UTF-8
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - worker_group: '${worker_group}'
            - trust_keystore
            - trust_password
        publish:
          - output: '${return_result}'
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: retrieve_error
    - retrieve_error:
        worker_group: '${worker_group}'
        do:
          json.get_value:
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
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_sql_database_info:
        x: 100
        'y': 250
        navigate:
          51a93621-2eb7-83c1-13f5-011f407f2b9f:
            targetId: d3c16007-cfe6-c574-1e8e-1b5202e47384
            port: SUCCESS
      retrieve_error:
        x: 400
        'y': 375
        navigate:
          7a9bfde4-3daf-9f14-88a9-387b895d82eb:
            targetId: 2843a911-bcb3-8358-3141-238a4670f7ec
            port: SUCCESS
          ceef6da4-6b4f-33f2-1162-f2623259e525:
            targetId: 2843a911-bcb3-8358-3141-238a4670f7ec
            port: FAILURE
    results:
      SUCCESS:
        d3c16007-cfe6-c574-1e8e-1b5202e47384:
          x: 400
          'y': 125
      FAILURE:
        2843a911-bcb3-8358-3141-238a4670f7ec:
          x: 700
          'y': 250
