#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Sort the elements in a list.
#! @input list: Type of list (INT or STR) - Example: [123 'zyx']
#! @output result: sorted list of STR or INT elements.
#! @result SUCCESS: Sorting successfull.
#!!#
####################################################

namespace: io.cloudslang.base.lists

operation:
  name: sort_list
  inputs:
    - input_list

  action:
    python_script: |
      if all(isinstance(item, int) for item in input_list):
        result = sorted(input_list)
      elif all(isinstance(item, basestring) for item in input_list):
        sorted_list = sorted(input_list)
        string_list = []
        for item in sorted_list:
          string_list.append(str(item))
          result = string_list

  outputs:
    - result

  results:
    - SUCCESS
