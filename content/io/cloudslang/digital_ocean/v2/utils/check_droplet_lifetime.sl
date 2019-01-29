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
#! @description: Checks if a droplet's lifetime exceeds a given threshold.
#!
#! @input creation_time_as_string: Creation time (UTC timezone) of the droplet as a string value.
#!                                 Format (used by DigitalOcean): '2015-09-27T18:47:19Z'
#! @input threshold: Threshold in minutes to compare the droplet's lifetime to.
#!
#! @output return_result: Elapsed time in minutes in case of success, cause of the error in case of failure.
#! @output return_code: 0 if parsing was successful, -1 otherwise.
#!
#! @result FAILURE: An error occurred.
#! @result ABOVE_THRESHOLD: Lifetime of droplet reached the threshold.
#! @result BELOW_THRESHOLD: Lifetime of droplet did not reach the threshold.
#!!#
########################################################################################################################

namespace: io.cloudslang.digital_ocean.v2.utils

operation:
  name: check_droplet_lifetime

  inputs:
    - creation_time_as_string
    - threshold

  python_action:
    script: |
      try:
        from datetime import datetime

        creation_time = datetime.strptime(creation_time_as_string, '%Y-%m-%dT%H:%M:%SZ')
        current_time = datetime.utcnow()
        elapsed_time = (current_time - creation_time).total_seconds() / 60

        above_threshold = elapsed_time >= threshold

        return_code = '0'
        return_result = str(elapsed_time)

        del creation_time # cleanup, so engine will not complain (datetime is not serializable)
        del current_time
      except Exception as ex:
        return_code = '-1'
        return_result = ex

  outputs:
    - return_result
    - return_code

  results:
    - FAILURE: ${return_code != '0'}
    - ABOVE_THRESHOLD: ${above_threshold}
    - BELOW_THRESHOLD
