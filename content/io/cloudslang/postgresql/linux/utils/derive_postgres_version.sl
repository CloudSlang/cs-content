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
