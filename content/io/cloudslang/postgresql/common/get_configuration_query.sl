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
#! @description: Build the sql query to select database settings
#!
#!
#! @output sql_query: The query to get a database settings. The result includes
#!                    Output:
#!                       autovacuum           | on
#!                       effective_cache_size | 524288
#!                       listen_addresses     | localhost
#!                       max_connections      | 21
#!                       port                 | 5432
#!                       shared_buffers       | 16384
#!                       ssl                  | off
#!                       ssl_ca_file          |
#!                       ssl_cert_file        | server.crt
#!                       ssl_key_file         | server.key
#!                       work_mem             | 4096
#!
#! @result SUCCESS: the query was created successfully
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.common

operation:
  name: get_configuration_query

  python_action:
    script: |
      result = 'SELECT name, setting FROM pg_settings WHERE  name in (\'max_connections\', \'listen_addresses\', \'port\', \'ssl\',\'ssl_ca_file\',\'ssl_cert_file\',\'ssl_key_file\', \'shared_buffers\',\'effective_cache_size\',\'autovacuum\',\'work_mem\') order by name'
  outputs:
    - sql_query: ${result}
  results:
    - SUCCESS
