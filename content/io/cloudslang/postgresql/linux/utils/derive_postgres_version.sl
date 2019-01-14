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
#! @description: Derive the appropriate package name or home directory based on the version
#!
#! @input service_name: The service name.
#!
#! @output pkg_name: The package name.
#! @output home_dir: The home directory.
#! @output initdb_dir: The initdb_dir directory.
#! @output setup_file: The setup_file.
#!
#! @result SUCCESS: String is found at least once.
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.linux.utils

operation:
  name: derive_postgres_version

  inputs:
    - service_name:
        default: 'postgresql-10'
        required: false

  python_action:
    script: |
      if service_name == 'postgresql-10':
        pkg_name = 'postgresql10'
        home_dir = 'pgsql-10'
        initdb_dir = '/var/lib/pgsql/10'
        setup_file = 'postgresql-10-setup'
      elif service_name == 'postgresql-9.5':
        pkg_name = 'postgresql95'
        home_dir = 'pgsql-9.5'
        initdb_dir = '/var/lib/pgsql/9.5'
        setup_file = 'postgresql95-setup '
      else:
        pkg_name = 'postgresql96'
        home_dir = 'pgsql-9.6'
        initdb_dir = '/var/lib/pgsql/9.6'
        setup_file = 'postgresql96-setup'
  outputs:
    - pkg_name
    - home_dir
    - initdb_dir
    - setup_file
  results:
    - SUCCESS: true
