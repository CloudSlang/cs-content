########################################################################################################################
#!!
#! @description: Build the sql query to get a database info.
#!
#! @input db_name: Specifies the name of the database to be selected
#!
#! @output sql_query: The query to get a database info. The result includes
#!                    db_name,db_owner,db_encoding,db_locale,db_description,db_template,db_tablespace
#!                    Example: `cs_test|postgres|UTF8|en_US.UTF-8||f|pg_default`
#!
#! @result SUCCESS: the query was created successfully
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.common

operation:
  name: get_db_info_query

  inputs:
    - db_name:
        required: true
  python_action:
    script: |
      result = 'SELECT d.datname, r.rolname, pg_catalog.pg_encoding_to_char(d.encoding), d.datcollate,'
      result += 'pg_catalog.shobj_description(d.oid, \'pg_database\'),  d.datistemplate, t.spcname'
      result += ' FROM pg_catalog.pg_database d  JOIN pg_catalog.pg_roles r ON d.datdba = r.oid  JOIN pg_catalog.pg_tablespace t on d.dattablespace = t.oid'
      result += ' WHERE d.datname=\'' + db_name+ '\''

  outputs:
    - sql_query: ${result}
  results:
    - SUCCESS
