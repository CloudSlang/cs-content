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
#! @description: This operation can be used to create a network interface card
#!
#! @input subscription_id: The ID of the Azure Subscription on which the network interface card should be created.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to create the network interface card.
#! @input tenant_id: Azure authorization Bearer token
#! @input api_version: The API version used to create calls to Azure
#!                     Default: '2015-06-15'
#! @input server_name: network interface card name
#! @input server_sku_name: Virtual machine public IP address
#! @input server_sku_tier: Name of the virtual network in which the virtual machine will be assigned to
#! @input server_storage_in_gb: The name of the Subnet in which the created VM should be added.
#! @input location: Specifies the supported Azure location where the network interface card should be created.
#!                  This can be different from the location of the resource group.
#! @input connect_timeout: Optional - time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#! @input socket_timeout: Optional - time in seconds to wait for data to be retrieved
#!                        Default: '0' (infinite)
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
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
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - the password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!
#! @output return_result: json response about the network card interface created
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#!
#! @result SUCCESS: Network interface card created successfully.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.databases.postgres
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: create_postgre_sql_server
  inputs:
    - subscription_id
    - resource_group_name
    - tenant_id
    - client_id
    - client_secret:
        sensitive: true
    - api_version:
        default: '2017-12-01'
        required: true
    - server_name
    - server_sku_name
    - server_sku_tier
    - server_storage_in_gb:
        required: true
    - location
    - server_login_username
    - server_login_password:
        sensitive: true
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
    - server_version: '11'
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
          - SUCCESS: gte_server_storage_in_mb
          - FAILURE: on_failure
    - gte_server_storage_in_mb:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.math.multiply_numbers:
            - value1: '${server_storage_in_gb}'
            - value2: '1024'
        publish:
          - server_storage_in_mb: '${result}'
        navigate:
          - SUCCESS: server_sku_capacity_and_family
    - api_to_create_postgre_sql_server:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          http.http_client_put:
            - url: "${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' +resource_group_name + '/providers/Microsoft.DBforPostgreSQL/servers/' + server_name +'?api-version=' + api_version}"
            - body: "${'{\"location\": \"'+location+'\",\"properties\": { \"version\":\"'+server_version+'\", \"administratorLogin\": \"'+server_login_username+'\",\"administratorLoginPassword\": \"'+server_login_password+'\",\"sslEnforcement\": \"Enabled\",\"minimalTlsVersion\": \"TLS1_2\",\"storageProfile\": { \"storageMB\": '+server_storage_in_mb+',\"backupRetentionDays\": 7,\"geoRedundantBackup\": \"Disabled\"},\"createMode\": \"Default\"} ,\"sku\": {\"name\": \"'+server_sku_name+'\",\"tier\": \"'+server_sku_tier+'\",\"capacity\": '+server_sku_capacity+',\"family\": \"'+server_sku_family+'\"}}'}"
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
            - trust_keystore
            - trust_password
        publish:
          - output: '${return_result}'
          - status_code
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_postgre_sql_server_name_info_1
    - server_sku_capacity_and_family:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - server_sku_name: '${server_sku_name}'
        publish:
          - server_sku_capacity: '${server_sku_name.split("_")[2]}'
          - server_sku_family: '${server_sku_name.split("_")[1]}'
        navigate:
          - SUCCESS: api_to_create_postgre_sql_server
          - FAILURE: on_failure
    - compare_power_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '200'
        navigate:
          - SUCCESS: get_fqdn_value
          - FAILURE: counter
    - wait_before_check:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: get_postgre_sql_server_name_info_1
          - FAILURE: on_failure
    - counter:
        do:
          io.cloudslang.base.utils.counter:
            - from: '1'
            - to: '60'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: wait_before_check
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - compare_power_state_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '404'
        navigate:
          - SUCCESS: counter
          - FAILURE: on_failure
    - get_postgre_sql_server_name_info_1:
        do:
          io.cloudslang.microsoft.azure.databases.postgres.get_postgre_sql_server_name_info:
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - auth_token: '${auth_token}'
            - api_version: '${api_version}'
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
          - SUCCESS: compare_power_state
          - FAILURE: compare_power_state_1
    - list_postgre_sql_databases_within_server:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.databases.postgres.list_postgre_sql_databases_within_server:
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
          - db_name_list
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_fqdn_value:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: 'properties,fullyQualifiedDomainName'
        publish:
          - fqdn: '${return_result}'
        navigate:
          - SUCCESS: get_db_version
          - FAILURE: on_failure
    - get_db_version:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: 'properties,version'
        publish:
          - db_version: '${return_result}'
        navigate:
          - SUCCESS: get_resource_id
          - FAILURE: on_failure
    - get_resource_id:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: id
        publish:
          - resource_id: '${return_result}'
        navigate:
          - SUCCESS: get_status
          - FAILURE: on_failure
    - get_status:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: 'properties,userVisibleState'
        publish:
          - status: '${return_result}'
        navigate:
          - SUCCESS: get_server_name
          - FAILURE: on_failure
    - get_server_name:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: name
        publish:
          - final_server_name: '${return_result}'
        navigate:
          - SUCCESS: get_admin_username
          - FAILURE: on_failure
    - get_admin_username:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: 'properties,administratorLogin'
            - final_server_name: '${final_server_name}'
        publish:
          - admin_username: "${return_result+'@'+final_server_name}"
        navigate:
          - SUCCESS: list_postgre_sql_databases_within_server
          - FAILURE: on_failure
  outputs:
    - return_result
    - status_code
    - db_name_list
    - fqdn
    - db_version
    - resource_id
    - status
    - final_server_name
    - admin_username
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_auth_token_using_web_api:
        x: 40
        'y': 40
      get_db_version:
        x: 320
        'y': 600
      get_resource_id:
        x: 160
        'y': 600
      compare_power_state_1:
        x: 480
        'y': 440
      get_admin_username:
        x: 40
        'y': 200
      get_fqdn_value:
        x: 320
        'y': 440
      wait_before_check:
        x: 680
        'y': 280
      server_sku_capacity_and_family:
        x: 320
        'y': 40
      gte_server_storage_in_mb:
        x: 160
        'y': 40
      get_postgre_sql_server_name_info_1:
        x: 480
        'y': 280
      list_postgre_sql_databases_within_server:
        x: 160
        'y': 200
        navigate:
          8cbf99a7-fe8b-742c-6657-d37895d306d2:
            targetId: 14e0bacc-5399-3e9e-c3c2-7a4d882ed416
            port: SUCCESS
      get_status:
        x: 40
        'y': 600
      counter:
        x: 480
        'y': 600
        navigate:
          21ebec28-8d39-98d4-3cc4-3d19765803a0:
            targetId: 942795f5-253b-c1d5-bf38-143630292a6c
            port: NO_MORE
      compare_power_state:
        x: 320
        'y': 280
      api_to_create_postgre_sql_server:
        x: 480
        'y': 40
      get_server_name:
        x: 40
        'y': 400
    results:
      SUCCESS:
        14e0bacc-5399-3e9e-c3c2-7a4d882ed416:
          x: 160
          'y': 400
      FAILURE:
        942795f5-253b-c1d5-bf38-143630292a6c:
          x: 680
          'y': 600
