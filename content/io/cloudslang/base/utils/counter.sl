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
#! @description: Counts from one number to another number.
#!
#! @input from: The number to start counting at.
#! @input to: The number to count to.
#! @input increment_by: The number to increment by while counting. If unspecified this is 1. If you wanted to count
#!                      2,4,6,8 this would be 2.
#!                      Optional
#! @input reset: If true, then the counter will restart counting from the beginning.
#!               Optional
#!
#! @output return_result: If successful, returns the complete API response. In case of an error this output will contain
#!                        the error message.
#! @output result: If successful, returns the complete API response. In case of an error this output will contain the
#!                 error message.
#!
#! @result HAS_MORE: The request was successfully executed.
#! @result NO_MORE: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.utils

operation: 
  name: counter
  
  inputs: 
    - from    
    - to    
    - increment_by:  
        required: false  
    - incrementBy: 
        default: ${get('increment_by', '')}  
        required: false 
        private: true 
    - reset:  
        required: false  
    
  java_action: 
    gav: 'io.cloudslang.content:cs-utilities:0.1.24-RC3'
    class_name: 'io.cloudslang.content.utilities.actions.Counter'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - result: ${get('result', '')} 
  
  results: 
    - HAS_MORE: ${result=='has more'} 
    - NO_MORE: ${result=='no more'} 
    - FAILURE
