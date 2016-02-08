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
#! @input list_1: first list - ex. [123, 'xyz']
#! @input list_2: second list - ex. [456, 'abc']
#! @output result: if "true" first list is identical with the second list
#! @result SUCCESS: list are identical
#! @result FAILURE: list are not identical
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
  results:
    - SUCCESS: ${result}
    - FAILURE