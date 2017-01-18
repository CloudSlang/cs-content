#   (c) Copyright 2015-2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Compare the first list with the second list to see if they are identical.
#!
#! @input list_1: First list.
#!                Example: [123, 'xyz']
#! @input list_2: Second list.
#!                Example: [456, 'abc']
#!
#! @output result: True if list_1 is identical to list_2.
#!
#! @result SUCCESS: Lists are identical.
#! @result FAILURE: Lists are not identical.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.lists

decision:
  name: compare_lists

  inputs:
    - list_1
    - list_2

  outputs:
    - result: ${ str(list_1 == list_2) }

  results:
    - SUCCESS: ${list_1 == list_2}
    - FAILURE
