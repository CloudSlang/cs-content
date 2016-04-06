#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Add element to list or set.
#! @input list: List in which we need to add the element  - Example: [123, 'xyz']
#! @input element: The element we want to add to the list.
#! @input unique_element: The element we want to add to the set. 
#! @output result: list or Set with new element.
#! @output error_message: Error message if unique_element is already in list.
#!!#
####################################################

namespace: io.cloudslang.base.lists

operation:
  name: add_element
  inputs:
    - list
    - element:
        default: ''
        required: false
    - unique_element:
        default: ''
        required: false

  action:
    python_script: |
      error_message = ""

      if unique_element in list and unique_element != '':
        error_message = ("Already in list")
      elif unique_element not in list and unique_element != '':
        list.append(unique_element)
      elif unique_element == '' and element != '':
        list.append(element)

  outputs:
    - result: ${list}
    - error_message
  
  results:
    - SUCCESS: ${error_message == ""}
    - FAILURE