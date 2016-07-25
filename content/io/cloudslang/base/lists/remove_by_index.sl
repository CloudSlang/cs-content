#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Remove an element from a list of strings
#! @input list: the list to remove from - Example: '1,2,3,4,5'
#! @input element: the index of the element to remove from the list - Example: '1'
#! @input delimiter: the list delimiter - Example: ','
#! @output response: index of the element to remove
#! @output return_result: the new list or an error message otherwise
#! @output return_code: 0 if success, -1 if failure
#! @result SUCCESS: element removed with success
#! @result FAILURE: otherwise
#!!#
####################################################
namespace: io.cloudslang.base.lists

operation:
   name: remove_by_index

   inputs:
     - list
     - element
     - delimiter

   java_action:
     gav: 'io.cloudslang.content:cs-lists:0.0.4'
     class_name: io.cloudslang.content.actions.ListRemoverAction
     method_name: removeElement

   outputs:
     - return_result: ${returnResult}
     - return_code: ${returnCode}

   results:
     - SUCCESS: ${returnCode == '0'}
     - FAILURE
