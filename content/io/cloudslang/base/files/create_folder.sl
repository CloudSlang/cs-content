# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Creates a folder.
#! @input folder_name: name of folder to be created
#! @output message: error message in case of error
#! @result SUCCESS: folder was successfully created
#! @result FAILURE: folder was not created due to error
#!!#
####################################################
namespace: io.cloudslang.base.files

operation:
  name: create_folder
  inputs:
    - folder_name

  action:
    python_script: |
        import sys, os
        try:
          if os.path.isdir(folder_name):
            message = ("folder already exists")
            result = False
          else:
            os.mkdir(folder_name)
            message = ("folder created")
            result = True
        except Exception as e:
          message = e
          result = False

  outputs:
    - message

  results:
    - SUCCESS: ${result}
    - FAILURE
