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
#! @description: This operation converts the unix/epoch time into date format.
#!
#! @input epoch_time: The epoch time in milliseconds.
#!                    Example: 1675660713000
#! @input time_zone: The scheduler timeZone in UTC format.
#!                   Example: (UTC+05:30) Asia/Kolkata
#!
#! @output date_format: The converted date.
#!                      Example: 2023-02-06T10:48:33:00
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: Returns the date format.
#! @result FAILURE: An error has occurred while trying to convert unix time to date format.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.utils

operation:
  name: convert_epoch_time_without_timezone

  inputs:
    - epoch_time
    - epochTime:
        default: ${get('epoch_time', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-utilities:0.1.23-SNAPSHOT-102'
    class_name: 'io.cloudslang.content.utilities.actions.ConvertEpochTimeWithoutTimezone'
    method_name: 'execute'

  outputs:
    - date_format: ${get('dateFormat', '')}
    - utc_zone_offset: ${get('utcZoneOffset', '')}
    - time_difference: ${get('timeDifference', '')}
    - time_zone: ${get('timeZone', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE