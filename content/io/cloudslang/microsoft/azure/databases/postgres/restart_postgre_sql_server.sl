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
#! @description: This operation can be used to restart a virtual machine
#!
#! @input subscription_id: The ID of the Azure Subscription on which the VM should be restarted.
#! @input client_secret: Azure authorization Bearer token
#! @input server_name: The name of the virtual machine to be restarted.
#!                     Virtual machine name cannot contain non-ASCII or special characters.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to restart the VM.
#! @input api_version: The API version used to create calls to Azure
#!                     Default: '2015-06-15'
#! @input connect_timeout: Optional - time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#! @input socket_timeout: Optional - time in seconds to wait for data to be retrieved
#!                        Default: '0' (infinite)
#! @input proxy_username: Optional - Username used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input proxy_port: Optional - proxy server port
#!                    Default: '8080'
#! @input proxy_host: Optional - proxy server used to access the web site
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
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
#!                        Default: ''
#! @input worker_group: Optional - A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output return_result: Json response with the information about the restarted VM.
#! @output status_code: 202 if request completed successfully, others in case something went wrong
#!
#! @result SUCCESS: Virtual machine restarted successfully.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.databases.postgres
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: restart_postgre_sql_server
  inputs:
    - subscription_id
    - client_id
    - client_secret:
        sensitive: true
    - tenant_id
    - server_name
    - resource_group_name
    - api_version:
        default: '2017-12-01'
        required: false
    - connect_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - proxy_port:
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
    - get_auth_token_using_web_api:
        do:
          io.cloudslang.microsoft.azure.authorization.get_auth_token_using_web_api:
            - tenant_id: '${tenant_id}'
            - client_id: '${client_id}'
            - client_secret:
                value: '${client_secret}'
                sensitive: true
            - resource: 'https://management.azure.com/'
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
          - auth_token
        navigate:
          - SUCCESS: api_to_restart_server
          - FAILURE: on_failure
    - api_to_restart_server:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          http.http_client_post:
            - url: "${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' +resource_group_name + '/providers/Microsoft.DBforPostgreSQL/servers/' + server_name +'/restart?api-version=' + api_version}"
            - headers: "${'Content-Length: 0 \\nAuthorization: '+ auth_token}"
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
            - trust_keystore
            - trust_password
        publish:
          - return_result
          - status_code
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_postgre_sql_server_name_info
    - set_server_status:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: 'properties,userVisibleState'
        publish:
          - server_status: '${return_result}'
        navigate:
          - SUCCESS: compare_server_state
          - FAILURE: on_failure
    - compare_server_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${server_status}'
            - second_string: Ready
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: counter
    - counter:
        do:
          io.cloudslang.base.utils.counter:
            - from: '1'
            - to: '60'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: wait_before_check
          - NO_MORE: FAILURE_1
          - FAILURE: on_failure
    - wait_before_check:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: get_postgre_sql_server_name_info
          - FAILURE: on_failure
    - get_postgre_sql_server_name_info:
        do:
          io.cloudslang.microsoft.azure.databases.postgres.get_postgre_sql_server_name_info:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - auth_token: '${auth_token}'
            - server_name: '${server_name}'
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - worker_group: '${worker_group}'
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
          - return_result: '${return_result}'
          - status_code: '${status_code}'
        navigate:
          - SUCCESS: set_server_status
          - FAILURE: on_failure
  outputs:
    - return_result
    - status_code
    - server_status
  results:
    - SUCCESS
    - FAILURE
    - FAILURE_1
extensions:
  graph:
    steps:
      get_auth_token_using_web_api:
        x: 200
        'y': 240
      api_to_restart_server:
        x: 360
        'y': 240
      set_server_status:
        x: 720
        'y': 240
      compare_server_state:
        x: 720
        'y': 400
        navigate:
          8ebcfebb-99ab-b9f2-4b5b-42700215c86a:
            targetId: 5ee8c8cd-b46b-3938-ced3-dbdd814dfc98
            port: SUCCESS
      counter:
        x: 720
        'y': 600
        navigate:
          bbdc83f7-ff47-96d6-e66c-cae70d2228df:
            targetId: 063caf97-a82c-57a2-57f1-52bb58db8e9e
            port: NO_MORE
      wait_before_check:
        x: 560
        'y': 600
      get_postgre_sql_server_name_info:
        x: 520
        'y': 240
    results:
      SUCCESS:
        5ee8c8cd-b46b-3938-ced3-dbdd814dfc98:
          x: 960
          'y': 400
      FAILURE_1:
        063caf97-a82c-57a2-57f1-52bb58db8e9e:
          x: 960
          'y': 600
