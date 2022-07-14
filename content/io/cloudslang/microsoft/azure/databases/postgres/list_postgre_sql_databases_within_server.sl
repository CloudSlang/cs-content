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
#! @description: This operation can be used to get information about a specified network interface card
#!
#! @input subscription_id: The ID of the Azure Subscription on which the network interface card
#!                         information should be retrieved.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to retrieve
#!                             information about the network interface card.
#! @input auth_token: Azure authorization Bearer token
#! @input api_version: The API version used to create calls to Azure
#!                     Default: '2015-06-15'
#!                     Optional
#! @input server_name: Postgre SQL server name.
#! @input connect_timeout: Time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#!                         Optional
#! @input socket_timeout: Time in seconds to wait for data to be retrieved
#!                        Default: '0' (infinite)
#!                        Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input proxy_host: Proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: Proxy server port.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Username used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#!                                 Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#!
#! @output return_result: information about the network interface card
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#!
#! @result SUCCESS: Information about the network interface card retrieved successfully.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.databases.postgres
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: list_postgre_sql_databases_within_server
  inputs:
    - subscription_id
    - resource_group_name
    - auth_token
    - api_version:
        default: '2017-12-01'
        required: false
    - server_name
    - connect_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
        required: false
    - worker_group:
        default: RAS_Operator_Path
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
  workflow:
    - api_to_list_databases_by_server:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          http.http_client_get:
            - url: "${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' +resource_group_name + '/providers/Microsoft.DBforPostgreSQL/servers/' + server_name +'/databases?api-version=' + api_version}"
            - headers: "${'Authorization: ' + auth_token}"
            - auth_type: anonymous
            - preemptive_auth: 'true'
            - content_type: application/json
            - request_character_set: UTF-8
            - connect_timeout
            - socket_timeout
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
          - return_result
          - status_code
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result}'
            - json_path: value..name
        publish:
          - db_name_list: "${return_result.replace(\"[\\\"\",\"\").replace(\"\\\"]\",\"\").replace(\"\\\"\",\"\")}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result
    - status_code
    - db_name_list
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      api_to_list_databases_by_server:
        x: 40
        'y': 240
      json_path_query:
        x: 200
        'y': 240
        navigate:
          1be64121-9aa7-5760-c343-d69929100abb:
            targetId: 27dc4582-66ee-ec74-f455-19c2ac64172b
            port: SUCCESS
    results:
      SUCCESS:
        27dc4582-66ee-ec74-f455-19c2ac64172b:
          x: 400
          'y': 240
