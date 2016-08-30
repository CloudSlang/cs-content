####################################################
#!!
#! @description: Finds all the locations of a given element within a list.
#!
#! @input list: list in which to find elements
#! @input element: element to find
#! @input ignore_case: whether to ignore case when finding matches
#!                     default: false
#! @output indices: list of indices where <element> was found in <list>
#!!#
####################################################

namespace: io.cloudslang.base.lists

operation:
  name: find_all

  inputs:
    - list
    - element
    - ignore_case:
        default: "false"

  python_action:
    script: |
      if ignore_case.lower() == 'true':
        indices = [i for i, x in enumerate(list.split(",")) if x.lower() == element.lower()]
      else:
        indices = [i for i, x in enumerate(list.split(",")) if x == element]

  outputs:
    - indices: ${ str(indices) }
