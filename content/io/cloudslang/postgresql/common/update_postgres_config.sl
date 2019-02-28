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
#! @description: The configuration modifies the postgresql.conf
#!
#! @input	file_path: The full path to the PostgreSQL configuration file in the local machine to be updated
#! @input	listen_addresses: changes the address where the PostgreSQL database listens.
#! @input	port: port the PostgreSQL database should listen.
#! @input	ssl: enable SSL connections.
#! @input	ssl_ca_file: name of the file containing the SSL server certificate authority (CA).
#! @input	ssl_cert_file: name of the file containing the SSL server certificate.
#! @input	ssl_key_file: name of the file containing the SSL server private key.
#! @input	max_connections: the maximum number of client connections allowed.
#! @input	shared_buffers: determines how much memory is dedicated to PostgreSQL to use for caching data.
#! @input	effective_cache_size: effective cache size
#! @input	autovacuum: enable/disable autovacuum. The autovacuum process takes care of several maintenance chores inside your database that you really need.
#! @input	work_mem: memory used for sorting and queries
#!
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
  name: update_postgres_config

  inputs:
      - file_path:
          required: true
      - listen_addresses:
          required: false
      - port:
          required: false
      - ssl:
          required: false
      - ssl_ca_file:
          required: false
      - ssl_cert_file:
          required: false
      - ssl_key_file:
          required: false
      - max_connections:
          required: false
      - shared_buffers:
          required: false
      - effective_cache_size:
          required: false
      - autovacuum:
          required: false
      - work_mem:
          required: false

  java_action:
    gav: io.cloudslang.content:cs-postgres:1.0.3
    class_name: io.cloudslang.content.postgres.actions.UpdatePostgresConfigAction
    method_name: execute
  outputs:
     - returnCode
     - returnResult
     - stderr
     - exception
  results:
    - SUCCESS: ${ returnCode == '0' }
    - FAILURE
