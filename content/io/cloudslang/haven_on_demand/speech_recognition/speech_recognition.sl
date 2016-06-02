
#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Makes a call to the Speech Recognition by HPE Haven OnDemand API.
#! @input speech_api: speech Recognition API
#! @output job_id: name of request, which is returned by havenondemand.com
#!!#
####################################################
namespace: io.cloudslang.haven_on_demand.speech_recognition

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  base: io.cloudslang.base.print

flow:
  name: speech_recognition

  inputs:
    - speech_api
    - file
    - api_key:
        sensitive: true

  workflow:

    - connect_to_server:
        do:
          http.http_client_action:
            - url: ${speech_api}
            - method: POST
            - multipart_bodies: ${"apikey=" + str(api_key)}
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
      - job_id: ${value}
