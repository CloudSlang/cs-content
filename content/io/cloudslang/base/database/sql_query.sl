########################################################################################################################
#!!
#! @description: Generated operation description
#!
#! @input db_server_name: The hostname or ip address of the database server.
#! @input db_type: The type of database to connect to.
#!                Valid values: Oracle, MSSQL, Sybase, Netcool, DB2, PostgreSQL and Custom.
#! @input username: The username to use when connecting to the database.
#! @input password:  The password to use when connecting to the database.
#! @input instance:  The name instance (for MSSQL Server). Leave it blank for default instance.
#! @input db_port: The port to connect to.
#!                 Default values: Oracle: 1521, MSSQL: 1433, Sybase: 5000, Netcool: 4100, DB2: 50000, PostgreSQL: 5432.
#! @input database_name: The name of the database.
#! @input authentication_type: The type of authentication used to access the database (applicable only to MSSQL type).
#!                             Default: sql
#!                             Values: sql
#!                             Note: currently, the only valid value is sql, more are planed
#! @input db_class: The classname of the JDBC driver to use.
#! @input db_url: The url required to load up the driver and make your connection.
#! @input command: The command to execute.
#! @input delimiter: Generated description
#! @input key: Generated description
#! @input timeout: Generated description
#! @input database_pooling_properties: Properties for database pooling configuration. Pooling is disabled by default.
#!                                     Default: db.pooling.enable=false
#!                                     Example: db.pooling.enable=true
#! @input result_set_type: The result set type. See JDBC folder description for more details.
#!                         Valid values: TYPE_FORWARD_ONLY, TYPE_SCROLL_INSENSITIVE,TYPE_SCROLL_SENSITIVE.
#!                         Default value: TYPE_SCROLL_INSENSITIVE except DB2 which is overridden to TYPE_FORWARD_ONLY
#! @input result_set_concurrency: The result set concurrency. See JDBC folder description for more details.
#!                                Valid values: CONCUR_READ_ONLY, CONCUR_UPDATABLE
#!                                Default value: CONCUR_READ_ONLY
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
