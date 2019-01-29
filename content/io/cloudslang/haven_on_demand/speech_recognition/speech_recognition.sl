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
#! @description: Creates a transcript of the text in an audio or video file.
#!
#! @input api_key: API key
#! @input reference: Optional - Haven OnDemand reference
#!                   exactly one of <reference>, <file> is required
#! @input file: Optional - path to video file
#!              exactly one of <reference>, <file> is required
#! @input interval: Optional - use to segment the speech in the output. -1 to turn off
#!                  segmentation, 0 to segment on every word, and a positive
#!                  number for a time interval (ms).
#!                  default: -1
#! @input language: Optional - language of the provided speech
#!                  default value: en-US.
#! @input proxy_host: Optional - proxy server
#! @input proxy_port: Optional - proxy server port
#!
#! @output job_id: id of request returned by Haven OnDemand
#!
#! @result SUCCESS: audio or video file created successfully based on the transcript
#! @result FAILURE: There was an error while trying to create the audio or video file from the transcript
#!!#
########################################################################################################################

namespace: io.cloudslang.haven_on_demand.speech_recognition

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  print: io.cloudslang.base.print

flow:
  name: speech_recognition

  inputs:
    - api_key:
        sensitive: true
    - speech_api:
        default: "https://api.havenondemand.com/1/api/async/recognizespeech/v1"
        private: true
    - reference:
        required: false
    - file:
        required: false
    - interval:
        default: '-1'
        required: false
    - language:
        default: 'en-US'
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - connect_to_server:
        do:
          http.http_client_action:
            - url: ${str(speech_api)}
            - method: 'POST'
            - multipart_bodies: >
                ${'apikey=' + str(api_key) + (('&reference=' + str(reference)) if reference else '') +
                '&interval=' + str(interval) + '&language=' + str(language)}
            - multipart_files: ${('file=' + str(file)) if file else ''}
            - proxy_host
            - proxy_port
        publish:
          - error_message
          - return_result

    - get_result_value:
        do:
         json.get_value:
           - json_input: ${return_result}
           - json_path: "jobID"
        publish:
          - value: ${return_result}
          - error_message

    - on_failure:
        - print_fail:
            do:
              print.print_text:
                - text: ${"Error - " + error_message}

  outputs:
    - job_id: ${value}
