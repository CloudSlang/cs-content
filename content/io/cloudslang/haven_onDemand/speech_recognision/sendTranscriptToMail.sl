
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
#! @input apikey: user's API Keys
#! @input speechApi:  Speech Recognision API
#! @input file: path to video/audio, witch recognising
#! @input speechResultApi: API which waits until the job has finished and then returns the result
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
  name: sendTranscriptToMail

  inputs:
    - apikey: ${get_sp('io.cloudslang.haven_onDemand.apikey')}
    - speechApi: ${get_sp('io.cloudslang.haven_onDemand.speechApi')}
    - file: ${get_sp('io.cloudslang.haven_onDemand.file')}
    - speechResultApi: ${get_sp('io.cloudslang.haven_onDemand.speechResultApi')}
    - hostname: ${get_sp('io.cloudslang.haven_onDemand.hostname')}
    - port: ${get_sp('io.cloudslang.haven_onDemand.port')}
    - from: ${get_sp('io.cloudslang.haven_onDemand.from')}
    - to: ${get_sp('io.cloudslang.haven_onDemand.to')}

  workflow:

    - startingConnection:
          do:
            speechRecognision:
               - speechApi
               - file
               - apikey

          publish:
             - jobID
             - error_message

    - getResultRecognision:
           do:
             checkStatus:
               - speechResultApi
               - jobID
               - apikey

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
     - result: ${ " jobID "  + str(jobID) +  " status " + status}
