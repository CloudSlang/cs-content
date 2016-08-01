#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Makes a Haven OnDeman API call to transcribe a video and waits for the response.
#!
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
#! @output return_result: result of API
#! @output error_message: error message if one exists, empty otherwise
#!!#
####################################################

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
            - seconds: 10
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
