#   (c) Copyright 2014-2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Unzips an archive.
#!
#! @input archive_path: Path to archive to be unzipped (including '.zip').
#! @input output_folder: Path of folder to place unzipped files from archive.
#!
#! @output message: Error message in case of error.
#!
#! @result SUCCESS: Archive was successfully unzipped.
#! @result FAILURE: Archive was not unzipped due to error.
#!!#
########################################################################################################################
namespace: io.cloudslang.base.filesystem

operation:
  name: unzip_archive
  inputs:
    - archive_path
    - output_folder

  python_action:
    script: |
        import zipfile
        fh = None
        try:
          fh = open(archive_path, 'rb')
          z = zipfile.ZipFile(fh)
          for name in z.namelist():
              z.extract(name, output_folder)
          fh.close()
          message = 'unzipping done successfully'
          result = True
        except Exception as e:
          if fh != None:
            fh.close()
          message = e
          result = False

  outputs:
    - message: ${ str(message) }

  results:
    - SUCCESS: ${result}
    - FAILURE
