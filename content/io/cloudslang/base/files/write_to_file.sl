#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Writes text to a file.
#
# Inputs:
#   - file_path - path of the file to write to
#   - text - text to write to the file
# Outputs:
#   - message - error message if error occurred
# Results:
#   - SUCCESS - text was written to the file
#   - FAILURE - otherwise
####################################################
namespace: io.cloudslang.base.files

operation:
  name: write_to_file
  inputs:
    - file_path
    - text
  action:
    python_script: |
      try:
        f = open(file_path, 'w')
        f.write(text)
        f.close()
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
