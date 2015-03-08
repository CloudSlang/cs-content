# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This operation moves file/folder
#
# Inputs:
# - source - source file/folder path to be moved
# - destiantion - destination path file/folder to be moved
# Outputs:
# - message - error message in case of error
# Results:
# - SUCCESS - file/folder was successfully moved
# - FAILURE - file/folder was not moved due to an error
####################################################
namespace: org.openscore.slang.base.files

operation:
  name: move
  inputs:
    - source
    - destination

  action:
    python_script: |
        import shutil, sys
        try:
          shutil.move(source,destination)
          message = ("moving done successfully")
          result = True
        except Exception as e:
          message = sys.exc_info()[0]
          result = False

  outputs:
    - message: message

  results:
    - SUCCESS: result == True
    - FAILURE: result == False