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
    - timezone
    - format

  python_action:
    script: |
      import datetime
      negative = "-"
      result_date = ""
      if negative in timezone:
        milliseconds = (int(zone.split(")")[0].split('-')[1].split(':')[0])*60 + int(zone.split(")")[0].split('-')[1].split(':')[1]))*60*1000
        ts = int(time) - milliseconds
      else:
        milliseconds = (int(timezone.split(")")[0].split('+')[1].split(':')[0])*60 + int(timezone.split(")")[0].split('+')[1].split(':')[1]))*60*1000
        ts = int(time) + milliseconds
      if(len(format) == 0):
        result_date = datetime.datetime.utcfromtimestamp(int(ts)/1000)
      else:
        result_date = datetime.datetime.utcfromtimestamp(int(ts)/1000).strftime(format)

  outputs:
    - result_date

  results:
    - SUCCESS
