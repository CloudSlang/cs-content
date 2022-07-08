#   (c) Copyright 2022 Micro Focus, L.P.
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
#! @description: This operation converts the unix time into given format.
#!
#! @input time: Python regex expression.
#! @input timezone: The UTC timezone.
#!                  Example: (UTC+05:30) Asia/Kolkata
#! @input format: The format into which the unix time needs to be converted.
#!                Example: '%Y-%m-%dT%H:%M:%S'
#!
#! @output result_date: Date or time in given format.
#!
#! @result SUCCESS: Always.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.utils

operation:
  name: time_format

  inputs:
    - time
    - epochTime:
        default: ${get('time', '')}
        private: true
    - timeZone
    - timeZone:
        default: ${get('timeZone', '')}
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.43-RC5'
    class_name: 'io.cloudslang.content.amazon.actions.utils.GetTimeFormat'
    method_name: 'execute'

  outputs:
    - result_date: ${get('dateFormat', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE
