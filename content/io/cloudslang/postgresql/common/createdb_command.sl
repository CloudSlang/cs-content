########################################################################################################################
#!!
#! @description: Build the command 'createdb'  to create a new PostgreSQL database.
#!               createdb is a wrapper around the SQL command CREATE DATABASE. There is no effective difference between
#!               creating databases via this utility and via other methods for accessing the server.
#!
#!
#! @input db_name: Specifies the name of the database to be created
#!                 Optional
#! @input db_description: Specifies a comment to be associated with the newly created database
#!                        Optional
#! @input db_owner: Specifies the database user who will own the new database
#!                  Optional
#! @input db_tablespace: Specifies the default tablespace for the database
#!                       Optional
#! @input db_encoding: Specifies the character encoding scheme to be used in this database
#!                     Optional
#! @input db_locale: Specifies the locale to be used in this database
#!                   Optional
#! @input db_template: Specifies the template database from which to build this database
#!                     Optional
#! @input db_echo: Echo the commands that createdb generates and sends to the server
#!                      Valid values: 'true', 'false'
#!                      Optional
#! @input db_username:  Username to connect as.
#!                      Optional
#!
#! @output psql_command: The command to create a new database
#!
#! @result SUCCESS: the command was created successfully
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.common

operation:
  name: createdb_command

  inputs:
    - db_name:
        required: false
    - db_description:
        required: false
    - db_owner:
         required: false
    - db_tablespace:
         required: false
    - db_encoding:
         required: false
    - db_locale:
         required: false
    - db_template:
         required: false
    - db_echo:
        required: false
    - db_username:
        required: false
  python_action:
    script: |
      result = 'createdb'
      if db_tablespace is not None:
         result+= ' --tablespace=\"' + str(db_tablespace) + '\"'
      if db_echo is not None and db_echo.lower() == 'true':
         result+= ' --echo'
      if db_encoding is not None:
         result+= ' --encoding=\"' + str(db_encoding) + '\"'
      if db_locale is not None:
         result+= ' --locale=\"' + str(db_locale) + '\"'
      if db_owner is not None:
        result+= ' --owner=' + str(db_owner)
      if db_template is not None:
         result+= ' --template=\"' + str(db_template) + '\"'
      if db_username is not None:
         result+= ' --username=\"' + str(db_username) + '\" --no-password'
      if db_name is not None:
         result+= ' ' +  str(db_name)
      if db_description is not None:
         result+= ' ' +  str(db_description)
  outputs:
    - psql_command: ${result}
  results:
    - SUCCESS
