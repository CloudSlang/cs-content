#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: returns the length of the list
#! @input list: list which we want to get the length of - Example: 1,2,3,4,5
#! @input delimiter: list delimiter - Example: ','
#!                   default: ','
#! @output response: 'success' or 'failure'
#! @output return_result: length of the list or an error message otherwise
#! @output return_code: 0 if success, -1 if failure
#! @result SUCCESS: string list length was returned
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.base.lists

operation:
  name: length

  inputs:
    - list
    - delimiter:
        default: ','

  java_action:
    gav: 'io.cloudslang.content:cs-lists:0.0.4'
    class_name: io.cloudslang.content.actions.ListSizeAction
    method_name: getListSize

  outputs:
    - return_code: ${returnCode}
    - return_result: ${returnResult}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

