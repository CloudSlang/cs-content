#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Add text to a file.
#!
#! @input file_path: Path of the file to write to.
#! @input text: Text to write to the file.
#!
#! @output message: Error message if error occurred.
#!
#! @result SUCCESS: Text was written to the file.
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.filesystem

operation:
  name: add_text_to_file

  inputs:
    - file_path
    - text

  python_action:
    script: |
      import os
      try:
        with open(os.path.expandvars(file_path), 'a') as f:
          f.write(text)
        message = 'writing done successfully'
        res = True
      except IOError as e:
        message =  "ERROR: no such folder or permission denied: " + str(e)
        res = False
      except Exception as e:
        message =  e
        res = False

  outputs:
    - message

  results:
    - SUCCESS: ${res}
    - FAILURE
