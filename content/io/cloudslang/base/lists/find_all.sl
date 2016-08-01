####################################################
#!!
#! @description: Finds all the locations of a given element within a list.
#!
#! @input list: list in which to find elements
#! @output element: element to find
#! @output indices: list of indices where <element> was found in <list>
#!!#
####################################################

namespace: io.cloudslang.base.lists

operation:
  name: find_all

  inputs:
    - list
    - element

  python_action:
    script: indices = [i for i, x in enumerate(list) if x == element]

  outputs:
    - indices
