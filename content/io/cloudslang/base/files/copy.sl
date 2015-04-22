# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Copies a file or folder.
#
# Inputs:
#   - source - path of source file or folder to be copied
#   - destination - path of destination for file or folder to be copied to. If copying a folder, destination path must include folder name. If copying a file - destination path must include file name.
# Outputs:
#   - message - error message in case of error
# Results:
#   - SUCCESS - file or folder was successfully copied
#   - FAILURE - file or folder was not copied due to an error
####################################################
namespace: io.cloudslang.base.files

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
            message = ("copying done successfully")
          elif os.path.isdir(source):
            shutil.copytree(source,destination,)
            message = ("copying done successfully")
            result = True
            message = ("copying done successfully")
          else:
            message = ("no such file or folder")
            result = False
        except Exception as e:
          message = e
          result = False
        print message

  outputs:
    - message

  results:
    - SUCCESS: result
    - FAILURE
