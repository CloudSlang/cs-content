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
# Outputs:
# - message - error message in case of error
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

  action:
    python_script: |
        import sys, os, shutil
        try:
          shutil.make_archive(archive_name, "zip", folder_path)
          filename = archive_name + '.zip'
          shutil.move(filename, folder_path)
          message = "'zip created successfully'"
          result = True
        except Exception:
          messsage = sys.exc_info()[0]
          result = False

  outputs:
    - message: message

  results:
    - SUCCESS: result == True
    - FAILURE: result == False