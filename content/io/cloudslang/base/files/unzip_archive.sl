# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Unzips an archive.
#
# Inputs:
#   - archive_path - path to archive to be unziped (including '.zip')
#   - output_folder - path of folder to place unzipped files from archive
# Outputs:
#   - message - error message in case of error
# Results:
#   - SUCCESS - archive was successfully unzipped
#   - FAILURE - archive was not unzipped due to error
####################################################
namespace: io.cloudslang.base.files

operation:
  name: unzip_archive
  inputs:
    - archive_path
    - output_folder

  action:
    python_script: |
        import zipfile, sys
        try:
          with zipfile.ZipFile(archive_path, "r") as z:
            z.extractall(output_folder)
          message = 'unzipping done successfully'
          result = True
        except Exception as e:
          message = e
          result = False

  outputs:
    - message

  results:
    - SUCCESS: result
    - FAILURE