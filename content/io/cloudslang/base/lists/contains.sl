#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Check element in the list.
#! @input list: list in which we need to check the element  - Example: [123, 'xyz']
#! @input delimiter: list delimiter
#!                   default: ''
#! @output element: element which we want to check
#! @output result: true - if list contains, false - if not
#!!#
####################################################

namespace: io.cloudslang.base.lists

operation:
  name: contains
  inputs:
    - list
    - delimiter:
        required: false
        default: ''
    - element
  python_action:
    script: |
      if delimiter=='':
        result = list.contains(element)
      else:
        result = element in list.split(delimiter)
  outputs:
    - result
