#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Add element to list.
#! @input list: list in wich we need add element  - Example: [123, 'xyz']
#! @output result: list with new element
#!!#
####################################################

namespace: io.cloudslang.base.lists

operation:
  name: add
  inputs:
    - list
    - element
  action:
    python_script: |
      list.append(element)
  outputs:
    - result: ${list}
