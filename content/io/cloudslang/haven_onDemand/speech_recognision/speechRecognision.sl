
#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Makes Speech Recognision by HPE Haven OnDemand API.
#! @input speechApi: Speech Recognision API
#! @output jobID: name of request, witch is returned by havenondemand.com
#!!#
####################################################
namespace: io.cloudslang.haven_onDemand.speech_recognision

imports:
  rest: io.cloudslang.base.network.rest
  json: io.cloudslang.base.json
  base: io.cloudslang.base.print

flow:
  name: speechRecognision

  inputs:
    - speechApi
    - file
    - apikey

  workflow:

    - connect_to_server:
        do:
          rest.http_client_action:
            - url: ${speechApi}
            - method: POST
            - multipart_bodies: ${"apikey=" + str(apikey)}
            - multipart_files: ${file}

        publish:
            - error_message
            - return_result
            - return_code

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
                  base.print_text:
                    - text: "${error_message}"
  outputs:
      - jobID: ${value}
