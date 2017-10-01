#   (c) Copyright 2015-2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Counts the number of new lines in a string by counting the '\n' char.
#!
#! @input text: Text  input.
#!                    Example: "A lot of text here"t
#!
#! @output number_of_lines: The number of new lines the passed text has
#!
#! @result SUCCESS: The operation executed successfully + true/ false
#! @result FAILURE: The operation could not be executed
#!!#
########################################################################################################################

namespace: io.cloudslang.base.examples.yoda

operation:
  name: count_lines

  inputs:
    - text

  python_action:
    script: |
      import sys
      try:
        number_of_lines = str(text.count('\n'))
        number_of_lines = str(int(number_of_lines) - 1)
        res = True
      except Exception as e:
        print e
        message = e
        res = False
  outputs:
    - number_of_lines
  results:
    - SUCCESS: ${res}
    - FAILURE
