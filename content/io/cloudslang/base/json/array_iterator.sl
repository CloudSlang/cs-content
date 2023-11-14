#   Copyright 2023 Open Text
#   This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: This operation iterates through a string that contains an array in the JavaScript Object Notation
#!               format (JSON).  Each time  this operation is called, it places the value of the current array element
#!               into the "result_string" output and advances the iterator to the next array element.
#!
#!
#! @input array: The JSON array that will be iterated through.
#!               Examples: For example, the following is a simple JSON array:
#!               ["cat", "dog", "horse"]
#!
#! @output result_string: This is the primary output and contains the current array element. In case of error the output
#!                        will return an empty string.
#! @output return_code: "0" if has more, "1" if no more values, and "-1" if failed.
#! @output return_result: "has more" - Another value was found in the JSON array and it has been returned,
#!                        "no more" - The iterator has gone through the entire JSON array. This response is returned once per
#!                        JSON array iteration,
#!                        In case of failure the output will be populated with the error message.
#!
#! @result HAS_MORE: The iterator has not yet reached the end of the array. The "result_string" output will be populated
#!                   with the value of the current element in the array, and the iterator will advance to the next
#!                   element in the array.
#! @result NO_MORE: The iterator has reached the end of the array, and there is no more data to return. The iterator
#!                  will become undefined after this call, which basically will reset it so that if called again, this
#!                  operation will begin another iteration at the beginning of the array.
#! @result FAILURE: There was some error in iterating through the list, and the "return_result" output will contain
#!                  information about the error. This will occur if the input array is not a valid JSON array.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.json

operation: 
  name: array_iterator
  
  inputs: 
    - array    
    
  java_action: 
    gav: 'io.cloudslang.content:cs-json:0.0.28-SNAPSHOT'
    class_name: 'io.cloudslang.content.json.actions.ArrayIteratorAction'
    method_name: 'execute'
  
  outputs: 
  - result_string: ${resultString}
  - return_result: ${returnResult}
  - return_code: ${returnCode}
  
  results: 
    - HAS_MORE: ${returnCode =='0'}
    - NO_MORE: ${returnCode =='1'}
    - FAILURE
