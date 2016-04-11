
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
#! @input urlOfVideo: url of video, witch recognising (use example from www.havenondemand.com)
#! @input url: URL to Speech Recognision API
#! @input urlForResult: URL for getting response from Haven OnDemand
#! @input email: user's email
#!!#
####################################################

namespace: io.cloudslang.haven_onDemand.voice_recognision

imports:
  rest: io.cloudslang.base.network.rest
  json: io.cloudslang.base.json
  file: io.cloudslang.base.files
  mail: io.cloudslang.base.mail

flow:
  name: sendVoiceRecToMail

  inputs:
    - apikey: ${get_sp('io.cloudslang.haven_onDemand.apikey')}
    - urlOfVideo: ${get_sp('io.cloudslang.haven_onDemand.urlOfVideo')}
    - url: ${get_sp('io.cloudslang.haven_onDemand.url') + str(urlOfVideo) + "&apikey=" + str(apikey)}
    - urlForResult: ${get_sp('io.cloudslang.haven_onDemand.urlForResult')}
    - proxy_host
    - proxy_port
    - from
    - to
    - hostname
    - port


  workflow:

    - startingConnection:
          do:
            speechRecognision:
               - url
               - proxy_host
               - proxy_port
          publish:
             - jobID

    - getResultRecognision:
           do:
             checkStatus:
               - url: ${urlForResult}
               - jobID: ${jobID}
               - apikey: ${apikey}
               - proxy_host
               - proxy_port

           publish:
             - error_message
             - result: ${resultOfRecogn}

    - send_mail:
        do:
          mail.send_mail:
            - hostname
            - port
            - from: ${from}
            - to: ${to}
            - subject: "${'Test recognision'}"
            - body: >
                ${'Recult of recognision : ' + str(result) }
        publish:
          - error_message

  results:
    - SUCCESS: ${error_message==''}
    - FAILURE
