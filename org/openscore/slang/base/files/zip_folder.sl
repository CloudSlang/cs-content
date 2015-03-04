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
# - archive_name - name of archive to be created
# - folder_path - path to folder to be ziped
# - output_folder - folder to place created archive
# Outputs:
# - error_message - error message in case of error
# Results:
# - SUCCESS - archive was successfully cereated
# - FAILURE - archive was not created due to error
####################################################
namespace: org.openscore.slang.base.files

operation:
  name: zip_folder
  inputs:
    - archive_name
    - folder_path
    - output_folder

  action:
    python_script: |
        import sys, os, shutil
        try:
          shutil.make_archive(archive_name, "zip", folder_path)
          filename = archive_name + '.zip'
          if os.path.isdir(output_folder):
            shutil.move(filename, output_folder)
          else:
            os.mkdir(output_folder)
            shutil.move(filename, output_folder)
          result = True
        except Exception:
          error_messsage = sys.exc_info()[0]
          reselut = False

  outputs:
    - error_messsage: "'Something went wrong: ' + error_messsage"

  results:
    - SUCCESS: result == True
    - FAILURE: result == False