#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Get element from list.
#! @input list: list from which we want to get the element  - Example: [123, 'xyz']
#! @input delimiter: list delimiter
#!                   Default: ','
#! @output index: index of this element
#! @output result: element
#! @output error_message: something went wrong - exception
#! @result SUCCESS: error_message empty and
#!!#
####################################################
namespace: io.cloudslang.base.lists

operation:
   name: get_by_index

   inputs:
     - list
     - delimiter:
        default: ','
     - index
   python_action:
     script: |
       try:
         error_message = ""
         index = int(index)
         result = list.split(delimiter).pop(index)
       except ValueError:
         error_message = "Index must be integer"
       except Exception as e:
         error_message = e
   outputs:
     - result
     - error_message
   results:
     - SUCCESS: ${error_message == ""}
     - FAILURE
