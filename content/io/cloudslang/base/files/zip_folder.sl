# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Creates a zip archive.
#
# Inputs:
#   - archive_name - name of archive to be created (without 'zip')
#   - folder_path - path to folder to be zipped
# Outputs:
#   - message - error message in case of error
# Results:
#   - SUCCESS - archive was successfully created
#   - FAILURE - archive was not created due to error
####################################################
namespace: io.cloudslang.base.files

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
          result = True
        except Exception as e:
          message = e
          result = False

  outputs:
    - message

  results:
    - SUCCESS: result
    - FAILURE