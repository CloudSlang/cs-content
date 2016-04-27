
#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Sends to email transcript of the text in an audio or video file, with was created by Speech Recognition API.
#! @input api_key: user's API Keys
#! @input speech_api:  Speech Recognision API
#! @input file: path to video/audio, witch recognising
#! @input speech_result_api: API which waits until the job has finished and then returns the result
#! @input hostname: email host
#! @input port: email port
#! @input from: email sender
#! @input to: email recipient
#!!#
####################################################

namespace: io.cloudslang.haven_onDemand.speech_recognision

imports:
  rest: io.cloudslang.base.network.rest
  json: io.cloudslang.base.json
  file: io.cloudslang.base.files
  mail: io.cloudslang.base.mail
  base: io.cloudslang.base.print

flow:
  name: send_transcript_to_mail

  inputs:
    - api_key: ${get_sp('io.cloudslang.haven_onDemand.api_key')}
    - speech_api: ${get_sp('io.cloudslang.haven_onDemand.speech_api')}
    - file: ${get_sp('io.cloudslang.haven_onDemand.file')}
    - speech_result_api: ${get_sp('io.cloudslang.haven_onDemand.speech_result_api')}
    - hostname: ${get_sp('io.cloudslang.haven_onDemand.hostname')}
    - port: ${get_sp('io.cloudslang.haven_onDemand.port')}
    - from: ${get_sp('io.cloudslang.haven_onDemand.from')}
    - to: ${get_sp('io.cloudslang.haven_onDemand.to')}

  workflow:

    - start_connection:
          do:
            speech_recognision:
               - speech_api
               - file
               - api_key

          publish:
             - job_id
             - error_message

    - get_result_of_recognision:
           do:
             check_status:
               - speech_result_api
               - job_id
               - api_key

           publish:
             - error_message
             - status
             - transcript

    - send_mail:
        do:
          mail.send_mail:
            - hostname
            - port
            - from
            - to
            - subject: "${'Result of recognision ' + str(file)}"
            - body: >
                ${'Description: ' + str(transcript) + '\n'}
        publish:
          - error_message

    - on_failure:
            - print:
                 do:
                   base.print_text:
                      - text: ${error_message if error_message=="" else " Connection faild" }

  outputs:
     - result: ${ " jobID "  + str(job_id) +  " status " + status}
