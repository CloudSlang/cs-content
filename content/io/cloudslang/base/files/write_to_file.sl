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
        res = True
      except IOError as e:
        print "ERROR: no such folder or permission denied: " + str(e)
        res = False
      except Exception as e:
        print e
        res = False
  results:
    - SUCCESS: res
    - FAILURE