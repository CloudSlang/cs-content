########################################################################################################################
#!!
#! @description: This operation iterates through a string that contains an array in the JavaScript Object Notation
#!               format (JSON).  Each time  this operation is called, it places the value of the current array element
#!               into the "returnResult" output and advances the iterator to the next array element.

#!
#! @input array: 
#!
#! @output return_code: 
#! @output return_result: 
#! @output exception: 
#!
#! @result HAS_MORE: The iterator has not yet reached the end of the array. The "returnResult" output will be populated
#!                   with the value of the current element in the array, and the iterator will advance to the next
#!                   element in the array.
#! @result NO_MORE: The iterator has reached the end of the array, and there is no more data to return. The iterator
#!                  will become undefined after this call, which basically will reset it so that if called again, this
#!                  operation will begin another iteration at the beginning of the array.
#! @result FAILURE: There was some error in iterating through the list, and the "returnResult" output will contain
#!                  information about the error. This will occur if the input array is not a valid JavaScript array.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.json

operation: 
  name: array_iterator
  
  inputs: 
    - array    
    
  java_action: 
    gav: 'io.cloudslang.content:cs-json:0.0.19-SNAPSHOT'
    class_name: 'io.cloudslang.content.json.actions.ArrayIteratorAction'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception
  
  results: 
    - HAS_MORE: ${result=='has more'} 
    - NO_MORE: ${result=='no more'} 
    - FAILURE
