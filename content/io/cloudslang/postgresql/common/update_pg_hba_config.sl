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
#! @description: The configuration modifies the pg_hba.conf file
#!
#! @input	file_path: The full path to the PostgreSQL configuration file in the local machine to be updated
#! @input	allowed_hosts: A wildcard or a comma-separated list of hostnames or IPs (IPv4 or IPv6).
#! @input	allowed_users: A semicolon-separated list of PostgreSQL users. If no value is specified for this input, all users will have access to the server.
#!
#! @output returnResult: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output returnCode: '0' if success, '-1' otherwise
#! @output exception: contains  an exception message
#! @output stderr: contains the stack trace in case of an exception
#!
#! @result SUCCESS: Postgresql configuration was modified successfully
#! @result FAILURE: There was an error modifying postgresql configuration
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.common

operation:
  name: update_pg_hba_config

  inputs:
    - file_path:
        required: true
    - allowed_hosts:
        required: false
    - allowed_users:
        required: false
  java_action:
    gav: io.cloudslang.content:cs-postgres:1.0.3
    class_name: io.cloudslang.content.postgres.actions.UpdatePgHbaConfigAction
    method_name: execute
  outputs:
     - returnCode
     - returnResult
     - stderr
     - exception
  results:
    - SUCCESS: ${ returnCode == '0' }
    - FAILURE
