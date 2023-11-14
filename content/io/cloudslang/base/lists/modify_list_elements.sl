########################################################################################################################
#!!
#! @description:  Modify elements of a given list.
#!
#! @input list: Required - The list to be modified.
#!              Example: a,b,c
#! @input method: Required - The method for modifying the values of the list.
#!               Valid values: to_uppercase, to_lowercase, add_prefix, add_suffix.
#! @input delimiter: A delimiter separating elements in the list.
#! @input value: Optional  The value for suffix or prefix.
#!                         Default value: empty string.
#!
#! @input strip_whitespaces: Optional - True if leading and trailing whitespaces should be removed from the list.
#!                           Default: false.
#!                           Valid values: true, false.
#!
#! @output return_result: The modified list if operation succeeded. Otherwise it will contain the message of the exception.
#! @output return_code: 0 if operation succeeded, -1 otherwise.
#! @output exception: The exception's stack trace if operation failed. Empty otherwise.
#!
#! @result SUCCESS: The list was modified successfully.
#! @result FAILURE: An error occurred.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.lists

operation: 
  name: modify_list_elements
  
  inputs: 
    - list:
        required: true
    - delimiter:
        required: false
        default: ","
    - method:
        required: true
    - strip_whitespaces:
        default: "false"
        required: false  
    - stripWhitespaces: 
        default: ${get('strip_whitespaces', '')}  
        required: false 
        private: true 
    - value:
        required: false  
    
  java_action: 
    gav: 'io.cloudslang.content:cs-lists:0.0.12'
    class_name: io.cloudslang.content.actions.ModifyListElementsAction
    method_name: execute
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - return_code: ${get('returnCode', '')} 
    - exception: ${get('exception', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
