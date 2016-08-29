#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Check if the list contains ints or strings.
#! @input list: list to check - e.g. "el1,el2"
#! @output result: message indicating whether the list contains int or string elements
#! @result SUCCESS: all elements in the list are ints or strings.
#! @result FAILURE: list contains both ints and string elements.
#!!#
####################################################

namespace: io.cloudslang.base.lists

operation:
  name: check_list_type
  inputs:
    - list

  python_action:
    script: |
      def representsInt(s):
          try:
              int(s)
              return True
          except ValueError:
              return False

      error_message = ""
      message = ""
      list = list.split(",")
      if all(representsInt(item) for item in list):
        message = "All elements in list are INT"
      elif any(representsInt(item) for item in list):
        error_message = "List contains STR and INT elements"
      else:
        message = "All elements in list are STR"

  outputs:
    - result: ${message}
    - error_message

  results:
    - SUCCESS: ${error_message == ""}
    - FAILURE
