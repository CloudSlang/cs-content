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
#   - archive_name - path of archive to be unzipped (including '.zip')
#   - output_folder - path of folder to place unzipped files from archive
# Outputs:
#   - message - error message in case of error
# Results:
#   - SUCCESS - archive was successfully unzipped
#   - FAILURE - archive was not unzipped due to error
####################################################
namespace: org.openscore.slang.base.files

operation:
  name: unzip_archive
  inputs:
    - archive_name
    - output_folder

  action:
    python_script: |
        import zipfile, sys
        try:
          with zipfile.ZipFile(archive_name, "r") as z:
            z.extractall(output_folder)
          message = 'unzipping done successfully'
          result = True
        except Exception:
          message = sys.exc_info()[0]
          result = False
  outputs:
    - message

  results:
    - SUCCESS: result == True
    - FAILURE: result == False