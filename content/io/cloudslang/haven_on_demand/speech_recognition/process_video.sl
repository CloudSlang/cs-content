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
#! @description: Makes a Haven OnDemand API call to transcribe a video and waits for the response.
#!
#! @input api_key: API key
#! @input reference: Optional - Haven OnDemand reference
#!                   exactly one of <reference>, <file> is required
#! @input file: Optional - path to video file
#!              exactly one of <reference>, <file> is required
#! @input interval: Optional - use to segment the speech in the output. -1 to turn off
#!                  segmentation, 0 to segment on every word, and a positive
#!                  number for a time interval (ms).
#!                  optional:
#!                  default: -1
#! @input language: Optional - language of the provided speech
#!                  default value: en-US.
#! @input proxy_host: Optional - proxy server
#! @input proxy_port: Optional - proxy server port
#!
#! @output return_result: result of API
#! @output error_message: error message if one exists, empty otherwise
#!
#! @result SUCCESS: video transcribed successfully
#! @result FAILURE: There was an error while trying to transcribe the video
#!!#
########################################################################################################################

namespace: io.cloudslang.haven_on_demand.speech_recognition

imports:
  print: io.cloudslang.base.print
  utils: io.cloudslang.base.utils
  hod: io.cloudslang.haven_on_demand

flow:
  name: process_video

  inputs:
    - api_key:
        sensitive: true
    - reference:
        required: false
    - file:
        required: false
    - interval:
        required: false
    - language:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - speech_recognition_api_call:
        do:
          hod.speech_recognition.speech_recognition:
            - api_key
            - reference
            - file
            - interval
            - language
            - proxy_host
            - proxy_port
        publish:
          - job_id
          - error_message
          - return_result

    - speech_recognition_response:
        do:
          hod.utils.check_status:
            - api_key
            - job_id
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - error_message
        navigate:
          - FINISHED: SUCCESS
          - IN_PROGRESS: wait
          - QUEUED: wait
          - FAILURE: on_failure

    - wait:
        do:
          utils.sleep:
            - seconds: "10"
        publish:
          - error_message
        navigate:
          - SUCCESS: speech_recognition_response
          - FAILURE: on_failure

    - on_failure:
        - print_fail:
            do:
              print.print_text:
                - text: ${"Error - " + error_message}

  outputs:
    - return_result
    - error_message
