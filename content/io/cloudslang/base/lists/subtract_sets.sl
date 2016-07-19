#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Subtracts second set from the first - Example: set1 = 1 2 3 4 , set2 = 2 3 , set1 - set2 = 1 4.
#! @input set_1: first set - Example: "1 2 3 4"
#! @input set_1_delimiter: delimiter of the first set - Example: " "
#! @input set_2: second set - Example: "2 3"
#! @input set_2_delimiter: delimiter of the second set - Example: " "
#! @input result_set_delimiter: delimiter of the result set - Example: " "
#! @output result_set: elements from set_1 which are not in set_2
#! @result SUCCESS: subtraction succeeded
#!!#
####################################################

namespace: io.cloudslang.base.lists

operation:
  name: subtract_sets
  inputs:
    - set_1:
        required: false
    - set_1_delimiter
    - set_2:
        required: false
    - set_2_delimiter
    - result_set_delimiter
  python_action:
    script: |
      arr_list_1 = set_1.split(set_1_delimiter)
      arr_list_2 = set_2.split(set_2_delimiter)

      result =  set(arr_list_1) - set(arr_list_2)

      result_set = result_set_delimiter.join(result)
  outputs:
    - result_set
  results:
    - SUCCESS
