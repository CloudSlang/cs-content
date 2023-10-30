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
#! @description: Converts time with specified timezone and return the scheduler time.
#!
#! @input scheduler_time: Scheduler time in HH:MM:SS format
#! @input scheduler_time_zone: Scheduler timeZone.
#!
#! @output scheduler_start_time: Scheduler start time.
#! @output trigger_expression: Scheduler trigger expression.
#! @output time_zone: Scheduler timeZone.
#! @output exception: An error message in case there was an error while executing the request.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.utils

operation: 
  name: schedule_time
  
  inputs: 
    - scheduler_time    
    - schedulerTime: 
        default: ${get('scheduler_time', '')}
        private: true 
    - scheduler_time_zone    
    - schedulerTimeZone: 
        default: ${get('scheduler_time_zone', '')}
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-amazon:1.0.51'
    class_name: 'io.cloudslang.content.amazon.actions.utils.SchedulerTime'
    method_name: 'execute'
  
  outputs: 
    - scheduler_start_time: ${get('schedulerStartTime', '')} 
    - trigger_expression: ${get('triggerExpression', '')} 
    - time_zone: ${get('timeZone', '')} 
    - exception: ${get('exception', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
