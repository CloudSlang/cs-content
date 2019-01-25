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
#! @description: Sleeps for a given number of seconds.
#!
#! @input seconds: Time to sleep.
#!
#! @output message: Sleep completed successfully.
#! @output error_message: If there is an exception or error message.
#!
#! @result SUCCESS: Sleep successful.
#! @result FAILURE: Something went wrong.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.utils

operation:
  name: sleep

  inputs:
    - seconds

  python_action:
    script: |
      try:
        import time
        error_message = ""
        message = ""
        x = float(seconds)
        if(x < 0):
          error_message = "timeout value is negative"
        else:
          time.sleep(x)
          message = "sleep completed successfully"
      except ValueError:
        error_message = "invalid input value"

  outputs:
      - message
      - error_message

  results:
    - SUCCESS: ${error_message==""}
    - FAILURE
