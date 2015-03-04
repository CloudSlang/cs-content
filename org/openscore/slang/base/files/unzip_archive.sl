# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This operation creates a zip archive
#
# Inputs:
# - archive_name - name of archive to be unziped (including '.zip')
# - output_folder - folder to place unziped files from archvie
# Outputs:
# - error_message - error message in case of error
# Results:
# - SUCCESS - archive was successfully unziped
# - FAILURE - archive was not unziped due to error
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
          result = True
        except Exception as e:
          error_message = sys.exc_info()[0]
          result = False

  outputs:
    - error_message: "'Something went wrong' + error_message"

  results:
    - SUCCESS: result == True
    - FAILURE: result == False