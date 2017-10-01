#   (c) Copyright 2015-2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Reads and returns the n-th line of a given string based on '\n' chars.
#!
#! @input text: Text  input.
#!                    Example: "A lot of text here\n etc. \n"t
#! @input line_number: The position of the line we wish to read.
#!                    Example: 3
#!
#! @output line: The line we've just chosen to be read.
#!
#! @result SUCCESS: The operation executed successfully + true/ false
#! @result FAILURE: The operation could not be executed
#!!#
########################################################################################################################

namespace: io.cloudslang.base.examples.yoda

operation:
  name: read_nth_line

  inputs:
    - text
    - line_number

  python_action:
    script: |
      import sys
      import re
      try:
        index_array = [m.start() for m in re.finditer(r"\n",text)]
        second_index = int(line_number)
        first_index = second_index - 1
        index_array[first_index] = index_array[first_index] + 1
        line = text[index_array[first_index]:index_array[second_index]]
        res = True
      except Exception as e:
        print e
        message = e
        res = False
  outputs:
    - line
  results:
    - SUCCESS: ${res}
    - FAILURE
