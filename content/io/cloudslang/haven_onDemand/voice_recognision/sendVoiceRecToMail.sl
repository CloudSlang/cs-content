
#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Sends to email results of Speech Recognision, with was made by HPE Haven OnDemand API.
#! @input apikey: user's API Keys
#! @input video: path to video, witch recognising
#! @input url: URL to Speech Recognision API
#! @input urlForResult: URL for getting response from Haven OnDemand
#! @input hostname: email host
#! @input port: email port
#! @input from: email sender
#! @input to: email recipient
#!!#
####################################################

namespace: io.cloudslang.haven_onDemand.voice_recognision

imports:
  rest: io.cloudslang.base.network.rest
  json: io.cloudslang.base.json
  file: io.cloudslang.base.files
  mail: io.cloudslang.base.mail
  base: io.cloudslang.base.print

flow:
  name: sendVoiceRecToMail

  inputs:
    - apikey: ${get_sp('io.cloudslang.haven_onDemand.apikey')}
    - url: ${get_sp('io.cloudslang.haven_onDemand.url')}
    - video: ${get_sp('io.cloudslang.haven_onDemand.video')}
    - urlForResult: ${get_sp('io.cloudslang.haven_onDemand.urlForResult')}
    - hostname: "smtp3.hpe.com"
    - port: "25"
    - from: ${get_sp('io.cloudslang.haven_onDemand.from')}
    - to: ${get_sp('io.cloudslang.haven_onDemand.to')}

  workflow:

    - startingConnection:
          do:
            speechRecognision:
               - url
               - video
               - apikey

          publish:
             - jobID
             - error_message
          navigate:
            SUCCESS: getResultRecognision
            FAILURE: print

    - getResultRecognision:
           do:
             checkStatus:
               - url: ${urlForResult}
               - jobID: ${jobID}
               - apikey: ${apikey}

           publish:
             - error_message
             - result: ${resultOfRecogn}
           navigate:
              SUCCESS: send_mail
              FAILURE: print

    - send_mail:
        do:
          mail.send_mail:
            - hostname
            - port
            - from
            - to
            - subject: "${'Result of ecognision ' + str(video)'}"
            - body: >
                ${'Description: ' + str(result) + '\n'}
        publish:
          - error_message

    - on_failure:
            - print:
                 do:
                   base.print_text:
                      - text: ${error_message if error_message=="" else " Connection faild" }

  results:
    - SUCCESS: ${error_message==''}
    - FAILURE
