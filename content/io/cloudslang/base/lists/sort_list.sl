#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: This operation sorts a list of strings. If the list contains only numerical strings,
#!               it is sorted in numerical order. Otherwise it is sorted alphabetically.
#! @input list: the list to be sorted - Example: '4,3,5,2,1'
#! @input delimiter: the list delimiter - Example: ','
#! @input reverse: optional - a boolean value for sorting the list in reverse order
#!                 default: False
#! @output response: 'success' or 'failure'
#! @output return_result: the sorted list or an error message otherwsie
#! @output return_code: 0 if success, -1 if failure
#! @result SUCCESS: sorting successfull
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.base.lists

operation:
  name: sort_list

  inputs:
    - list
    - delimiter
    - reverse:
        required: false
        default: false

  java_action:
    gav: 'io.cloudslang.content:cs-lists:0.0.4'
    class_name: io.cloudslang.content.actions.ListSortAction
    method_name: sortList

  outputs:
    - return_code: ${returnCode}
    - return_result: ${returnResult}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
