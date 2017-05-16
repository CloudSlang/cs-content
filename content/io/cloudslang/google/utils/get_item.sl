########################################################################################################################
#!!
#! @description: Generated flow description
#!
#! @input list: Generated description
#! @input delimiter: Generated description
#! @input index: Generated description
#!
#! @output item: Generated description
#! @output return_code: Generated description
#!
#! @result SUCCESS: Flow completed successfully.
#! @result FAILURE: Failure occured during execution.
#!!#
########################################################################################################################

namespace: io.cloudslang.google.utils

imports:
  lists: io.cloudslang.base.lists

flow:
  name: get_item

  inputs:
    - list
    - delimiter
    - index

  workflow:
    - get_item_by_index:
        do:
          lists.get_by_index:
            - list
            - delimiter
            - index
        publish:
          - return_result
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - item: ${return_result}
    - return_code

  results:
    - SUCCESS
    - FAILURE