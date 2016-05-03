#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Checks if list contains the given element.
#! @input list: list in which to check - Example: [123, 'xyz']
#! @output element: element to check for
#! @output result: true - if list contains the element, false - if not
#!!#
####################################################

namespace: io.cloudslang.base.lists

operation:
  name: contains
  inputs:
    - list
    - element
  action:
    python_script: |
      result = list.contains(element)
  outputs:
    - result: ${result}
