#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Finds all the locations of a given element within a list.
#!
#! @input list: List in which to find elements.
#! @input element: Element to find.
#! @input ignore_case: Whether to ignore case when finding matches.
#!                     Default: 'false'
#!
#! @output indices: List of indices where <element> was found in <list>
#!
#! @result SUCCESS: Element(s) found in list.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.lists

operation:
  name: find_all

  inputs:
    - list
    - element
    - ignore_case:
        default: 'false'

  python_action:
    script: |
      if ignore_case.lower() == 'true':
        indices = [str(i) for i, x in enumerate(list.split(",")) if x.lower() == element.lower()]
      else:
        indices = [str(i) for i, x in enumerate(list.split(",")) if x == element]

  outputs:
    - indices: ${ ",".join(indices) }
