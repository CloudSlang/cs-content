#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation reads a file of the given path and returns its content
#
#   Inputs:
#       - file_path - the path of the file to read
#   Outputs:
#       - read_text - content of the file
#   Results:
#       - SUCCESS - succeeded reading the file
#       - FAILURE - otherwise
####################################################
namespace: org.openscore.slang.base.files

operation:
  name: read_from_file
  inputs:
    - file_path
  action:
    python_script: |
      import sys
      try:
        f = open(file_path, 'r')
        read_text = f.read()
        f.close()
        res = 'True'
      except:
        print sys.exc_info()[0]
        res = 'False'
  outputs:
    - read_text
  results:
    - SUCCESS: res == 'True'
    - FAILURE