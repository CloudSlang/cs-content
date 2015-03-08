# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This operation copies file/folder
#
# Inputs:
# - source - source file/folder path to be copied
# - destiantion - destination path file/folder to be copied. If coping object is a folder - destination path must include folder name, if file - destination must include file name
# Outputs:
# - message - error message in case of error
# Results:
# - SUCCESS - file/folder was successfully copied
# - FAILURE - file/folder was not copied due to an error
####################################################
namespace: org.openscore.slang.base.files

operation:
  name: copy
  inputs:
    - source
    - destination

  action:
    python_script: |
        import shutil, sys, os
        try:
          if os.path.isfile(source):
            shutil.copy(source,destination)
            result = True
          elif os.path.isdir(source):
            shutil.copytree(source,destination,)
            result = True
          else:
            message = ("no such file or folder")
            result = False
          message = ("copying done successfully")
        except Exception as e:
          message = sys.exc_info()[0]
          result = False

  outputs:
    - message: message

  results:
    - SUCCESS: result == True
    - FAILURE: result == False