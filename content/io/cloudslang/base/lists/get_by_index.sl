#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: This operation is used to retrieve a value from a list.
#!               When the index of an element from a list is known,
#!               this operation can be used to get the element.
#! @input list: list from which we want to get the element  - Example: '1,2,3,4,5,6'
#! @input delimiter: the list delimiter
#! @input index: index of the value (starting with 0) to retrieve from the list
#! @output response: 'success' or 'failure'
#! @output return_code: 0 if success, -1 if failure
#! @output return_result: returns the value found at the specified index in the list, if the value specified for
#!                        the index input is (starting with 0) positive and less than the size of the list.
#!                        Otherwise, it returns the value specified for index.
#! @result SUCCESS: value retrieved with success
#! @result FAILURE: otherwise
#!!#
####################################################
namespace: io.cloudslang.base.lists

operation:
   name: get_by_index

   inputs:
     - list
     - delimiter
     - index

   java_action:
     gav: 'io.cloudslang.content:cs-lists:0.0.4'
     class_name: io.cloudslang.content.actions.ListItemGrabberAction
     method_name: grabItemFromList

   outputs:
     - return_code: ${returnCode}
     - return_result: ${returnResult}

   results:
     - SUCCESS: ${returnCode == '0'}
     - FAILURE
