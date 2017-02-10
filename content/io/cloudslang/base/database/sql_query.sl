########################################################################################################################
#!!
#! @description: Generated operation description
#!
#! @input db_server_name: Generated description
#! @input db_type: Generated description
#! @input username: Generated description
#! @input password: Generated description
#! @input instance: Generated description
#! @input db_port: Generated description
#! @input database_name: Generated description
#! @input authentication_type: Generated description
#! @input db_class: Generated description
#! @input db_url: Generated description
#! @input command: Generated description
#! @input trust_all_roots: Generated description
#! @input trust_store: Generated description
#! @input trust_store_password: Generated description
#! @input delimiter: Generated description
#! @input key: Generated description
#! @input timeout: Generated description
#! @input database_pooling_properties: Generated description
#! @input result_set_type: Generated description
#! @input result_set_concurrency: Generated description
#! @input ignore_case: Generated description
#!
#! @output return_code: Generated description
#! @output return_result: Generated description
#! @output exception: Generated description
#! @output rows_left: Generated description
#! @output column_names: Generated description
#! @output sql_query: Generated description
#!
#! @result HAS_MORE: Generated description
#! @result NO_MORE: Generated description
#! @result FAILURE: Generated description
#!!#
########################################################################################################################

namespace: io.cloudslang.base.database

operation:
  name: sql_query

  inputs:
  - db_server_name
  - dbServerName:
      default: ${get("db_server_name", "")}
      required: false
      private: true
  - db_type:
      required: false
  - dbType:
      default: ${get("db_type", "")}
      required: false
      private: true
  - username
  - password:
      sensitive: true
  - instance:
      required: false
  - db_port:
      required: false
  - DBPort:
      default: ${get("db_port", "")}
      required: false
      private: true
  - database_name
  - databaseName:
      default: ${get("database_name", "")}
      required: false
      private: true
  - authentication_type:
      required: false
  - authenticationType:
      default: ${get("authentication_type", "")}
      required: false
      private: true
  - db_class:
      required: false
  - dbClass:
      default: ${get("db_class", "")}
      required: false
      private: true
  - db_url:
      required: false
  - dbURL:
      default: ${get("db_url", "")}
      required: false
      private: true
  - command
  - trust_all_roots:
      required: false
  - trustAllRoots:
      default: ${get("trust_all_roots", "")}
      required: false
      private: true
  - trust_store:
      required: false
  - trustStore:
      default: ${get("trust_store", "")}
      required: false
      private: true
  - trust_store_password:
      required: false
  - trustStorePassword:
      default: ${get("trust_store_password", "")}
      required: false
      private: true
  - delimiter:
      default: ','
      required: false
  - key:
      private: false
      sensitive: false
      required: true
  - timeout:
      required: false
  - database_pooling_properties:
      required: false
  - databasePoolingProperties:
      default: ${get("database_pooling_properties", "")}
      required: false
      private: true
  - result_set_type:
      required: false
  - resultSetType:
      default: ${get("result_set_type", "")}
      required: false
      private: true
  - result_set_concurrency:
      required: false
  - resultSetConcurrency:
      default: ${get("result_set_concurrency", "")}
      required: false
      private: true
  - ignore_case:
      required: false
  - ignoreCase:
      default: ${get("ignore_case", "")}
      required: false
      private: true

  java_action:
    gav: 'io.cloudslang.content:cs-database:0.0.1'
    class_name: io.cloudslang.content.database.actions.SQLQuery
    method_name: execute

  outputs:
  - return_code: ${returnCode}
  - return_result: ${returnResult}
  - exception: ${exception}
  - rows_left: ${rowsLeft}
  - column_names: ${columnNames}
  - sql_query: ${sqlQuery}

  results:
  - 'HAS_MORE': ${returnCode=='0'}
  - 'NO_MORE': ${returnCode=='1'}
  - FAILURE
