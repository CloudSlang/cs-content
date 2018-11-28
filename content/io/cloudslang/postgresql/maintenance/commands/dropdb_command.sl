########################################################################################################################
#!!
#! @description: Build the command 'dropdb' to remove a PostgreSQL database
#!
#!
#! @input db_name: Specifies the name of the database to be removed
#! @input db_username:  Username to connect as.
#!                      Optional
#! @input db_echo: Echo the commands that dropdb generates and sends to the server
#!              Valid values: 'true', 'false'
#!              Optional
#!
#!
#! @output psql_command: The command to remove a database
#! @output return_code: '0' , success
#!
#! @result SUCCESS: the command was created successfully
#!!#
########################################################################################################################
namespace: io.cloudslang.postgresql.maintenance.commands

imports:

operation:
  name: dropdb_command

  inputs:
    - db_name:
        required: true
    - db_username:
        required: false
    - db_echo:
        required: false
  python_action:
    script: |
      result = 'dropdb '
      if (db_echo is not None and db_echo.lower() == 'true'):
         result+= ' --echo'
      if db_username is not None:
         result+= ' --username=\"' + str(db_username) + '\" --no-password'
      result += ' ' + db_name
  outputs:
    - psql_command: ${result}
  results:
    - SUCCESS