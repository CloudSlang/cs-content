#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: This operation trims values from a list. The values trimmed are equally distributed from the high and low ends
#!               of the list. The list is sorted before trimming. The number of elements trimmed is dictated by the percentage
#!               that is passed in.  If the percentage would indicate an odd number of elements the number trimmed is lowered
#!               by one so that the same number are taken from both ends.
#! @input list: list from which to get the sublist - Example: '1,2,3,4,5,6'
#! @input delimiter: the list delimiter
#! @input pct: the percentage of elements to trim
#! @output response: 'success' or 'failure'
#! @output return_code: 0 if success, -1 if failure
#! @output return_result: the trimmed list of elements to trim or an error message otherwise
#! @result SUCCESS: the operation finished with 'success'
#! @result FAILURE: otherwise
#!!#
####################################################
namespace: io.cloudslang.base.lists

operation:
   name: trim_list

   inputs:
     - list
     - delimiter
     - pct

   java_action:
     gav: 'io.cloudslang.content:cs-lists:0.0.4'
     class_name: io.cloudslang.content.actions.ListTrimAction
     method_name: trimList

   outputs:
     - return_code: ${returnCode}
     - return_result: ${returnResult}

   results:
     - SUCCESS: ${returnCode == '0'}
     - FAILURE
