#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation writes text to a file of the given path
#
#   Inputs:
#       - file_path - the path of the file to write to
#       - text - the text to write to the file
#   Results:
#       - SUCCESS - succeeded writing to the file
#       - FAILURE - otherwise
####################################################
namespace: org.openscore.slang.base.files

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
        res = 'True'
      except:
        print sys.exc_info()[0]
        res = 'False'
  results:
    - SUCCESS: res == 'True'
    - FAILURE