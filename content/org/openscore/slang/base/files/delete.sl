# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This operation deletes a file/folder
#
# Inputs:
# - source - source file/folder path to be deleted
# Outputs:
# - message - error message in case of error
# Results:
# - SUCCESS - file/folder was successfully deleted
# - FAILURE - file/folder was not deleted due to error
####################################################
namespace: org.openscore.slang.base.files

operation:
  name: delete
  inputs:
    - source

  action:
    python_script: |
        import shutil, sys, os
        try:
          if os.path.isfile(source):
            os.remove(source)
            message = "source + ' was removed'"
            result = True
          elif os.path.isdir(source):
            shutil.rmtree(source)
            message = "source + ' was removed'"
            result = True
          else:
            message = "'No such file/folder'"
            result = False
        except Exception as e:
          message = sys.exc_info()[0]
          result = False

  outputs:
    - message: message

  results:
    - SUCCESS: result == True
    - FAILURE: result == False