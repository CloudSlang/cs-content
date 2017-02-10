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
#! @input delimiter: Generated description
#! @input sql_commands: Generated description
#! @input script_file_name: Generated description
#! @input trust_all_roots: Generated description
#! @input trust_store: Generated description
#! @input trust_store_password: Generated description
#! @input database_pooling_properties: Generated description
#! @input result_set_type: Generated description
#! @input result_set_concurrency: Generated description
#!
#! @output return_code: Generated description
#! @output return_result: Generated description
#! @output exception: Generated description
#! @output update_count: Generated description
#!
#! @result SUCCESS: Generated description
#! @result FAILURE: Generated description
#!!#
########################################################################################################################

namespace: io.cloudslang.base.database

operation:
  name: sql_command

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
  - instance
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
  - delimiter:
      required: false
  - sql_commands:
      required: false
  - sqlCommands:
      default: ${get("sql_commands", "")}
      required: false
      private: true
  - script_file_name:
      required: false
  - scriptFileName:
      default: ${get("script_file_name", "")}
      required: false
      private: true
  - trust_all_roots:
      required: false
  - trustAllRoots:
      default: ${get("trust_all_roots", "false")}
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

  java_action:
    gav: 'io.cloudslang.content:cs-database:0.0.1'
    class_name: io.cloudslang.content.database.actions.SQLScript
    method_name: execute

  outputs:
  - return_code: ${returnCode}
  - return_result: ${returnResult}
  - exception: ${exception}
  - update_count: ${updateCount}

  results:
  - SUCCESS: ${returnCode=='0'}
  - FAILURE
