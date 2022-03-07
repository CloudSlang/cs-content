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
#! @description: This operation can be used to retrieve information about the list of all the sql servers available.
#!
#! @input subscription_id: The ID of the Azure Subscription on which the VM should be created.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to create the VM.
#! @input auth_token: Azure authorization Bearer token
#! @input api_version: The API version used to create calls to Azure
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
#! @output output: information about the specified sql servers found
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output error_message: If the no databases are foun the error message will be populated with a response,
#!                        empty otherwise
#!
#! @result SUCCESS: Information about the list of sql servers retrieved successfully.
#! @result FAILURE: There was an error while trying to retrieve information about the sql servers found
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.databases

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: list_sql_servers
  inputs:
    - subscription_id
    - resource_group_name
    - auth_token
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
        default: ********
        required: false
        sensitive: true
  workflow:
    - list_sql_databases:
        do:
          http.http_client_get:
            - url: "${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' + resource_group_name + '/providers/Microsoft.Sql/servers?api-version=' + api_version}"
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
            - trust_keystore
            - trust_password
        publish:
          - output: '${return_result}'
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: retrieve_error
    - retrieve_error:
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
      list_sql_databases:
        x: 100
        'y': 250
        navigate:
          8b168b77-bdff-4156-3d8f-3181198f70f8:
            targetId: 3204be19-04f9-ee4b-01b2-7196d111b4ff
            port: SUCCESS
      retrieve_error:
        x: 400
        'y': 375
        navigate:
          83ddc054-2868-64cb-b0c2-91afa928e02d:
            targetId: c59370b6-82f1-62e1-0b3a-763b08ba0843
            port: SUCCESS
          2065f703-a294-55b8-8355-4ae0e836d8b3:
            targetId: c59370b6-82f1-62e1-0b3a-763b08ba0843
            port: FAILURE
    results:
      SUCCESS:
        3204be19-04f9-ee4b-01b2-7196d111b4ff:
          x: 400
          'y': 125
      FAILURE:
        c59370b6-82f1-62e1-0b3a-763b08ba0843:
          x: 700
          'y': 250
