#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Compare the first list with the second list to see if they are identical or not.
#! @input list_1: first list - Example: [123, 'xyz']
#! @input list_2: second list - Example: [456, 'abc']
#! @output result: true if list_1 is identical to list_2
#! @result SUCCESS: lists are identical
#! @result FAILURE: lists are not identical
#!!#
####################################################

namespace: io.cloudslang.base.lists

operation:
  name: compare_lists
  inputs:
    - list_1
    - list_2
  action:
    python_script: |
      result = list_1 == list_2
  outputs:
    - result
  results:
    - SUCCESS: ${result}
    - FAILURE
