#   (c) Copyright 2019 Micro Focus, L.P.
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
#! @description: Build the command 'dropdb' to remove a PostgreSQL database
#!
#!
#! @input db_name: Specifies the name of the database to be removed
#! @input db_username:  Username to connect as.
#!                      Optional
#! @input db_password: Password of the username.
#!                     Optional
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
namespace: io.cloudslang.postgresql.common

imports:

operation:
  name: dropdb_command

  inputs:
    - db_name:
        required: true
    - db_username:
        required: false
    - db_password:
        required: false
    - db_echo:
        required: false
  python_action:
    script: |
      result = 'dropdb'
      if (db_echo is not None and db_echo.lower() == 'true'):
         result+= ' --echo'
      if db_username is not None:
         result+= ' --username=\"' + str(db_username) + '\"'
      if db_password is None:
         result+= ' --no-password'
      result += ' ' + db_name
  outputs:
    - psql_command: ${result}
  results:
    - SUCCESS
