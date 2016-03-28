#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Return length of list.
#! @input list: list in wich we need add element  - Example: [123, 'xyz']
#! @output result: length of list
#!!#
####################################################

namespace: io.cloudslang.base.lists

operation:
  name: length
  inputs:
    - list
  action:
    python_script: |
      length = len(list)
  outputs:
    - result: ${length}
