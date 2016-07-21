#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: This operation checks to see if a list contains every element from another list
#! @input container: the containing list  - Example: Luke,Vader,Kenobi
#! @input sublist: the contained list - Example: Kenobi
#! @input delimiter: a delimiter separating elements in the two lists
#!                   default: ','
#! @input ignore_case: If set to 'true' then the compare is not case sensitive.
#!                     default: 'true'
#! @output response: 'true' if found, 'false' if not found
#! @output return_result: empty if sublist found in container
#!                        If the sublist was not found in the container,
#!                        it will show the elements that were not found.
#! @output return_code: 0 if found, -1 if not found
#! @output exception: something went wrong
#! @result SUCCESS: sublist was found in container
#! @result FAILURE: sublist was not found in container
#!!#
####################################################

namespace: io.cloudslang.base.lists

operation:
  name: contains
  inputs:
    - container
    - sublist
    - delimiter:
        default: ','
    - ignore_case:
        required: false
    - ignoreCase:
        default: ${get("ignore_case", "true")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-lists:0.0.4'
    class_name: io.cloudslang.content.actions.ListContainsAction
    method_name: containsElement

  outputs:
    - response
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
