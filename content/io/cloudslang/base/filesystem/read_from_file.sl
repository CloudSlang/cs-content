#   (c) Copyright 2014-2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Reads a file from the given path and returns its content.
#!
#! @input file_path: The path of the file to read.
#!
#! @output read_text: Content of the file.
#! @output message: Error message if error occurred.
#!
#! @result SUCCESS: File was read successfully.
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.filesystem

operation:
  name: read_from_file

  inputs:
    - file_path

  python_action:
    script: |
      import sys
      read_text = ""
      message = ""
      try:
        f = open(file_path, 'r')
        read_text = f.read()
        f.close()
        message = 'file was read successfully'
        res = True
      except Exception as e:
        message = e
        res = False

  outputs:
    - read_text
    - message: ${ str(message) }

  results:
    - SUCCESS: ${res}
    - FAILURE
