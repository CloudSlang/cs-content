#   (c) Copyright 2024 Micro Focus, L.P.
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
#! @description: This workflow can be used to create an sql database.
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
#! @input db_server_password: Password value for the DB Server username.
#! @input db_server_username: Username for the newly created SQL DB Server.
#! @input product_id: The product Id.
#! @input product_name: The product name.
#! @input business_unit: The business unit.
#! @input environment: The environment type.
#! @input db_service_level: Optional - This property specifies the requested service level of the database.
#!                          Accepted values: 'Basic','S0','S1','S2','S3','P1','P2','P4','P6','P11' or 'ElasticPool'.
#!                          Default: 'S0'.
#! @input database_edition: Optional - Specifies the edition of the database.
#!                          Default: 'Standard'.
#!                          Accepted values: 'Basic','Standard','Premium' or 'DataWarehouse'
#! @input tag_name_list: Name of the tag to be added to the virtual machine
#!                       Default: ''
#!                       Optional
#! @input tag_value_list: Value of the tag to be added to the virtual machine
#!                        Default: ''
#!                        Optional
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
#!                         Default: '10' (infinite)
#! @input socket_timeout: Optional - time in seconds to wait for data to be retrieved.
#!                        Default: '0' (infinite)
#! @input worker_group: Optional - A worker group is a logical collection of workers. A worker may belong to more one group simultaneously.
#!                      Default: 'RAS_Operator_Path'.
#!
#! @output output: response with information about the created sql database.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output error_message: If a database is not found the error message will be populated with a response,
#!                        empty otherwise.
#! @output db_name: The name of the database.
#! @output database_server_name: The name of the SQL Server.
#! @output database_resource_id: The resource id of the database.
#! @output database_id: The unique identifier associated with the database.
#! @output db_server_resource_id: The unique identifier associated with the database server.
#! @output tags_json: The JSON containing both organizational tags and the custom tags.
#!
#! @result FAILURE: There was an error while trying to create the database.
#! @result SUCCESS: Database created successfully.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure
flow:
  name: azure_create_database_v2
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
        sensitive: true
    - db_server_username
    - product_id
    - product_name
    - business_unit
    - environment
    - db_service_level:
        default: S0
        required: false
    - database_edition:
        default: Standard
        required: false
    - tag_name_list:
        required: false
    - tag_value_list:
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
        default: '10'
        required: false
    - socket_timeout:
        default: '0'
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - check_tagnames_tagvalues_equal:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.microsoft.azure.utils.check_tagnames_tagvalues_equal:
            - tag_name_list: '${tag_name_list}'
            - tag_value_list: '${tag_value_list}'
        publish:
          - return_result: '${error_message}'
        navigate:
          - SUCCESS: form_tags_json
          - FAILURE: on_failure
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
          - SUCCESS: random_number_generator
          - FAILURE: on_failure
    - random_number_generator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.math.random_number_generator:
            - min: '10000'
            - max: '99999'
        publish:
          - random_number
        navigate:
          - SUCCESS: set_db_server_name
          - FAILURE: on_failure
    - set_db_server_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - db_server_name: '${db_server_name+random_number}'
        publish:
          - db_server_name
        navigate:
          - SUCCESS: create_sql_database_server
          - FAILURE: on_failure
    - random_number_generator_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.math.random_number_generator:
            - min: '10000'
            - max: '99999'
        publish:
          - random_number
        navigate:
          - SUCCESS: set_database_name
          - FAILURE: on_failure
    - set_database_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - databse_name: '${database_name+random_number}'
        publish:
          - db_name: '${databse_name}'
        navigate:
          - SUCCESS: create_sql_database
          - FAILURE: on_failure
    - get_db_server_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${db_server_name}'
            - json_path: name
        publish:
          - database_server_name: '${return_result}'
        navigate:
          - SUCCESS: random_number_generator_1
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
            - db_server_name: '${database_server_name}'
            - database_name: '${db_name}'
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
        publish:
          - db_sql_name_json: '${output}'
          - db_status_code: '${status_code}'
          - database_name
          - output
        navigate:
          - SUCCESS: get_database_status
          - FAILURE: check_database_status_code
    - get_database_status:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${db_sql_name_json}'
            - json_path: 'properties,status'
        publish:
          - database_status: '${return_result}'
        navigate:
          - SUCCESS: is_database_is_online_or_not
          - FAILURE: on_failure
    - check_database_status_code:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${db_status_code}'
            - second_string: '404'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: sleep
          - FAILURE: on_failure
    - is_database_is_online_or_not:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${database_status}'
            - second_string: Online
            - ignore_case: 'true'
        navigate:
          - SUCCESS: get_database_resource_id
          - FAILURE: on_failure
    - sleep:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '10'
        navigate:
          - SUCCESS: counter
          - FAILURE: on_failure
    - sleep_for_to_get_the_status_of_database:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '100'
        navigate:
          - SUCCESS: get_sql_database_info
          - FAILURE: on_failure
    - get_database_resource_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${db_sql_name_json}'
            - json_path: id
        publish:
          - database_resource_id: '${return_result}'
        navigate:
          - SUCCESS: get_database_id
          - FAILURE: on_failure
    - get_database_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${db_sql_name_json}'
            - json_path: 'properties,databaseId'
        publish:
          - database_id: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - counter:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.counter:
            - from: '0'
            - to: '20'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: get_sql_database_info
          - NO_MORE: FAILURE
          - FAILURE: on_failure
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
          - FAILURE: FAILURE
          - SUCCESS: FAILURE
    - get_db_server_resource_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${db_server_name}'
            - json_path: id
        publish:
          - db_server_resource_id: '${return_result}'
        navigate:
          - SUCCESS: get_db_server_name
          - FAILURE: on_failure
    - form_tags_json:
        do:
          io.cloudslang.microsoft.azure.utils.form_tags_json:
            - tag_key_list: '${tag_name_list}'
            - tag_value_list: '${tag_value_list}'
            - organizational_key_list: 'business_unit,product_id,product_name,environment'
            - organizational_value_list: "${business_unit+','+product_id+','+product_name+','+environment}"
        publish:
          - tags_json
        navigate:
          - SUCCESS: get_auth_token_using_web_api
    - create_sql_database:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.databases.create_sql_database_v1:
            - subscription_id: '${subscription_id}'
            - auth_token: '${auth_token}'
            - location: '${location}'
            - db_server_name: '${database_server_name}'
            - database_name: '${database_name}'
            - resource_group_name: '${resource_group_name}'
            - db_server_password:
                value: '${db_server_password}'
                sensitive: true
            - db_server_username: '${db_server_username}'
            - db_service_level: '${db_service_level}'
            - database_edition: '${database_edition}'
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
            - worker_group: '${worker_group}'
            - tags_json: '${tags_json}'
        publish:
          - database_status_code: '${output}'
          - status_code
          - error_message
        navigate:
          - FAILURE: delete_sql_database_server
          - SUCCESS: sleep_for_to_get_the_status_of_database
    - create_sql_database_server:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.databases.create_sql_database_server_v1:
            - subscription_id: '${subscription_id}'
            - auth_token: '${auth_token}'
            - location: '${location}'
            - db_server_name: '${db_server_name}'
            - resource_group_name: '${resource_group_name}'
            - db_server_password:
                value: '${db_server_password}'
                sensitive: true
            - db_server_username: '${db_server_username}'
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
            - worker_group: '${worker_group}'
            - tags_json: '${tags_json}'
        publish:
          - db_server_name: '${output}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_db_server_resource_id
  outputs:
    - output
    - status_code
    - error_message
    - db_name
    - database_server_name
    - database_resource_id
    - database_id
    - db_server_resource_id
    - tags_json
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_auth_token_using_web_api:
        x: 80
        'y': 520
      delete_sql_database_server:
        x: 720
        'y': 320
        navigate:
          bf579f20-6a33-43d1-216b-368128b9b213:
            targetId: 9c2c3761-ccb0-0d73-e160-0cabb347d0d1
            port: FAILURE
          e3861579-2be2-9ea0-0e54-a5dc88dbc800:
            targetId: 9c2c3761-ccb0-0d73-e160-0cabb347d0d1
            port: SUCCESS
      set_db_server_name:
        x: 240
        'y': 120
      get_db_server_resource_id:
        x: 560
        'y': 480
      random_number_generator_1:
        x: 560
        'y': 120
      check_database_status_code:
        x: 880
        'y': 320
      get_database_status:
        x: 1320
        'y': 120
      create_sql_database:
        x: 880
        'y': 120
      get_db_server_name:
        x: 560
        'y': 320
      get_database_resource_id:
        x: 1160
        'y': 520
      set_database_name:
        x: 720
        'y': 120
      create_sql_database_server:
        x: 400
        'y': 120
      sleep_for_to_get_the_status_of_database:
        x: 1040
        'y': 120
      form_tags_json:
        x: 80
        'y': 320
      get_database_id:
        x: 1320
        'y': 520
        navigate:
          9d16ccb7-e77f-b82d-8e4b-9cc4e634fac5:
            targetId: 3ca3aa9c-816d-d335-85a1-12965c534a16
            port: SUCCESS
      sleep:
        x: 1040
        'y': 320
      check_tagnames_tagvalues_equal:
        x: 80
        'y': 120
      get_sql_database_info:
        x: 1200
        'y': 120
      random_number_generator:
        x: 240
        'y': 520
      counter:
        x: 1200
        'y': 320
        navigate:
          d7e3af09-382d-0635-b956-b24ba5e0d9db:
            targetId: 9c2c3761-ccb0-0d73-e160-0cabb347d0d1
            port: NO_MORE
      is_database_is_online_or_not:
        x: 1320
        'y': 320
    results:
      FAILURE:
        9c2c3761-ccb0-0d73-e160-0cabb347d0d1:
          x: 760
          'y': 600
      SUCCESS:
        3ca3aa9c-816d-d335-85a1-12965c534a16:
          x: 1320
          'y': 720
