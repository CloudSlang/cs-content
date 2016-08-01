#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Creates a transcript of the text in an audio or video file.
#! @input api_key: API key
#! @input reference: Haven OnDemand reference
#!                   optional - exactly one of <reference>, <file> is required
#! @input file: path to video file
#!              optional - exactly one of <reference>, <file> is required
#! @input interval: use to segment the speech in the output. -1 to turn off
#!                  segmentation, 0 to segment on every word, and a positive
#!                  number for a time interval (ms).
#!                  optional:
#!                  default: -1
#! @input language: language of the provided speech
#!                  optional
#!                  default value: en-US.
#! @input proxy_host: proxy server
#!                    optional
#! @input proxy_port: proxy server port
#!                    optional
#! @output job_id: id of request returned by Haven OnDemand
#!!#
####################################################
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
            - multipart_bodies: ${'apikey=' + str(api_key) + (('&reference=' + str(reference)) if reference else '') + '&interval=' + str(interval) + '&language=' + str(language)}
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
           - json_path: [jobID]
        publish:
          - value
          - error_message
    - on_failure:
        - print_fail:
            do:
              print.print_text:
                - text: ${"Error - " + error_message}
  outputs:
    - job_id: ${value}
