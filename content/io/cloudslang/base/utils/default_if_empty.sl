#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
#   All rights reserved. This program and the accompanying materials
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
#! @description: This operation checks if a string is blank or empty and if it's true
#!               a default value will be assigned instead of the initial string.
#!
#! @input initial_value: The initial string.
#!                       Optional
#! @input default_value: The default value used to replace the initial string.
#! @input trim: A variable used to check if the initial string is blank or empty.
#!              Default: 'true'
#!              Optional
#!
#! @output return_result: This will contain the replaced string with the default value.
#! @output return_code: The returnCode of the operation: 0 for success, -1 for failure.
#! @output exception: In case of success response, this result is empty.
#!                    In case of failure response, this result contains the java stack trace of the runtime exception.
#!
#! @result SUCCESS: The operation completed successfully.
#! @result FAILURE: An error occurred during execution.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.utils

operation: 
  name: default_if_empty
  
  inputs: 
    - initial_value:  
        required: false  
    - initialValue: 
        default: ${get('initial_value', '')}  
        required: false 
        private: true 
    - default_value    
    - defaultValue: 
        default: ${get('default_value', '')}  
        required: false 
        private: true 
    - trim:
        default: 'true'
        required: false  
    
  java_action: 
    gav: 'io.cloudslang.content:cs-utilities:0.1.4'
    class_name: 'io.cloudslang.content.utilities.actions.DefaultIfEmpty'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
