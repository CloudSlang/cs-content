# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This operation copyis file/folder
#
# Inputs:
# - source - source file/folder path to be copyd
# - destiantion - destination path file/folder to be copyd. If coping object is a folder - destination path must include folder name, if file - destination must include file name
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
            message = ("copying done successfully")
            result = True
          if os.path.isdir(source):
            shutil.copytree(source,destination,)
            message = ("copying done successfully")
            result = True
        except Exception as e:
          message = sys.exc_info()[0]
          result = False

  outputs:
    - message: message

  results:
    - SUCCESS: result == True
    - FAILURE: result == False